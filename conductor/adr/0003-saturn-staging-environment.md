# Saturn as Staging Environment

> **Recorded:** 2026-05-26 (new — /grill foundation)
> **Status:** accepted

## Context

DittoDatto needs a staging environment that:
1. Validates behaviour end-to-end before production deployment to Cloud Run.
2. Is reachable from the development workstation, mobile devices (tablet, phones), and AI agents (Cursor, future Ditto/Datto).
3. Is not publicly exposed — only the team and trusted guests should reach it.
4. Iterates faster than chasing Cloud Run deploys for every change.

Saturn (NVIDIA GX10, Ubuntu Linux `6.17.0-1018-nvidia` kernel, hostname `Saturn`) was acquired May 2026 and has been idle for ~3 weeks due to a workstation failure on the day Saturn arrived. It sits on the developer's desk, always-on, and is already authenticated to the Merkurial Studio Tailscale tailnet at `saturn.tailb251cd.ts.net` (Tailscale IPv4 `100.87.99.59`). An unrelated OpenWebUI instance occupies `saturn:8080` and is outside DittoDatto scope.

## Decision

**Saturn is the canonical staging environment for the DittoDatto Ecosystem.** Deployment is via Docker on Saturn; access is via Tailscale (no public exposure). The DittoDatto Hub (SurrealDB 3.0 instance — ADR-0001) lives here as the staging source of truth.

**Saturn is staging only — never the production target.** Production is Cloud Run `europe-west1` (sole production target — see project-context.md §3).

## Access Model

| Audience | Access Method |
|---|---|
| Developers (Arnar, Höddi) | Tailscale-authenticated devices on the merkurial-studio tailnet |
| AI agents (Cursor, future Ditto/Datto) | Tailscale auth via tagged ACL or ephemeral keys |
| Occasional showcase guests | Time-limited Tailscale share (per-visitor) |
| The public Internet | **Never.** |

Services bind to Saturn's Tailscale IPv4 (`100.87.99.59`) only. No LAN/WAN exposure. Tailscale MagicDNS resolves `saturn:<port>` for tailnet clients.

## Stack

| Concern | Component | Port (host) |
|---|---|---|
| Database | SurrealDB 3.0 (DittoDatto Hub) | `8001` |
| API | MercuryEngine V2 (FastAPI staging build) | `8002` |
| Future agent runtime | Ditto agent | `8003` (reserved) |
| Future agent runtime | Datto agent | `8004` (reserved) |
| Out-of-scope, untouched | OpenWebUI (existing) | `8080` |

Setup runbook for the adjacent SSH-capable agent: `saturn-setup-runbook.md` at workspace root.

## Deploy Flow

1. Develop on the developer workstation (independent SurrealDB instance, local MercuryEngine).
2. Push code to git.
3. SSH to Saturn (`ssh saturn` via Tailscale), `git pull` + `docker compose up -d` in `/srv/dittodatto/`.
4. Validate end-to-end against the DittoDatto Hub from any tailnet client (workstation, tablet, phone).
5. When green, proceed with Cloud Run deployment.

No CI integration is required for staging — the loop is fast enough manually.

## What Saturn is NOT

- Not a production target. Production scales horizontally on Cloud Run; Saturn is single-box.
- Not the dev environment. Dev runs locally on the workstation.
- Not publicly exposed. No reverse proxy with public DNS; no Cloudflare Tunnel; no Tailscale Funnel.
- Not a permanent home for prod data. Staging data is dogfood (Merkurial Studio + dittodatto companies); can be wiped any time.

## Considered Options

| Option | Rejected because |
|---|---|
| Cloud Run staging (separate Cloud Run project) | Slow deploy cycles; cost; chases cloud rather than validates locally. |
| Third-party PaaS (Coolify, Render, Railway) | Adds external dependency; Tailscale + Docker is sufficient. |
| Kubernetes on Saturn | Massive overkill for two-developer staging. |
| Self-hosting production on Saturn | Production must scale to thousands of consumers + hundreds of companies — Saturn is single-box. |

## Consequences

- Tailscale is required for all developer, agent, and guest access. No Tailscale = no Saturn.
- Saturn must remain always-on (confirmed by the user — Saturn does not power down).
- Saturn's NVIDIA kernel preserves the option to host future Ditto/Datto LLM agents on-prem for inference. That decision is deferred to a future agent-runtime track.
- The pre-existing OpenWebUI on `saturn:8080` is preserved untouched.
- A future Tailscale domain alias (e.g., `dittodatto.<tailnet>` or similar) may segment Hub services from non-Hub services on Saturn — explicitly deferred as mechanical-trivial, not ADR-worthy.
- Cloud Run remains the sole production target. The current `dittodatto.no` Nuxt marketing webapp is the only Cloud Run-hosted service at v1.0.

---

*Origin: /grill foundation 2026-05-26 — workstation rebuild + Saturn arrival prompted the staging-environment lock-in.*
