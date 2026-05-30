# Saturn Setup Runbook — DittoDatto Hub (Staging)

> **Hand-off document for an SSH-capable agent operating on Saturn.**
> Source session: `/grill foundation` (Conductor v2.1), 2026-05-26.
> Authoritative architecture: [ADR-0003](conductor/adr/0003-saturn-staging-environment.md) "Saturn as Staging Environment".
>
> **Purpose:** Stand up the DittoDatto Hub (SurrealDB 3.0) on Saturn as the staging-environment source of truth, behind Tailscale, leaving the existing OpenWebUI on `saturn:8080` untouched.
>
> **Estimated execution time:** 15–25 minutes for a fresh box; 5–10 minutes if Docker is already installed.
> **Reversible?** Yes — `docker compose down -v` + `rm -rf /srv/dittodatto` returns Saturn to its current state.

---

## 0. Machine context (verify before starting)

| Field | Expected value (per Tailscale screenshot 2026-05-26) |
|---|---|
| OS hostname | `Saturn` |
| OS | Linux 6.17.0-1018-nvidia (NVIDIA kernel — Ubuntu/Debian family) |
| Tailscale machine name | `saturn` |
| Tailscale tailnet | `tailb251cd.ts.net` |
| Tailscale IPv4 | `100.87.99.59` |
| Full MagicDNS | `saturn.tailb251cd.ts.net` |
| Creator / owner email | `arnarvalur@avj.info` |
| Tailscale version | `1.98.2` |

**Pre-existing services that MUST NOT be disturbed:**

| Port | Service | Owner | Action |
|---|---|---|---|
| `8080` | OpenWebUI | Arnar — non-DittoDatto | **DO NOT TOUCH.** Verify still healthy after this runbook completes. |

If any of these don't match, **stop and report** before running anything destructive.

---

## 1. Preconditions

Run as the agent's regular user (assume passwordless `sudo` is available, otherwise add `sudo` where appropriate). All checks should pass before proceeding.

```bash
# 1.1 — Verify Tailscale is up and Saturn is reachable on tailnet
tailscale status | head -5
tailscale ip -4   # expect 100.87.99.59

# 1.2 — Verify Docker + Docker Compose v2
docker --version          # expect 24.x+
docker compose version    # expect v2.x (note: subcommand, not `docker-compose`)

# 1.3 — Verify the planned ports are FREE (except 8080 which belongs to OpenWebUI)
for port in 8001 8002 8003 8004; do
  if ss -tlnp 2>/dev/null | grep -q ":$port "; then
    echo "PORT $port IS IN USE — STOP. Investigate before proceeding."
    ss -tlnp | grep ":$port "
  else
    echo "Port $port free ✓"
  fi
done

# 1.4 — Verify OpenWebUI on 8080 is still up (sanity check, must pass before AND after this runbook)
curl -sS -o /dev/null -w "OpenWebUI health: %{http_code}\n" http://localhost:8080/ || echo "WARNING: OpenWebUI not responding"
```

If any check fails, **stop and report** the failing line.

---

## 2. Install Docker (skip if already present)

If `docker --version` failed in §1.2, install the official Docker CE on Ubuntu:

```bash
# Official Docker convenience script (verify against https://get.docker.com first if paranoid)
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
# Re-login or `newgrp docker` to apply group change
```

Verify again: `docker --version` and `docker compose version`.

---

## 3. Filesystem layout

```bash
sudo mkdir -p /srv/dittodatto/{data/surrealdb,data/mercury-engine,backups}
sudo chown -R "$USER:$USER" /srv/dittodatto
cd /srv/dittodatto
```

Final structure:

```
/srv/dittodatto/
├── docker-compose.yml
├── .env
├── data/
│   ├── surrealdb/        # SurrealDB RocksDB persistent volume
│   └── mercury-engine/   # Reserved for MercuryEngine logs/cache when deployed
└── backups/              # Reserved for future SurrealDB exports
```

---

## 4. Create `.env`

**Generate a strong SurrealDB root password first** (32+ random alphanumeric):

```bash
SURREAL_PASS_VALUE=$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)
echo "Generated SurrealDB password — STORE THIS IN BITWARDEN AND IN ARNAR'S NEXT MESSAGE BEFORE PROCEEDING:"
echo "$SURREAL_PASS_VALUE"
```

> **CRITICAL:** This password is the master key to the DittoDatto Hub. Save it to Bitwarden (entry name: `DittoDatto Hub — SurrealDB root, Saturn`) AND echo it back to Arnar so he can store it. Do NOT proceed past this point without confirmation that the password is saved.

Then write `.env`:

```bash
cat > /srv/dittodatto/.env <<EOF
# DittoDatto Hub — Saturn staging environment
# Created: 2026-05-26 (initial /grill foundation runbook)

# SurrealDB root credentials
SURREAL_USER=dittodatto_root
SURREAL_PASS=${SURREAL_PASS_VALUE}

# Port assignments (all bound to Tailnet IP only — see Section 5)
SURREAL_PORT=8001
MERCURY_PORT=8002
# Reserved for future:
#   8003 — Ditto agent (consumer LLM)
#   8004 — Datto agent (business LLM)
#   8005 — Future internal admin/metrics endpoint

# Tailnet binding — Saturn's stable Tailscale IPv4
TAILNET_IP=100.87.99.59

# Environment label
DITTODATTO_ENV=staging
LOG_LEVEL=info
EOF

chmod 600 /srv/dittodatto/.env
```

---

## 5. Write `docker-compose.yml`

```bash
cat > /srv/dittodatto/docker-compose.yml <<'EOF'
# DittoDatto Hub — Saturn staging stack
# Source ADR: ADR-0003 "Saturn as Staging Environment" (conductor/adr/0003-saturn-staging-environment.md)
# Maintained by: future /new-track infrastructure-saturn

name: dittodatto-net

services:
  # ─── DittoDatto Hub: SurrealDB 3.0 ───────────────────────────────
  # The single source of truth for staging data. Hosts both namespaces:
  #   companies ({slug}, discovery, registry)   — non-PII platform data
  #   users (profiles)                          — GDPR-isolated consumer PII
  # Per ADR canonical 0002 (namespace architecture, renamed from legacy titan/enceladus).
  surrealdb:
    image: surrealdb/surrealdb:latest  # TODO: pin to v3.x once a stable tag exists; verify v3.0 release status
    container_name: dittodatto-hub
    restart: unless-stopped
    command:
      - start
      - --bind
      - 0.0.0.0:8000
      - --user
      - ${SURREAL_USER}
      - --pass
      - ${SURREAL_PASS}
      - --log
      - ${LOG_LEVEL}
      - rocksdb:/data/dittodatto.db
    volumes:
      - ./data/surrealdb:/data
    ports:
      # Bind ONLY to Saturn's Tailscale IPv4 — no LAN/WAN exposure.
      # Tailnet clients reach it at: http://saturn:8001  (MagicDNS)
      # or: http://100.87.99.59:8001
      - "${TAILNET_IP}:${SURREAL_PORT}:8000"
    healthcheck:
      test: ["CMD-SHELL", "wget -q --spider http://localhost:8000/health || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s
    labels:
      - "dittodatto.role=database"
      - "dittodatto.env=staging"
      - "dittodatto.adr=0001,0002"

  # ─── MercuryEngine (FastAPI/Pydantic v2) — DISABLED until image exists ───
  # Uncomment once the staging Docker image is built and pushed to a registry
  # accessible from Saturn (GHCR, Docker Hub, or a private registry).
  #
  # mercury-engine:
  #   image: ghcr.io/merkurial-studio/mercury-engine:staging  # TODO: confirm registry path
  #   container_name: dittodatto-mercury-engine
  #   restart: unless-stopped
  #   environment:
  #     - SURREAL_URL_COMPANIES=ws://surrealdb:8000/rpc
  #     - SURREAL_URL_USERS=ws://surrealdb:8000/rpc
  #     - SURREAL_USER=${SURREAL_USER}
  #     - SURREAL_PASS=${SURREAL_PASS}
  #     - SURREAL_NS_COMPANIES=companies
  #     - SURREAL_NS_USERS=users
  #     - ENVIRONMENT=${DITTODATTO_ENV}
  #     - LOG_LEVEL=${LOG_LEVEL}
  #   ports:
  #     - "${TAILNET_IP}:${MERCURY_PORT}:8000"  # FastAPI internal port 8000
  #   depends_on:
  #     surrealdb:
  #       condition: service_healthy
  #   labels:
  #     - "dittodatto.role=api"
  #     - "dittodatto.env=staging"

networks:
  default:
    name: dittodatto-net
    driver: bridge
    # Umbrella network for all DittoDatto containers on Saturn.
    # Future DD services (Ditto/Datto agents) join this same network.
EOF
```

---

## 6. First boot

```bash
cd /srv/dittodatto
docker compose up -d
docker compose ps                  # expect dittodatto-hub: running (healthy after ~15s)
docker compose logs --tail=50 surrealdb
```

Expected log signature (modulo SurrealDB version-specific phrasing):

```
INFO surreal::dbs: Started web server on 0.0.0.0:8000
INFO surreal::dbs: Database engine: rocksdb:/data/dittodatto.db
```

If the container restarts repeatedly, check:

1. Volume permissions — `ls -ld /srv/dittodatto/data/surrealdb` should be owned by the user running Docker.
2. `--bind` address — must be `0.0.0.0:8000` inside the container (the host-side bind is handled by the `ports:` mapping).
3. RocksDB write capability — disk full, perms, etc.

---

## 7. Smoke test from Saturn itself

```bash
# Loopback test (proves the container is alive)
curl -sS http://127.0.0.1:8001/health
# Expect: response from SurrealDB health endpoint (200 OK with body indicating health)

# Tailnet IP test (proves the port binding worked)
curl -sS http://100.87.99.59:8001/health

# Confirm OpenWebUI is still alive (regression check)
curl -sS -o /dev/null -w "OpenWebUI: %{http_code}\n" http://localhost:8080/
```

---

## 8. Smoke test from a remote tailnet machine

From Arnar's dev workstation (or any other tailnet client):

```bash
curl -sS http://saturn:8001/health
# Expect: same response as the loopback test above
```

If this fails but the Saturn-side curl works, suspect:

- MagicDNS not enabled on the tailnet (check Tailscale admin panel)
- Tailscale ACLs blocking the port (check ACL config — should be open by default for owner devices)

---

## 9. Initial namespace + auth setup (deferred — DO NOT RUN YET)

The DittoDatto Hub schemas (`companies/{slug}`, `companies/discovery`, `companies/registry`, `users/profiles`) are **not** applied by this runbook. They depend on MercuryEngine schema files that are currently still in `DittoDatto-old/schemas/` and will be migrated in a future track.

When that track lands, the steps will be approximately:

```bash
# Future — do not run today
docker compose exec surrealdb /surreal import --conn http://localhost:8000 \
  --user ${SURREAL_USER} --pass ${SURREAL_PASS} \
  --ns companies --db registry /schemas/registry.surql
# … and similar for discovery, {slug} blueprints, users/profiles
```

Until then, the Hub is intentionally empty.

---

## 10. Report back

When the runbook completes (or fails at any step), report the following back to Arnar:

```
DittoDatto Hub setup — REPORT
================================
- Section 1 preconditions:        PASS / FAIL (which check)
- Section 2 Docker install:       SKIPPED / INSTALLED
- Section 4 password generated:   STORED IN BITWARDEN: YES / NO
- Section 6 container status:     <docker compose ps output>
- Section 7 loopback curl:        <response or error>
- Section 8 remote tailnet curl:  <response or error>
- OpenWebUI on :8080:             STILL HEALTHY: YES / NO
- Disk usage (/srv/dittodatto):   <du -sh output>
- Any deviations from runbook:    <free text>
```

---

## Out of scope for this runbook (deferred)

| Concern | Deferred to |
|---|---|
| Applying SurrealDB schemas (`companies`, `users` namespaces) | Future MercuryEngine migration track |
| Seeding dogfood data (Merkurial Studio + dittodatto companies) | Future dogfood-seed track |
| Building + publishing the MercuryEngine Docker image | Future CI/build track |
| Caddy / reverse proxy for HTTPS hostnames | Optional polish — Tailscale's built-in TLS via `tailscale serve` is sufficient for now |
| Tailscale Service `dittodatto` configuration (admin panel: ports + ACL tags) | Handled by Arnar via the Tailscale admin UI in parallel with this runbook. Once configured, services reach the Hub via `dittodatto.tailb251cd.ts.net:<port>` in addition to `saturn:<port>`. |
| Future Ditto/Datto agent containers (NVIDIA GPU inference) | Future agent-runtime track (Saturn's NVIDIA kernel preserves this option) |
| Backup / restore automation | Future ops track |
| Monitoring (Prometheus, logs aggregation) | Future ops track |

---

## Source of authority

- **Decision record:** [ADR-0003](conductor/adr/0003-saturn-staging-environment.md) "Saturn as Staging Environment" (committed 2026-05-26, `/grill foundation`).
- **Domain context:** `conductor/context.md` (Saturn, DittoDatto Hub, Tailscale entities + `companies` / `users` namespaces — consolidated during foundation grill).
- **Tech stack:** `conductor/project-context.md` §3 (Deployment Targets — synced 2026-05-26 post-grill).
- **Historical anchor (stale, do NOT execute):** `conductor/docs/legacy/postit/saturn-local-stack.md` — pre-disruption, still references Firebase Emulator / Hono / TheOracle / Cloudflare Tunnel, all of which are dead.
