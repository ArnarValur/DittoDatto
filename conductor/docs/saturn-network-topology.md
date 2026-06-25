# Saturn Network Topology

> **Updated:** 2026-06-25
> **Config:** `/srv/dittodatto/.env` + `/srv/dittodatto/docker-compose.yml`

---

## Active Topology

```mermaid
graph TB
    subgraph tailscale["Tailscale Mesh (private, encrypted, WireGuard)"]
        pluto["🖥️ PlutoII<br/>100.69.153.40<br/>(dev laptop)"]
        mercury["📱 Mercury<br/>100.105.246.105<br/>(Samsung S21 — Arnar)"]
        pickle["📱 PocketPickle<br/>(Höddi — stakeholder)"]
        gurkan["🖥️ CyberGurkan<br/>100.101.248.99<br/>(Höddi — Windows)"]
        dd_service["🔷 dittodatto<br/>100.121.237.101<br/>(Tailscale Service)"]
        saturn_machine["🟢 saturn<br/>100.87.99.59<br/>(Machine IP)"]
    end

    subgraph saturn["Saturn Host — ASUS Ascent GX10 (ARM64, 20-core, 122GB RAM)"]
        saturn_machine
        dd_service
        subgraph docker["Docker: dittodatto-net"]
            hub["dittodatto-hub<br/>SurrealDB 3.1.2<br/>container :8000"]
            caddy_admin["dittodatto-caddy<br/>Admin Panel<br/>container :8002"]
            caddy_bp["dittodatto-portal-caddy<br/>Business Portal<br/>container :8003"]
        end
        bind["0.0.0.0<br/>(all interfaces)"]
    end

    hub -->|"0.0.0.0:8001 → :8000"| bind
    caddy_admin -->|"0.0.0.0:8002 → :8002"| bind
    caddy_bp -->|"0.0.0.0:8003 → :8003"| bind

    pluto -->|"✅ dittodatto:8001"| dd_service
    pluto -->|"✅ saturn:8001"| saturn_machine
    mercury -->|"✅ ws://100.87.99.59:8001/rpc"| saturn_machine

    style bind fill:#00b894,color:#fff
    style hub fill:#2d3436,color:#fff
    style caddy_admin fill:#2d3436,color:#fff
    style caddy_bp fill:#2d3436,color:#fff
    style mercury fill:#6c5ce7,color:#fff
    style pluto fill:#0984e3,color:#fff
    style dd_service fill:#0984e3,color:#fff
    style saturn_machine fill:#00b894,color:#fff
```

## Tailscale Dual-IP Note

> [!IMPORTANT]
> Saturn has **two** Tailscale IPs. Containers must bind to `0.0.0.0` to be reachable from both.

| Name | IP | Type | Resolves via |
|------|----|------|-------------|
| `saturn` | `100.87.99.59` | Machine IP | `getent hosts saturn` |
| `dittodatto` | `100.121.237.101` | Tailscale Service | `getent hosts dittodatto` |

Browsers and CLI tools use the `dittodatto` hostname (Service IP). The Flutter app uses the machine IP directly via `--dart-define`. Both work because `TAILNET_IP=0.0.0.0`.

## Port Map

| Port | Service | Container | Protocol | Used by |
|------|---------|-----------|----------|---------|
| `:8001` | SurrealDB (DittoDatto Hub) | `dittodatto-hub` | WebSocket `/rpc` | All Flutter apps (direct-to-DB) |
| `:8002` | Admin Panel | `dittodatto-caddy` | HTTP | Arnar + Höddi via browser |
| `:8003` | Business Portal | `dittodatto-portal-caddy` | HTTP | Business users via browser |
| `:8004` | Public Marketplace | *(planned)* | HTTP | Consumers via browser |
| `:8005` | APK Downloads | *(planned)* | HTTP | Höddi's phone (static file server) |
| `:8085` | SurrealDB (OpenWebUI) | `owui-surrealdb` | WebSocket | OpenWebUI only (separate stack) |

## Security

> [!NOTE]
> **Zero internet exposure.** Saturn has no public IP. All ports are reachable **only** from Tailscale peers. `0.0.0.0` binding is safe because the only network interfaces are Tailscale (WireGuard) and the local Docker bridge.

Authorized Tailscale peers: PlutoII (Arnar), Mercury (Arnar phone), CyberGurkan (Höddi), PocketPickle (Höddi phone).

## Config Reference

**`.env` (`/srv/dittodatto/.env`):**
```
TAILNET_IP=0.0.0.0
SURREAL_PORT=8001
```

**`docker-compose.yml`** uses `${TAILNET_IP}:${SURREAL_PORT}:8000` for port binding.

**BP portal caddy** runs outside compose (manual `docker run` with `-p 0.0.0.0:8003:8003`).
