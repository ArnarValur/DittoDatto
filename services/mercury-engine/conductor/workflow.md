<!-- Template: TheOracle v2.1 | Mode: strict-python -->
# Project Workflow — Strict Python TDD

> Full test-driven development workflow tailored specifically for the MercuryEngine Python backend.
> Red → Green → Refactor on every task. No exceptions.

---

## Guiding Principles

1. **The Plan is the Source of Truth:** All work must be tracked in `tracks.md`
2. **Strict Test-Driven Development (TDD):** Write unit or integration tests that fail *before* writing any implementation code.
3. **High Code Coverage:** Aim for >90% code coverage on core availability calculators and >80% on other modules.
4. **First-Principles Architecture:** Keep business logic/calculators completely decoupled from the FastAPI transport layer and SurrealDB I/O (Repository Pattern).
5. **UTC Timezone Safety:** Never use naive datetimes (`datetime.now()`). Always use timezone-aware UTC (`datetime.now(timezone.utc)`).

---

## Task Workflow

All tasks follow a strict 11-step lifecycle:

### Standard Task Workflow

1. **Select Task:** Choose the next available task from `tracks.md` in sequential order.
2. **Mark In Progress:** Edit `tracks.md` and change the task from `[ ]` to `[~]`.
3. **Write Failing Tests (Red Phase):**
   - Create or update a test file under `tests/`.
   - Write unit tests using `pytest` defining the expected behavior and constraints.
   - Run the tests: `uv run pytest tests/path/to/test.py`.
   - **CRITICAL:** Confirm that the tests fail as expected. This proves your test is valid. Do not proceed until you have a failing test.
4. **Implement to Pass Tests (Green Phase):**
   - Write the minimum amount of application code in `src/` to make the failing tests pass.
   - Run tests again: `uv run pytest tests/path/to/test.py`.
   - Confirm that all tests pass.
5. **Refactor:**
   - With passing tests as a safety net, clean up the implementation and tests. Remove duplication, optimize calculations, format with Ruff (`uv run ruff format .`), and lint (`uv run ruff check .`).
   - Rerun tests to guarantee zero regressions.
6. **Verify Coverage:** Run coverage using pytest:
   ```bash
   uv run pytest --cov=src --cov-report=term-missing
   ```
   **Gate: >80% coverage on new backend code.** Do not proceed if below threshold.
7. **Document Deviations:** If implementation requires a design shift, update the **Tech Stack** section of `project-context.md` (user-edited) before continuing.
8. **Commit Code Changes:**
   - Commit with conventional commits: e.g. `feat(slots): Add time slots calculator for multi-vertical reservations` or `fix(auth): Correct JWT expiration verification`.
9. **Attach Task Summary via Git Notes:**
   - Get the commit hash: `git log -1 --format="%H"`
   - Attach a summary of what changed and why:
     ```bash
     git notes add -m "Task: <task name>\nSummary: <description>\nFiles: <list of files>" <commit_hash>
     ```
10. **Record Task Completion in Plan:**
    - In `tracks.md`, update the completed task from `[~]` to `[x]` and append the first 7 characters of the commit hash.
11. **Commit Plan Update:**
    - Stage and commit `tracks.md`: `conductor(tracks): Mark task '<task name>' as complete`

---

## Phase Completion — Checkpointing Protocol

**Trigger:** Executed immediately when a completed task concludes a Phase in `tracks.md`.

1. **Announce Protocol Start:** Inform the user that the phase is complete and checkpointing has begun.
2. **Ensure Test Coverage for Phase Changes:**
   - List changed files: `git diff --name-only <previous_checkpoint_sha> HEAD`
   - Verify corresponding `pytest` files exist and are comprehensive.
3. **Execute Automated Tests with Proactive Debugging:**
   - Run the full test suite: `uv run pytest`
   - If tests fail, inform the user and attempt up to 2 fixes. If still failing, stop and escalate.
4. **Propose Manual Verification Plan:**
   - Provide clear `curl` or FastAPI docs (`/docs`) instructions to verify the API behaviors.
5. **Await User Feedback:**
   - Ask for confirmation. **PAUSE** execution. Do not proceed without explicit confirmation.
6. **Create Checkpoint Commit:**
   - Commit: `conductor(checkpoint): Checkpoint end of Phase X`
7. **Attach Verification Report via Git Notes:**
   - Attach a summary of tests run, manual steps, and user confirmation.
8. **Record Phase Checkpoint SHA:**
   - Get the hash and record it in `tracks.md` as `[checkpoint: <sha>]`.
9. **Commit Plan Update:**
   - Stage and commit `tracks.md`.
10. **Announce Completion:** Inform the user that the checkpoint is complete.
