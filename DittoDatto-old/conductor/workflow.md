# Conductor Workflow Guide

> [!CAUTION]
> **Dev servers run natively on the host.** User always has Servers and Emulators running in his Terminal!

## Dev Servers

Development services for the Chapter 2 stack:

| Service            | Port  | Start Command                                  |
| ------------------ | ----- | ---------------------------------------------- |
| MercuryEngine V2   | :8000 | `cd services/mercury-engine && uv run uvicorn mercury_engine.main:app --reload` |
| SurrealDB          | :8000 | Docker container on `merkurial-networks`       |
| Flutter App (web)  | :3000 | `cd apps/mobile/dittodatto-flutter && flutter run -d chrome` |

### Legacy (Chapter 1 — Frozen, reference only)

| Service            | Port  | Start Command        |
| ------------------ | ----- | -------------------- |
| admin-panel        | :3000 | `npm run dev:admin`  |
| business-portal    | :3001 | `npm run dev:portal` |
| public-marketplace | :3002 | `npm run dev:public` |
| MercuryEngine V1   | :5002 | `npm run dev:engine` |

## Guiding Principles

1. **The Plan is the Source of Truth:** All work must be tracked in `plan.md`
2. **The Tech Stack is Deliberate:** Changes to the tech stack must be documented in `tech-stack.md` _before_ implementation _and_ verified with User.
3. **Test-Driven Development (Aspirational):** Write unit tests alongside implementation. Aim for >80% code coverage.
4. **Phase-Based Commits:** Changes are committed to Git after the completion of each **Phase** (group of tasks) rather than after every individual task.
5. **Task Summaries (Git Notes):** Use **Git Notes** to record detailed task summaries to keep the commit history clean.
6. **User Experience First:** Every decision should prioritize user experience.
7. **Documentation Driven:** Document the journey, tasks, phases and everything else in the project with Markdown.
8. **Weekly Review:** Perform a "Weekly Overview, Recap and Next Steps" session every Sunday to reflect on progress and plan the coming week.

## Task Workflow

All tasks follow a strict lifecycle:

### Standard Task Workflow

1. **Select Task:** Choose the next available task from `plan.md` in sequential order.
2. **Mark In Progress:** Before beginning work, edit `plan.md` and change the task from `[ ]` to `[~]`.
3. **Implementation & Testing:**
   - Implement the feature or fix.
   - Write corresponding tests to ensure functionality and meet the 80% coverage goal.
   - Verify changes using `uv run pytest` (unit + integration tests against SurrealDB).
4. **Refactor:** Improve code quality while maintaining passing tests.
5. **Documentation:** Update relevant documentation and Obsidian notes with insights from the task.
6. **Mark Complete:** Update `plan.md` from `[~]` to `[x]`.

### Phase Completion & Checkpointing Protocol

**Trigger:** This protocol is executed immediately after all tasks in a **Phase** are completed.

1.  **Announce Phase Completion:** Inform the user that the phase is finished.
2.  **Consolidated Commit:**
    - Stage all changes from the phase.
    - Commit with a clear message (e.g., `feat(phase): Complete Phase 1 - Core Administration`).
3.  **Attach Auditable Verification Report (Git Notes):**
    - Create a detailed summary of all tasks in the phase.
    - Attach the summary to the phase commit using `git notes`.
4.  **Manual Verification:** Walk through the manual verification steps with the user.
5.  **Checkpointing:** Mark the phase as checkpointed in `plan.md` with the commit SHA.

### Weekly Review Checkpoint

**Trigger:** Every Sunday or after major project milestones.

1.  **Recap:** Review the tasks and phases completed during the week.
2.  **Reflect:** Document lessons learned, architectural shifts, and "superpower" moments in Obsidian.
3.  **Plan:** Define the goals and tracks for the upcoming week.
4.  **Update:** Refresh `product.md` and `roadmap.md` if strategic directions have evolved.

## Quality Gates

Before finalizing a phase, verify:

- [ ] All tests pass.
- [ ] Code coverage is aspirational towards 80%.
- [ ] Code follows project's style guides.
- [ ] Documentation (Markdown) is updated and consistent.
- [ ] Works correctly on mobile (responsive check).
- [ ] No security vulnerabilities or hardcoded secrets.

## Commit Guidelines

### Message Format

```
<type>(<scope>): <description>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code change (no new features/fixes)
- `test`: Adding missing tests
- `chore`: Maintenance
- `conductor`: Conductor-specific setup or plan updates

## Session Management

### Start of Session

Read `pulse.md` for instant context on:

- What was worked on last
- Active tracks and their status
- Recent decisions made
- Suggested next steps

### During Session

- Update track `plan.md` as tasks complete (avoid drift!)
- Log significant decisions in `decisions.md`

### End of Session

Use `/checkpoint` workflow to:

- Update `pulse.md` with session summary
- Log any decisions made
- Suggest next session focus
- Optionally commit changes

### Quick Reference

| File           | Purpose                 |
| -------------- | ----------------------- |
| `pulse.md`     | Live project state      |
| `tracks.md`    | Track list by domain    |
| `decisions.md` | Decision log            |
| `workflow.md`  | This file - conventions |
