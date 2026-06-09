# ADR-0015: No Hardcoded Secrets or Record IDs in Committed Code

- **Status:** Accepted
- **Date:** 2026-06-09
- **Deciders:** Arnar Valur
- **Domain:** Platform-wide

## Context

During admin role management work (2026-06-08), scripts in `apps/admin/bin/` were committed with:
- Plaintext namespace credentials (`user: 'arnarvalur'`, `pass: 'admin123'`)
- Hardcoded SurrealDB record IDs (`user:dj6gm82md9uq2yyfxgrg`)
- Unsafe dynamic type casting on query results (`.first['result'].first` without bounds checks)
- Sequential non-transactional database mutations in loops

The root cause: the agent classified `bin/` scripts as "throwaway" and lowered code quality standards, propagating anti-patterns already present in pre-existing scripts.

## Decision

1. **No plaintext credentials** in any committed file — regardless of directory (`bin/`, `scripts/`, `test/`, `lib/`). Use `Platform.environment['KEY']` or accept via CLI arguments.
2. **No hardcoded SurrealDB record IDs** — query by attribute (email, name, slug) or accept IDs as CLI parameters.
3. **Defensive response parsing** — validate list bounds and map keys before accessing nested query results. Prefer typed Dart models (`User.fromJson`) over raw dynamic access.
4. **Transaction safety** — multi-record database mutations must be wrapped in `BEGIN TRANSACTION ... COMMIT TRANSACTION` to ensure atomicity.
5. **No "throwaway" exemption** — all code in the repository follows production-grade standards. There is no directory where quality rules are relaxed.

## Consequences

- Agents must externalize credentials via environment variables or config for all database scripts.
- Existing violations in `apps/admin/bin/` must be remediated (tracked separately).
- This ADR is enforced by agent rules in `conductor/agent-rules/code-safety.md`.
