---
name: new-track
description: "Create a new Conductor track — domain-aware spec interview on top of context.md / adr/ / prd.md, then scaffold the track folder (spec.md + plan.md + metadata.json) under conductor/tracks/<domain>/<id>/. Use when starting a new feature or refactor and the user runs /new-track in Cursor."
disable-model-invocation: true
---

# New Track (Conductor)

Domain-aware track creation — runs a spec interview grounded in the project's canonical context, then scaffolds the track folder.

## Resolve TheOracle root

Use the first path that exists:

1. **Project bundle:** `.cursor/the-oracle/`
2. **`THEORACLE_HOME`**
3. **Default:** `~/Hermes/TheOracle`

## Instructions

1. Read `{THEORACLE_ROOT}/protocols/file-resolution.md`
2. Read `{THEORACLE_ROOT}/protocols/index-sync.md`
3. Read and execute `{THEORACLE_ROOT}/workflows/new-track.md` step by step.

## When NOT to use

- No `conductor/` directory → run `/conductor-init` first
- Domain language is still vague → run `/grill` first to sharpen `context.md`
- Settled-decision work (no new spec needed) → just resume implementation via `/conductor` and pick up the existing track
