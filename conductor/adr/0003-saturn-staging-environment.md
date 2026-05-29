# Saturn as Staging Environment

> **Recorded:** 2026-05-29 17:32
> **Status:** accepted

## Context

To test the ecosystem (database schemas, booking APIs, client applications) in a realistic end-to-end setting without paying the latency and cost of production deployment, we require a persistent, team-gated staging environment.

## Decision

We use **Saturn** (on-prem GPU server) as the staging environment. Deployment uses Docker on Saturn, and access is strictly gated behind the team's Tailscale VPN. The staging database is named the **DittoDatto Hub** (`saturn:8001`).

## Consequences

- Staging is only accessible over the Tailscale VPN; there is no public Internet exposure.
- Saturn is strictly for staging; production deployment remains Cloud Run (`europe-west1`).
- The setup supports fast, manual Docker-compose deploy cycles without complex CI setup.
