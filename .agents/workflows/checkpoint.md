---
description: Save session state and record decisions. No questionnaires — agent auto-classifies silently.
---

# Checkpoint — Save Session State

When the user invokes `/checkpoint`, execute this sequence to persist the current session state. **Step 3 auto-classifies decisions** — ADRs only if explicitly proposed and approved during the session. Everything else goes to Pulse silently. No questionnaires.

Supports `--quick` flag: `/checkpoint --quick` skips Step 3 (the decision classifier).

---

## Step 0: Pre-flight

Verify that `conductor/` exists in the project root. If it does not, halt with:
> "Conductor is not initialized. Run `/conductor-init` to set up the project."

Verify that `conductor/project-context.md` exists. If it does not, halt with:
> "`conductor/project-context.md` is missing — the conductor is broken. Run `/conductor-init` to repair."

---

## Step 1: Session Summary

Determine the session focus. Either:

- Infer from conversation context (preferred), or
- Ask the user: "What was the main focus of this session?"

Gather:

- What was worked on
- What was completed
- What is still in progress
- Any decisions made (free-form — these feed Step 3)
- Suggested next steps

---

## Step 2: Update `conductor/pulse.md`

Update the following sections in `conductor/pulse.md`:

```markdown
**Last Updated:** {current timestamp}
**Session Focus:** {summary}

## 🚀 Active Tracks
## ✅ Recently Completed
## ⚠️ Blockers
## 🧠 Session Memory
## 📋 Next Session Suggestions
```

These section names are parsed by Conductor. **Do not rename them.**

> **Note on Session Memory:** Append the session's work summary here. Leave room for Step 3d to append classified operational decisions below — do not overwrite the section, only append.

### 200-Line Archiving Guardrail

After updating, check if `pulse.md` exceeds 200 lines. If it does:

1. **Session Memory:** Keep only the **last 2 sessions**. Move older entries to `conductor/pulse-archive/{YYYY-MM-DD}.md`.
2. **Recently Completed:** Keep only the **last 5 entries**. Move older rows to the same archive file.
3. Add a reference below each trimmed section:
   > 📦 Full history: `conductor/pulse-archive/{YYYY-MM-DD}.md`
4. Archive files are **append-only** — add new archived content at the bottom of existing files.


## Step 3: Decision Recording

> **Skipped with `--quick` flag.**

**No questionnaires.** Decisions are handled in-context during the session, not retroactively at checkpoint time. The agent classifies silently using these rules:

### Step 3a: Auto-classify

Scan the session for decisions that were made. For each:

| Bucket | Rule | Action |
|--------|------|--------|
| **ADR** | Only if the agent **explicitly proposed an ADR during the session** AND the user approved it. | Write the ADR file (Step 3c). |
| **Pulse** | Everything else — operational notes, technical decisions, discoveries. | Append to Session Memory (already done in Step 2). |
| **Drop** | Debugging tangents, dead-end experiments, trial-and-error noise. | Do nothing. |

**Do NOT present a classification table or questionnaire to the user.** The agent makes the call. If something is genuinely ADR-worthy and wasn't proposed during the session, flag it as a one-liner suggestion — not a multi-choice form.

### Step 3b: Scope (no double-processing)

Decisions **already approved** by a prior `/grill` or `/new-track` ADR batch are already in `conductor/adr/` — do NOT re-record them.

### Step 3c: Write ADR-bucket decisions

For each decision classified as **ADR**:

1. Number sequentially from the highest existing ADR across **all** of `conductor/adr/` (root + domain subdirs like `adr/business-portal/`, `adr/admin-panel/`, etc.).
2. Write `conductor/adr/{NNNN}-{short-title-kebab}.md` using this format:

   ```markdown
   # {Short title of the decision}

   > **Recorded:** {YYYY-MM-DD HH:MM}
   > **Status:** accepted

   {1–3 sentences: what's the context, what did we decide, and why.}
   ```

   Optional sections (only when they add value): `## Considered Options`, `## Consequences`, `## Superseded by`.

3. If this is the **first ADR** for the project, queue an index-sync append for the `adr/` directory (applied in Step 7).

### Step 3d: Drop-bucket decisions

For decisions classified as **Drop**, do nothing. They remain only in the conversation transcript.

---

## Step 4: Track Status Check

For any tracks worked on during this session:

1. Update the track's `plan.md` — mark completed tasks with `[x]`.
2. Update `metadata.json` — set `status` and `updated_at` fields.
3. If a track is fully completed:
   - Update `metadata.json` status to `completed`.
   - Move the track entry from "Active Tracks" to "Completed Tracks" in `conductor/tracks.md`.

---

## Step 5: Relay Handoff Entry

Append a timestamped entry to `conductor/relay.md`:

```markdown
## {YYYY-MM-DD HH:MM}
- **Session:** {focus summary}
- **Tracks touched:** {list of track IDs}
- **Status:** {brief status}
- **Decisions:** {ADR titles recorded this checkpoint, or "None"}
- **Next:** {suggested next actions}
```

> The `Decisions:` field lists only the ADRs written in Step 3c, not the pulse-bucket items. Pulse-bucket items stay scoped to `pulse.md` for the session.

---

## Step 6: Git Commit

Stage and commit all conductor changes:

```bash
git add conductor/
git commit -m "checkpoint: {brief summary} ({M ADRs})"
```

Simplify to `checkpoint: {brief summary}` when no ADRs were recorded.

---

## Step 7: Index Sync

If a first ADR was written this checkpoint (queued in Step 3c), update `conductor/index.md`:

1. Create a `## Decisions` section (if it doesn't exist).
2. Append `- [ADR Directory](./adr/)` under that section.

Idempotency: if the link already exists, skip (no-op). Never write a dead link.

---

## Step 8: Confirm

Tell the user:

> "✅ Checkpoint saved.
>
> - Decisions classified: **{N total}** → **{ADR_count}** ADR, **{Pulse_count}** Pulse, **{Drop_count}** dropped.
> - Tracks touched: **{list}**.
> - Session state captured in `pulse.md`{; archived to pulse-archive/{date}.md if guardrail tripped}.
>
> **Options:**
>
> - Continue working on current track
> - Switch to a different track
> - End session"
