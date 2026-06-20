# DittoDatto — Workspace Rules

## Deploy Gate: Tests Before Deploy

**NEVER deploy any Flutter app (Admin Panel, Business Portal, Marketplace) to Saturn or production without running its integration tests first.**

Workflow — every time, no exceptions:

1. `./scripts/test-db-up.sh`
2. `cd apps/<app> && flutter test --tags integration`
3. All tests must pass. If any fail → fix first, re-run, do NOT deploy.
4. Only after green: `flutter build web --release` → `rsync` to Saturn.
5. `./scripts/test-db-down.sh`

If no integration tests exist for the app being deployed, **say so explicitly** and flag it as a gap — do not silently deploy untested code.
