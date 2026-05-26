---
name: conductor
description: "Resume Conductor in a project initialized with /conductor-init. Loads project-context, context.md, prd.md, adr/, workflow, pulse, relay, and tracks; runs a defensive index-sync reconcile; presents status; and awaits orders. Use when the user runs /conductor in Cursor or asks to resume the Conductor session."
disable-model-invocation: true
---

# Conductor (Resume)

Resume Conductor — load project context, self-heal the index, present status, and await orders.

## Resolve TheOracle root

Use the first path that exists:

1. **Project bundle:** `.cursor/the-oracle/`
2. **`THEORACLE_HOME`**
3. **Default:** `~/Hermes/TheOracle`

## Instructions

1. Read `{THEORACLE_ROOT}/protocols/file-resolution.md`
2. Read `{THEORACLE_ROOT}/protocols/index-sync.md`
3. Read and execute `{THEORACLE_ROOT}/workflows/conductor.md` step by step.

## When NOT to use

- No `conductor/` directory → run `/conductor-init` first
- New feature track → use `/new-track`
- Domain refinement / ADR batching → use `/grill`
- Session save → use `/checkpoint`
