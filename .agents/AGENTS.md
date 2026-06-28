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

## Deployment: No Ad-Hoc Commands, No Questions

**The deploy script `./scripts/deploy-to-saturn.sh` is the ONLY way to deploy. It handles everything:**
- `flutter build web --release` with the correct `--dart-define` flags (encoded in the script's `DART_DEFINES` map)
- `rsync --delete` to the correct Caddy-served path on Saturn
- Hash verification (local build vs served content)
- Post-deploy smoke test

**NEVER:**
- Run `flutter build web` manually for deployment — the script does it.
- Run raw `rsync` to Saturn — the script encodes the canonical paths.
- Ask the user for `BP_PORTAL_PASS` or any dart-define values — they are in the script.
- Skip the deploy script and cobble together ad-hoc commands.

**Dart-define values live in the deploy script's `DART_DEFINES` array.** If a new dart-define is needed, add it there. Do not pass them on the command line.

**Saturn connectivity:** SSH alias `saturn` (host Saturn, user `arnar`). Deploy paths:
- Portal: `/srv/dittodatto/business-portal/web` → port 8003
- Admin: `/srv/dittodatto/admin-panel/web` → port 8002
- Marketplace: `/srv/dittodatto/marketplace/web` → port 8004

## No CLI CRUD: E2E Means E2E

**NEVER insert, update, or delete application data via CLI, raw SQL, or API calls when verifying E2E flows.**

All data that the application is supposed to create (users, companies, establishments, etc.) **must go through the actual deployed UI** — Admin Panel forms, Business Portal forms, etc.

CLI/SQL is acceptable ONLY for:
- **Infrastructure:** Schema application, NS-level admin users, DB wipes, migrations.
- **Debugging:** Read-only queries to inspect state.

If a form doesn't work, **fix the form**. If provisioning doesn't trigger, **fix provisioning**. CLI hacks hide the bugs that matter most.

## Ship Before You Speak

**NEVER tell the user "you can see X" or "try it now" unless the code is ALREADY deployed and verified on Saturn.**

During active development sessions on any Flutter app (BP, Admin, Marketplace):

1. **Code → Test → Ask to deploy → Deploy → THEN report.** Not code → report → awkward deployment discussion.
2. After code changes compile and tests pass, **ask the user if they want to deploy.** Don't auto-deploy silently, but don't skip the question either.
3. Wait for the deploy script's hash verification and smoke test to confirm.
4. **Only then** tell the user what changed and where to see it (include the port URL).
5. If deploy fails, fix it. Don't report success.

**The user browses Saturn in their browser. That is the dev surface. Local-only code changes are invisible to them.**

This applies to shared package changes too — if `packages/establishment_ui/` changes, the consuming app(s) must be redeployed for the user to see anything.
