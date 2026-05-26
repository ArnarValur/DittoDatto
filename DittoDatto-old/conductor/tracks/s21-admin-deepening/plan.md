# S21 — Admin Panel Architecture Deepening

**Status:** Planned — awaiting execution  
**Created:** 2026-05-06  
**Origin:** `/improve-architecture` exploration of `apps/admin/`

## Context

Four deepening candidates identified via architecture exploration. Ordered by dependency (foundations first). All four approved by Captain.

## Open Decisions (need Captain's input before Slice D)

1. **Login screen layout** — Plan removes server URL dropdown, adds gear icon. Does Captain want current server target visible as a subtle label too?
2. **PIN unlock** — Plan skips `local_auth` (silent JWT restore, no PIN). Captain to confirm.
3. **Saturn default** — Keep Pluto as default. "We can adjust when that happens."

---

## Slice A — Type Safety Fix (trivial)

**File:** `apps/admin/lib/features/dashboard/dashboard_screen.dart`

- Line 53: `final dynamic stats` → `final AdminStats stats`
- Add `import 'package:mercury_client/mercury_client.dart';`

---

## Slice B — Provider Topology Cleanup

Extract API client providers out of `auth_provider.dart`.

### [NEW] `apps/admin/lib/features/auth/api_providers.dart`

Move from `auth_provider.dart`:
- `mercuryApiProvider` — `Provider<MercuryApi>`
- `adminApiProvider` — `Provider<AdminApi>`
- `authServiceProvider` — `Provider<AuthService>`

### [MODIFY] `apps/admin/lib/features/auth/auth_provider.dart`

- Remove the three moved providers
- Add `import 'api_providers.dart';`
- File shrinks to just `AuthState` + `AuthNotifier`

### [MODIFY] All feature providers — update imports

Import `api_providers.dart` instead of `auth_provider.dart` for `adminApiProvider`:
- `dashboard_provider.dart`
- `users_provider.dart`
- `categories_provider.dart`
- `companies_provider.dart`

---

## Slice C — Shared Screen Scaffolding

Extract duplicated UI patterns into shared modules.

### [NEW] `apps/admin/lib/features/shared/error_view.dart`

Shared error state widget (icon, title, message, retry button). Replaces `_ErrorView` in users and dashboard.

### [NEW] `apps/admin/lib/features/shared/empty_view.dart`

Shared empty state widget. Replaces `_EmptyView` in users.

### [NEW] `apps/admin/lib/features/shared/pagination_bar.dart`

Shared pagination controls (~50 lines). Replaces duplication in users and companies.

### [NEW] `apps/admin/lib/features/shared/formatters.dart`

Date formatting helper (from `users_screen.dart` line 280).

### [MODIFY] Screens

- `users_screen.dart` — remove `_ErrorView`, `_EmptyView`, `_formatDate`, inline pagination
- `dashboard_screen.dart` — remove `_ErrorView`
- `companies_screen.dart` — remove inline pagination

---

## Slice D — Session Gate (the big one)

Eliminate login friction. Fix token restore race, pre-fill credentials, simplify server selection.

### [MODIFY] `auth_provider.dart`

Add `AuthInitializing` state. Make `build()` async (await `restoreToken()`). Pre-fill last email via `SharedPreferences`. Save email on login success.

```dart
sealed class AuthState { const AuthState(); }
class AuthInitializing extends AuthState { const AuthInitializing(); }
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.lastEmail});
  final String? lastEmail;
}
class AuthLoading extends AuthState { const AuthLoading(); }
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.token});
  final String token;
}
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
```

### [MODIFY] `router.dart`

Handle `AuthInitializing` — don't redirect, show loading. Prevents login screen flash.

### [MODIFY] `login_screen.dart`

1. Pre-fill email from `AuthUnauthenticated.lastEmail`
2. Remove `_ServerUrlSelector` dropdown from main form
3. Add gear icon → dialog for server selection
4. Add subtle label showing current server target

### No change to `server_config_provider.dart` (keep Pluto default)

---

## File Summary

| Action | File | Slice |
|--------|------|-------|
| MODIFY | `dashboard_screen.dart` | A + C |
| NEW | `api_providers.dart` | B |
| MODIFY | `auth_provider.dart` | B + D |
| MODIFY | `dashboard_provider.dart` | B |
| MODIFY | `users_provider.dart` | B |
| MODIFY | `categories_provider.dart` | B |
| MODIFY | `companies_provider.dart` | B |
| NEW | `error_view.dart` | C |
| NEW | `empty_view.dart` | C |
| NEW | `pagination_bar.dart` | C |
| NEW | `formatters.dart` | C |
| MODIFY | `users_screen.dart` | C |
| MODIFY | `companies_screen.dart` | C |
| MODIFY | `router.dart` | D |
| MODIFY | `login_screen.dart` | D |

**15 files** (4 new, 11 modified). No dependency additions.

## Verification

1. `dart analyze` clean on both `apps/admin/` and `packages/mercury_client/`
2. Existing `mercury_client` tests pass (9 tests)
3. Cold start with valid JWT → straight to dashboard (no login flash)
4. Cold start with no JWT → login with pre-filled email
5. Login → logout → login → email pre-filled
6. Gear icon → server selection → persists across restart
7. Verify on Chrome (`flutter run -d chrome`)

## Tablet Info (for reference)

**Apollo** — Lenovo Tab M10 Plus 3rd Gen (TB125FU)
- **No fingerprint sensor** — `local_auth` would use device PIN/pattern only
- LineageOS 21.0 (Android 14)
- Last known IP: `192.168.2.74`
