# Admin Panel Auth Infrastructure — AsyncNotifier + Persistence + Router Guard

> **Recorded:** 2026-05-30 17:44
> **Status:** accepted

## Context

The admin panel had three interrelated auth defects: `AuthNotifier` used a synchronous `Notifier` with a fire-and-forget `_tryRestore()` creating a race condition; `GoRouter` was recreated on every auth state change (breaking navigation guards and allowing unauthenticated access); and sessions had no persistence across page reloads.

## Decision

1. **AsyncNotifier** — `AuthNotifier` extends `AsyncNotifier<AuthState>`. `build()` awaits `tryRestore()` properly. Consumers read `AsyncValue<AuthState>`.
2. **refreshListenable** — Single `GoRouter` instance uses a `ChangeNotifier` bridge to Riverpod. Auth state changes trigger redirect re-evaluation, not router replacement.
3. **FlutterSecureStorage** — JWT tokens from SurrealDB `signin()` are persisted. `tryRestore()` reconnects via `authenticate()` with stored tokens. Expired tokens (1h TTL) fall back to login.

## Consequences

- Auth guard is deterministic — no race between router creation and async restore.
- Sessions survive page reloads within the token TTL window.
- All auth consumers adapted from `AuthState` to `AsyncValue<AuthState>`.
