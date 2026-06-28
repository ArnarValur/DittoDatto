# DittoDatto — Workspace Rules

## Deploy Gate: Tests Before Deploy

**NEVER deploy any Flutter app (Admin Panel, Business Portal, Marketplace) without running its integration tests first.**

Workflow — every time, no exceptions:

1. `./scripts/test-db-up.sh`
2. `cd apps/<app> && flutter test --tags integration`
3. All tests must pass. If any fail → fix first, re-run, do NOT deploy.
4. Deploy using the correct method for the app (see below).
5. `./scripts/test-db-down.sh`

If no integration tests exist for the app being deployed, **say so explicitly** and flag it as a gap — do not silently deploy untested code.

## Deployment: Two Modes, No Questions

### Web apps (Admin Panel, Business Portal) → Saturn

**The deploy script `./scripts/deploy-to-saturn.sh` is the ONLY way to deploy web apps.** It handles everything:
- `flutter build web --release` with the correct `--dart-define` flags (encoded in the script's `DART_DEFINES` map)
- `rsync --delete` to the correct Caddy-served path on Saturn
- Hash verification (local build vs served content)
- Post-deploy smoke test

**Dart-define values live in the deploy script's `DART_DEFINES` array.** If a new dart-define is needed, add it there. Do not pass them on the command line.

**Saturn connectivity:** SSH alias `saturn` (host Saturn, user `arnar`). Deploy paths:
- Portal: `/srv/dittodatto/business-portal/web` → port 8003
- Admin: `/srv/dittodatto/admin-panel/web` → port 8002

### Native app (Marketplace) → Phone

**The Marketplace is a native Android app. Deploy directly to the connected phone:**

```
cd apps/marketplace && flutter run --release -d R5CR61FGVPN \
  --dart-define=SURREAL_URL=ws://dittodatto:8001/rpc \
  --dart-define=DEBUG_DB_PASS=test-portal-pass
```

**NEVER:**
- Build a web version of the Marketplace and deploy to Saturn
- Build a standalone APK when the phone is connected
- Ask the user how to deploy — the answer is always `flutter run -d R5CR61FGVPN`
- Discuss or question deployment strategy — it has been settled

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
