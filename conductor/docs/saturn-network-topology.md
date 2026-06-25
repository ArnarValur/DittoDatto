# Saturn Network — Current vs Proposed

## Current State: Everything on localhost

```mermaid
graph TB
    subgraph tailscale["Tailscale Mesh (100.x.x.x)"]
        pluto["🖥️ PlutoII<br/>100.69.153.40<br/>(your laptop)"]
        mercury["📱 Mercury<br/>100.105.246.105<br/>(Samsung S21)"]
        saturn_ts["🔵 Saturn Tailscale IP<br/>100.87.99.59"]
    end

    subgraph saturn["Saturn Host (GX10)"]
        saturn_ts
        subgraph docker["Docker: dittodatto-net"]
            hub["dittodatto-hub<br/>SurrealDB 3.1<br/>container :8000"]
            caddy_admin["dittodatto-caddy<br/>Admin Panel<br/>container :8002"]
            caddy_bp["dittodatto-portal-caddy<br/>Business Portal<br/>container :8003"]
        end
        lo["127.0.0.1<br/>(localhost)"]
    end

    hub -->|"127.0.0.1:8001 → :8000"| lo
    caddy_admin -->|"127.0.0.1:8002 → :8002"| lo
    caddy_bp -->|"127.0.0.1:8003 → :8003"| lo

    pluto -.->|"❌ Can't reach :8001"| saturn_ts
    mercury -.->|"❌ Can't reach :8001"| saturn_ts

    style lo fill:#ff6b6b,color:#fff
    style hub fill:#2d3436,color:#fff
    style caddy_admin fill:#2d3436,color:#fff
    style caddy_bp fill:#2d3436,color:#fff
    style mercury fill:#6c5ce7,color:#fff
    style pluto fill:#0984e3,color:#fff
```

> [!CAUTION]
> All 3 containers bind to `127.0.0.1` — **nothing is reachable** from the Tailscale mesh. The web apps only work because you browse from Saturn itself or SSH tunnel.

---

## Proposed: Bind to Tailscale IP

```mermaid
graph TB
    subgraph tailscale["Tailscale Mesh (private, encrypted)"]
        pluto["🖥️ PlutoII<br/>100.69.153.40"]
        mercury["📱 Mercury (S21)<br/>100.105.246.105"]
        saturn_ts["🔵 Saturn<br/>100.87.99.59"]
    end

    subgraph saturn["Saturn Host (GX10)"]
        saturn_ts
        subgraph docker["Docker: dittodatto-net"]
            hub["dittodatto-hub<br/>SurrealDB 3.1<br/>container :8000"]
            caddy_admin["dittodatto-caddy<br/>Admin Panel<br/>container :8002"]
            caddy_bp["dittodatto-portal-caddy<br/>Business Portal<br/>container :8003"]
            caddy_mp["dittodatto-marketplace-caddy<br/>Public Marketplace<br/>container :8004"]
        end
    end

    hub -->|":8001 → :8000"| saturn_ts
    caddy_admin -->|":8002"| saturn_ts
    caddy_bp -->|":8003"| saturn_ts
    caddy_mp -->|":8004"| saturn_ts

    pluto -->|"✅ ws://100.87.99.59:8001/rpc"| saturn_ts
    mercury -->|"✅ ws://100.87.99.59:8001/rpc"| saturn_ts

    style saturn_ts fill:#00b894,color:#fff
    style hub fill:#2d3436,color:#fff
    style caddy_admin fill:#2d3436,color:#fff
    style caddy_bp fill:#2d3436,color:#fff
    style caddy_mp fill:#00b894,color:#fff,stroke:#fff,stroke-width:2px
    style mercury fill:#6c5ce7,color:#fff
    style pluto fill:#0984e3,color:#fff
```

## The Change

| What | Before | After |
|------|--------|-------|
| `.env` `TAILNET_IP` | `127.0.0.1` | `100.87.99.59` |
| SDB reachable from mesh | ❌ | ✅ `:8001` |
| Admin Panel from mesh | ❌ | ✅ `:8002` |
| BP from mesh | ❌ | ✅ `:8003` |
| Marketplace (new) | — | ✅ `:8004` |
| Public internet | ❌ blocked | ❌ still blocked |

> [!IMPORTANT]
> **Security:** Binding to `100.87.99.59` means only Tailscale peers (PlutoII, Mercury, CyberGurkan, PocketPickle) can reach these ports. Saturn has no public IP — Tailscale IS the firewall. Zero exposure to the internet.

## Port Map (after)

| Port | Service | Protocol | Used by |
|------|---------|----------|---------|
| `:8001` | SurrealDB (DittoDatto Hub) | WebSocket `/rpc` | All apps (Flutter direct-to-DB) |
| `:8002` | Admin Panel | HTTP | Arnar + Höddi via browser |
| `:8003` | Business Portal | HTTP | Business users via browser |
| `:8004` | Public Marketplace | HTTP | Consumers via browser |
| `:8085` | SurrealDB (OpenWebUI) | WebSocket | OpenWebUI only (separate stack) |
