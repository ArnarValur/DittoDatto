# DittoDatto — Workspace Rules

## Deploy Gate: Tests Before Deploy

**NEVER deploy any Flutter app (Admin Panel, Business Portal, Marketplace) to Saturn or production without running its integration tests first.**

Workflow — every time, no exceptions:

1. `./scripts/test-db-up.sh`
2. `cd apps/<app> && flutter test --tags integration`
3. All tests must pass. If any fail → fix first, re-run, do NOT deploy.
4. `./scripts/deploy-to-saturn.sh <portal|admin|marketplace>` — builds, rsyncs to the **correct Caddy-served path**, verifies the served hash matches the build, and runs the smoke test. **NEVER use raw `rsync` to Saturn.** The deploy script encodes the canonical paths.
5. `./scripts/test-db-down.sh`

If no integration tests exist for the app being deployed, **say so explicitly** and flag it as a gap — do not silently deploy untested code.

## No CLI CRUD: E2E Means E2E

**NEVER insert, update, or delete application data via CLI, raw SQL, or API calls when verifying E2E flows.**

All data that the application is supposed to create (users, companies, establishments, etc.) **must go through the actual deployed UI** — Admin Panel forms, Business Portal forms, etc.

CLI/SQL is acceptable ONLY for:
- **Infrastructure:** Schema application, NS-level admin users, DB wipes, migrations.
- **Debugging:** Read-only queries to inspect state.

If a form doesn't work, **fix the form**. If provisioning doesn't trigger, **fix provisioning**. CLI hacks hide the bugs that matter most.
