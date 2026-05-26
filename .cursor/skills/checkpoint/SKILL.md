---
name: checkpoint
description: "Save Conductor session state — classify decisions (settled vs pulse vs ADR-worthy), update pulse.md + relay.md, optionally batch ADRs, commit. Use at the end of a working session or when the user runs /checkpoint in Cursor."
disable-model-invocation: true
---

# Checkpoint (Conductor)

Save session state, classify decisions, update pulse / relay, optionally batch ADRs, and commit.

## Resolve TheOracle root

Use the first path that exists:

1. **Project bundle:** `.cursor/the-oracle/`
2. **`THEORACLE_HOME`**
3. **Default:** `~/Hermes/TheOracle`

## Instructions

1. Read `{THEORACLE_ROOT}/protocols/file-resolution.md`
2. Read `{THEORACLE_ROOT}/protocols/index-sync.md`
3. Read and execute `{THEORACLE_ROOT}/workflows/checkpoint.md` step by step.

## When NOT to use

- No `conductor/` directory → run `/conductor-init` first
- Mid-task — wait for a natural stopping point (phase boundary, end of session)
- Just resumed (no new state to capture) → use `/conductor` instead
