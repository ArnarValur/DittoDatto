# `ditto_auth` — Package API Design

> **Track:** `auth_service_20260624` · **Task:** Phase 1, Task 5
> **Focus:** `businessSignin` for BP migration (priority), consumer auth designed but deferred
> **Last updated:** 2026-06-24

---

## 1. Design Principles

1. **Extract, don't reinvent.** BP's `SurrealAuthService` + `SurrealConnection` already work. `ditto_auth` lifts this logic into a shared package with a clean API boundary.
2. **Same `AuthState` contract.** Reuse `mercury_client`'s sealed `AuthState` (or re-export it). Zero churn in BP's `AuthNotifier`.
3. **Two-phase auth stays.** The Phase 1 (user identity) → Phase 2 (tenant routing) model is architecturally sound. `ditto_auth` formalizes it.
4. **Swappable backend.** All SurrealDB calls go through an `AuthBackend` interface. Today = direct-to-DB. Tomorrow = HTTP proxy for Vipps/production credential delivery.
5. **BP-first.** Consumer auth (`consumerSignin/Signup`) is designed in the API surface but implemented in Phase 4. BP migration (Phase 3) ships first.

---

## 2. Package Structure

```
packages/ditto_auth/
├── lib/
│   ├── ditto_auth.dart              # barrel export
│   └── src/
│       ├── ditto_auth.dart          # DittoAuth — main entry point
│       ├── auth_result.dart         # BusinessAuthResult, ConsumerAuthResult
│       ├── auth_backend.dart        # AuthBackend interface (swappable)
│       ├── surreal_auth_backend.dart # Direct-to-DB implementation
│       ├── token_store.dart         # TokenStore — secure persistence
│       ├── tenant_connection.dart   # TenantConnection (replaces SurrealConnection)
│       └── exceptions.dart          # DittoAuthException hierarchy
├── test/
│   ├── unit/
│   │   └── token_store_test.dart
│   └── integration/
│       ├── business_signin_test.dart
│       └── consumer_signin_test.dart
└── pubspec.yaml
```

---

## 3. Public API Surface

### 3.1 `DittoAuth` — Main Entry Point

```dart
/// Shared authentication package for all DittoDatto Flutter apps.
///
/// Encapsulates SurrealDB RECORD ACCESS auth (consumer + business),
/// token lifecycle, and tenant routing behind a swappable backend.
class DittoAuth {
  DittoAuth({
    required AuthBackend backend,
    TokenStore? tokenStore,
  });

  // ── Business Portal Auth ──

  /// Two-phase business signin:
  ///   Phase 1: RECORD ACCESS `bp_auth` on users/users → user identity + role check
  ///   Phase 2: `bp_portal` service user signin on company_{slug} → tenant connection
  ///
  /// Returns [BusinessAuthResult] with both connections and user profile.
  /// Throws [DittoAuthException] on failure.
  Future<BusinessAuthResult> businessSignin({
    required String email,
    required String password,
  });

  // ── Consumer Auth (Phase 4 — API designed, not implemented yet) ──

  /// RECORD ACCESS `consumer_auth` signin on users/users.
  /// Returns [ConsumerAuthResult] with user connection and profile.
  Future<ConsumerAuthResult> consumerSignin({
    required String email,
    required String password,
  });

  /// RECORD ACCESS `consumer_auth` signup on users/users.
  /// Creates user record with role='customer', returns JWT immediately.
  Future<ConsumerAuthResult> consumerSignup({
    required String name,
    required String email,
    required String password,
  });

  // ── Session Management ──

  /// Attempt to restore a previous session from stored tokens.
  ///
  /// For business users: restores both user token + tenant token.
  /// If access token expired but refresh token valid → auto-refresh.
  /// If both expired → returns null (caller redirects to login).
  Future<BusinessAuthResult?> tryRestoreBusiness();

  /// Future: restore consumer session.
  Future<ConsumerAuthResult?> tryRestoreConsumer();

  /// Sign out: close connections, clear stored tokens.
  Future<void> signOut();

  /// The active tenant connection (available after successful businessSignin or restore).
  /// BP's repository layer reads this for CRUD queries.
  TenantConnection? get activeTenant;
}
```

### 3.2 `AuthBackend` — Swappable Interface

```dart
/// Abstraction over the auth transport layer.
///
/// Today: direct SurrealDB WebSocket calls (SurrealAuthBackend).
/// Tomorrow: HTTP proxy to a backend intermediary (when Vipps OIDC or
/// production-grade credential delivery requires server-side logic).
abstract class AuthBackend {
  /// Phase 1: Authenticate user identity via RECORD ACCESS.
  /// Returns raw tokens + user profile map.
  Future<UserAuthResult> authenticateUser({
    required String email,
    required String password,
    required String accessMethod,   // 'bp_auth' or 'consumer_auth'
  });

  /// Phase 2: Connect to tenant DB with service credentials.
  /// Only used for business auth flow.
  Future<TenantAuthResult> connectTenant({
    required String slug,
  });

  /// Restore session with previously stored tokens.
  Future<RestoredSession> restoreSession({
    required String accessToken,
    String? refreshToken,
    String? tenantSlug,
    String? tenantToken,
  });

  /// Close all active connections.
  Future<void> disconnect();
}
```

### 3.3 `SurrealAuthBackend` — Direct-to-DB Implementation

```dart
/// Direct SurrealDB WebSocket implementation of [AuthBackend].
///
/// Performs the same two-phase auth that BP's SurrealConnection does today,
/// but behind the AuthBackend interface for swappability.
class SurrealAuthBackend implements AuthBackend {
  SurrealAuthBackend({
    this.wsUrl,
    required this.serviceUser,      // 'bp_portal'
    required this.servicePass,      // from --dart-define or runtime config
  });

  final String? wsUrl;              // null → derive from page origin
  final String serviceUser;
  final String servicePass;

  // ... implements authenticateUser, connectTenant, restoreSession, disconnect
}
```

### 3.4 `BusinessAuthResult`

```dart
/// Result of a successful business signin.
///
/// Contains everything BP needs: user profile, tenant connection,
/// and the active slug. Maps directly to BP's current Authenticated state.
class BusinessAuthResult {
  const BusinessAuthResult({
    required this.email,
    required this.name,
    required this.role,
    required this.companySlug,
    required this.tenant,
  });

  final String email;
  final String? name;
  final String role;           // 'business', 'admin', 'super_admin'
  final String companySlug;
  final TenantConnection tenant;
}
```

### 3.5 `TenantConnection`

```dart
/// Wraps the two authenticated SurrealDB connections for a business session.
///
/// Replaces BP's current SurrealConnection class.
/// BP's repository layer uses [companies] for CRUD, [users] for profile ops.
class TenantConnection {
  TenantConnection({
    required this.companies,
    required this.users,
    required this.slug,
  });

  /// Connection to company_{slug} DB (via bp_portal service user).
  final SurrealDB companies;

  /// Connection to users/users DB (via RECORD ACCESS bp_auth).
  final SurrealDB users;

  /// The active tenant slug.
  final String slug;

  /// Close both connections.
  void close() {
    companies.close();
    users.close();
  }
}
```

### 3.6 `TokenStore`

```dart
/// Secure token persistence layer.
///
/// Abstracts FlutterSecureStorage (native) vs localStorage (web, ADR-0009).
/// Stores: access token, refresh token, tenant token, email, slug, name.
class TokenStore {
  TokenStore({FlutterSecureStorage? storage});

  Future<void> saveBusinessSession(BusinessAuthResult result, {
    required String accessToken,
    String? refreshToken,
    required String tenantToken,
  });

  Future<StoredSession?> loadBusinessSession();

  Future<void> clear();
}
```

### 3.7 Exception Hierarchy

```dart
/// Base exception for all ditto_auth failures.
sealed class DittoAuthException implements Exception {
  String get message;
}

/// User's credentials are wrong (email not found, bad password).
/// UI should show a generic "invalid credentials" message.
final class InvalidCredentials extends DittoAuthException { ... }

/// User authenticated but doesn't have the required role.
/// e.g. consumer user trying to log into Business Portal.
final class InsufficientRole extends DittoAuthException { ... }

/// User has no company_slug assigned — can't route to tenant.
final class NoCompanyAssigned extends DittoAuthException { ... }

/// Tenant DB connection failed (bp_portal creds wrong, DB doesn't exist).
/// This is a deployment/config error, not a user error.
final class TenantConnectionFailed extends DittoAuthException { ... }

/// Network/WebSocket failure.
final class ConnectionFailed extends DittoAuthException { ... }

/// Token expired and refresh failed — user must re-authenticate.
final class SessionExpired extends DittoAuthException { ... }
```

---

## 4. BP Migration Path (Phase 3)

The design is deliberately drop-in compatible with BP's current architecture:

| BP today (bespoke) | `ditto_auth` replacement |
|---|---|
| `SurrealAuthService` | `DittoAuth` + `SurrealAuthBackend` |
| `SurrealConnection` | `TenantConnection` |
| `AuthService` (mercury_client) | **Kept.** BP's `AuthNotifier` wraps `DittoAuth` and maps results to `AuthState` |
| `AuthState` (mercury_client) | **Kept.** No changes to the sealed class |
| `auth_provider.dart` | Rewired: `authServiceProvider` creates `DittoAuth`, `AuthNotifier.login()` calls `ditto_auth.businessSignin()` |
| `surreal_connection.dart` | **Deleted.** Replaced by `TenantConnection` from `ditto_auth` |
| `surreal_auth_service.dart` | **Deleted.** Logic moves into `ditto_auth` |
| `web_storage.dart` | **Kept** (or absorbed into `TokenStore`) |

### BP `auth_provider.dart` — After Migration

```dart
/// Provider for DittoAuth instance.
final dittoAuthProvider = Provider<DittoAuth>((ref) {
  return DittoAuth(
    backend: SurrealAuthBackend(
      wsUrl: _surrealUrl.isNotEmpty ? _surrealUrl : null,
      serviceUser: _bpPortalUser,
      servicePass: _bpPortalPass,
    ),
  );
});

/// Auth state provider — same shape as today, delegates to DittoAuth.
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final result = await _dittoAuth.tryRestoreBusiness();
    if (result == null) return const Unauthenticated();
    return Authenticated(
      accessToken: result.tenant.slug,  // or a token reference
      email: result.email,
      name: result.name,
    );
  }

  DittoAuth get _dittoAuth => ref.read(dittoAuthProvider);

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final result = await _dittoAuth.businessSignin(
        email: email,
        password: password,
      );
      state = AsyncData(Authenticated(
        accessToken: result.companySlug,
        email: result.email,
        name: result.name,
      ));
    } on DittoAuthException catch (e) {
      debugPrint('⚠️ Auth error: $e');
      state = const AsyncData(Unauthenticated());
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await _dittoAuth.signOut();
    state = const AsyncData(Unauthenticated());
  }
}
```

### Repository Layer — After Migration

```dart
/// BP's repository gets TenantConnection from DittoAuth.
final surrealConnectionProvider = Provider<TenantConnection?>((ref) {
  return ref.watch(dittoAuthProvider).activeTenant;
});
```

This is a **mechanical refactor** — the shape is identical, the logic is the same, just the source moves from BP-local to `packages/ditto_auth/`.

---

## 5. Token Lifecycle with `WITH REFRESH`

```
┌─────────────┐     businessSignin()      ┌────────────────┐
│  Login Form  │ ─────────────────────────▶│   DittoAuth    │
└─────────────┘                            └───────┬────────┘
                                                   │
                              ┌─────────────────────┼──────────────────────┐
                              │  AuthBackend         │                      │
                              │                      ▼                      │
                              │  Phase 1: bp_auth SIGNIN (WITH REFRESH)     │
                              │  → access_token (15m) + refresh_token       │
                              │  → query $auth for role + company_slug      │
                              │                      │                      │
                              │                      ▼                      │
                              │  Phase 2: bp_portal SIGNIN on company_{slug}│
                              │  → tenant_token (1h)                        │
                              │                      │                      │
                              └──────────────────────┼──────────────────────┘
                                                     │
                                                     ▼
                                              TokenStore.save()
                                              → access_token
                                              → refresh_token
                                              → tenant_token
                                              → email, slug, name

On 401 / token expiry:
  1. Try refresh_token → new access_token (no password prompt)
  2. Re-signin bp_portal with new identity (Phase 2 replay)
  3. If refresh fails → SessionExpired → redirect to login
```

---

## 6. What Stays in `mercury_client`

`ditto_auth` does NOT absorb `mercury_client`. They are separate concerns:

| Package | Responsibility |
|---|---|
| `mercury_client` | HTTP client, admin API, data models, `AuthState` ADT |
| `ditto_auth` | SurrealDB auth flows, token lifecycle, tenant routing |

`ditto_auth` depends on `surrealdb` (Dart SDK) and `flutter_secure_storage`.
`ditto_auth` does NOT depend on `mercury_client`.

BP imports both. `AuthState` stays in `mercury_client`. `ditto_auth` returns its own result types (`BusinessAuthResult`), and BP's `AuthNotifier` maps them to `AuthState`.

---

## 7. Resolved Design Decisions

> **Q1: `AuthState` stays in `mercury_client`.** ✅
> Both BP and Marketplace already import `mercury_client`. No cross-dependency needed. `ditto_auth` returns its own result types; app-level `AuthNotifier` maps them to `AuthState`.

> **Q2: Token durations — defer to Phase 2.** ✅
> Current schema has long durations (`24h` token / `7d` session). Phase 2 will tighten to `15m` token / `8h` business session + `WITH REFRESH`. These are single-line schema changes — fully adjustable at any time. No impact on package API design.

> **Q3: `bp_portal` password — staging vs production.** ✅
> **Staging:** password baked into the app at build time (`--dart-define`). Fine for now.
> **Production:** can't ship secrets in a web bundle. A small backend will deliver the credential at runtime. The `AuthBackend` interface makes this swap painless — change one class, zero app code changes.
