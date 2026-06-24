# Auth Service Research — Phase 1 Findings

> **Track:** `auth_service_20260624`
> **Last updated:** 2026-06-24 16:04
> **SurrealDB version tested:** 3.0.5

---

## Task 1: SurrealDB Multi-Access Patterns ✅

**Question:** Can `users/users` have both `consumer_auth` and `bp_auth` as separate RECORD ACCESS definitions?

**Answer: Yes.** Fully verified.

### Findings

| Finding | Detail |
|---|---|
| **Multi-access coexistence** | Two `DEFINE ACCESS ... TYPE RECORD` on one DB works. Each gets its own auto-generated JWT signing key (HS512). |
| **JWT token claims** | Token contains `AC: consumer_auth` or `AC: bp_auth` — identifies which access method was used. Client-side readable. |
| **`$auth` scope isolation** | Table `PERMISSIONS FOR select WHERE id = $auth.id` works identically for both access methods. User can only SELECT their own record. |
| **Cross-access isolation** | `consumer_auth` with `AND role = 'customer'` correctly rejects business users. ✅ |

### Action Required

**`bp_auth` must add a role gate.** Current definition accepts ANY user with valid `password_hash`:

```sql
-- BEFORE (vulnerable)
SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password_hash, $pass))

-- AFTER (secure)
SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password_hash, $pass) AND role IN ['business', 'admin', 'super_admin'])
```

### Gotchas

- `DEFINE ACCESS` errors if the name already exists. Use `REMOVE ACCESS ... ON DATABASE` first, or `DEFINE ACCESS IF NOT EXISTS`.
- No `$auth.AC` in SurrealQL queries — can't query "which access method" inside a query. Isolation must be enforced in the SIGNIN clause itself.

---

## Task 2: RECORD ACCESS SIGNUP Clause ✅

**Question:** Can `consumer_auth` use SIGNUP for consumer self-registration?

**Answer: Yes.** Fully verified.

### Findings

| Finding | Detail |
|---|---|
| **SIGNUP + SCHEMAFULL** | Works. SIGNUP clause CREATE executes with system-level permissions (bypasses table PERMISSIONS). Created record respects all SCHEMAFULL constraints. |
| **Argon2 in SIGNUP** | `crypto::argon2::generate($pass)` hashes password server-side. Raw password never persists. |
| **Default fields** | SIGNUP clause values override schema DEFAULTs. Explicitly set `role = 'customer'` to enforce. |
| **Token on signup** | Returns JWT immediately — user is authenticated in the same request. |
| **Duplicate email** | UNIQUE index on `email` rejects duplicate signup with an error. Client must handle gracefully. |
| **HTTP API** | `POST /signup` with `{ns, db, ac, ...params}`. Dart SDK uses the same endpoint. |

### Prototype `consumer_auth`

```sql
DEFINE ACCESS consumer_auth ON DATABASE TYPE RECORD
  SIGNUP (
    CREATE user SET
      name = $name,
      email = $email,
      password_hash = crypto::argon2::generate($pass),
      role = 'customer',
      is_onboarded = false,
      language = 'en',
      company_memberships = [],
      company_membership_ids = [],
      bankid_verified = false
  )
  SIGNIN (
    SELECT * FROM user
    WHERE email = $email
      AND crypto::argon2::compare(password_hash, $pass)
      AND role = 'customer'
  )
  WITH REFRESH
  DURATION FOR TOKEN 15m, FOR SESSION 24h;
```

---

## Task 3: Token Lifecycle & Session Strategy ✅

**Question:** Can tokens be refreshed without re-authenticating?

**Answer: Yes — `WITH REFRESH` is supported in SurrealDB 3.x.** Game-changer.

### Findings

| Finding | Detail |
|---|---|
| **`WITH REFRESH`** | Adding `WITH REFRESH` to `DEFINE ACCESS` enables refresh tokens. Signin response returns `{access: "jwt...", refresh: "surreal-refresh-..."}` instead of a plain token string. |
| **Short-lived access tokens** | Recommended: 15m access token + 24h session. The refresh token extends the session without re-entering credentials. |
| **Dart SDK support** | SDK supports `.SignInWithRefresh()` and `.SignUpWithRefresh()` — `ditto_auth` should use these. |
| **Session vs Token** | `DURATION FOR TOKEN 15m` = JWT validity. `DURATION FOR SESSION 24h` = absolute session lifetime. Refresh extends within session bounds. |

### Recommended Token Strategy

| Access | Token Duration | Session Duration | Refresh |
|---|---|---|---|
| `consumer_auth` | 15m | 24h | ✅ WITH REFRESH |
| `bp_auth` | 15m | 8h (business day) | ✅ WITH REFRESH |
| `bp_portal` (service user) | 1h | 12h | N/A (system user, not RECORD ACCESS) |

### `ditto_auth` Impact

- Store BOTH access token AND refresh token in FlutterSecureStorage
- On token expiry: use refresh token to get new access token (no password prompt)
- On session expiry: redirect to login
- On app startup: try restore with stored access token first, fall back to refresh, then login

---

## Task 4: `bp_portal` Security Upgrade ✅

**Question:** Can we use PASSHASH for provisioning? Can we generate unique passwords per tenant?

**Answer: Yes to both.** Fully verified.

### Findings

| Finding | Detail |
|---|---|
| **PASSHASH works** | `DEFINE USER bp_portal ON DATABASE PASSHASH '$argon2id$...' ROLES EDITOR DURATION FOR SESSION 12h` — accepted and signin works. |
| **Hash generation** | Use SurrealQL: `RETURN crypto::argon2::generate($password)` to generate the hash, then pass it to PASSHASH. |
| **Signin with PASSHASH** | Standard signin with the original password works — SurrealDB validates against the stored argon2 hash. |
| **DURATION for service users** | `DURATION FOR SESSION 12h` limits exposure window. |

### Provisioning Flow (Updated)

```
1. Generate unique password: uuid() or crypto-random string
2. Generate argon2 hash: RETURN crypto::argon2::generate($password)
3. Define user: DEFINE USER bp_portal ON DATABASE PASSHASH '$hash' ROLES EDITOR DURATION FOR SESSION 12h
4. Deliver password securely to the BP auth flow (NOT compiled into client)
```

### Secure Credential Delivery Options (for future backend intermediary)

| Option | Viability | Notes |
|---|---|---|
| Backend proxy (MercuryEngine or Auth Service) | ✅ Best | Client authenticates user, backend handles tenant routing with stored credentials |
| Runtime config / secrets manager | ✅ Good | Fetch credential at runtime from a secure endpoint |
| `--dart-define` at build time | ⚠️ Staging only | Shared password, compiled into bundle — acceptable for staging but not production |
| Environment variable injection | ⚠️ Server-rendered only | Works for SSR, not for Flutter web SPA |

**Staging strategy:** Continue with `--dart-define` (shared password) for now. The Auth Service backend intermediary (future Option 2) will handle secure credential delivery in production.

---

## Task 5: `ditto_auth` Package API Design 🔲

**Status:** Ready to design — all prerequisite research is complete.

### Key Design Inputs from Research

1. **Two access methods, one package:** `consumerSignin()`, `consumerSignup()`, `businessSignin()`
2. **Refresh tokens:** Store access + refresh tokens. Auto-refresh on 401.
3. **Tenant routing:** After business signin, route to `company_{slug}` DB via `bp_portal`.
4. **Abstraction layer:** Interface that can be swapped from direct-to-DB to backend proxy.
5. **`switchCompany()` extension point:** For future multi-company support.
