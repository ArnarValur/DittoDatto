# Code Safety Rules

> Enforces [ADR-0015](../adr/0015-no-hardcoded-secrets-or-ids.md). These rules apply to **every file in the repository** — `lib/`, `bin/`, `scripts/`, `test/`, config files, schema files. There is no "throwaway" directory.

---

## 1. No Secrets in Source

**Never** commit plaintext credentials, API keys, tokens, or passwords.

```dart
// ❌ PROHIBITED
await db.signin(user: 'arnarvalur', pass: 'admin123', namespace: 'users');

// ✅ REQUIRED
final user = Platform.environment['SURREAL_USER'];
final pass = Platform.environment['SURREAL_PASS'];
if (user == null || pass == null) {
  stderr.writeln('Set SURREAL_USER and SURREAL_PASS environment variables.');
  exit(1);
}
await db.signin(user: user, pass: pass, namespace: 'users');
```

Common violations to watch for:
- `pass:` / `password:` / `secret:` with string literals
- `Authorization: Bearer <token>` with real tokens
- AWS (`AKIA...`), GCP (`AIza...`), or any provider key patterns

---

## 2. No Hardcoded Record IDs

**Never** embed raw SurrealDB record IDs in source code.

```dart
// ❌ PROHIBITED
await db.query(r'UPDATE user:dj6gm82md9uq2yyfxgrg SET role = "super_admin"');

// ✅ REQUIRED — accept as argument
final userId = args[0]; // e.g., 'dj6gm82md9uq2yyfxgrg'
await db.query(
  r'UPDATE type::record("user", $id) SET role = "super_admin"',
  {'id': userId},
);

// ✅ ALSO OK — query by attribute
await db.query(
  r'UPDATE user WHERE email = $email SET role = "super_admin"',
  {'email': 'arnar@dittodatto.no'},
);
```

Why: hardcoded IDs lock execution to a specific database state. If the DB is reset, migrated, or the script runs in another namespace, it silently mutates the wrong records or crashes.

---

## 3. Defensive Response Parsing

**Never** chain `.first['result'].first` on untyped dynamic results without bounds checking.

```dart
// ❌ PROHIBITED — crashes on empty results or unexpected structure
final result = (await db.query('SELECT * FROM user')) as List;
final name = result.first['result'].first['name'];

// ✅ REQUIRED — validate before access
final result = (await db.query('SELECT * FROM user')) as List;
if (result.isEmpty || result.first['result'] is! List) {
  throw StateError('Unexpected query response shape: $result');
}
final rows = result.first['result'] as List;
if (rows.isEmpty) {
  throw StateError('No users found.');
}
final name = rows.first['name'] as String?;
```

Prefer typed models when available:
```dart
final user = User.fromJson(rows.first);
```

---

## 4. Transaction Safety

**Never** perform multi-record database mutations in a bare loop.

```dart
// ❌ PROHIBITED — partial failure leaves DB inconsistent
for (final user in users) {
  await db.query(r'UPDATE type::record("user", $id) SET ...', {'id': user.id});
}

// ✅ REQUIRED — atomic transaction
await db.query(r'''
  BEGIN TRANSACTION;
  -- all mutations here
  COMMIT TRANSACTION;
''');
```

Why: if the network drops or the script crashes mid-loop, the database is left in a partially updated (inconsistent) state.

---

## 5. No "Throwaway" Exemption

Every directory in this repository is production-grade:

| Directory | Same rules as `lib/`? |
|---|---|
| `bin/` | **Yes** |
| `scripts/` | **Yes** |
| `test/` | **Yes** |
| `schemas/` | **Yes** |
| `conductor/` | **Yes** |

If you think "this is just a quick utility script" — that thought is the bug. The script will be committed, it will be read by other agents, and its patterns will be copied.
