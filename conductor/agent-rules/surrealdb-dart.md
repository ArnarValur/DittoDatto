# SurrealDB ↔ Dart — Foot-Guns & Mandatory Patterns

> Born from 25 days of production bugs (May 27 – June 20 2026).
> Every example below is from the DittoDatto codebase. Follow these patterns exactly.

---

## 1. NULL vs NONE — The #1 Bug Source

**Problem:** Dart `null` serializes to SurrealDB `NULL`. But `option<T>` fields reject `NULL` — they accept `NONE` (absent) or `T`.

**Every optional field in a CREATE or UPDATE query MUST coerce:**

```sql
-- ✅ REQUIRED pattern for every option<T> field
phone = IF $phone = NULL OR $phone = "" THEN none ELSE $phone END

-- ❌ PROHIBITED — will be rejected by SCHEMAFULL tables
phone = $phone
```

**Real example** (`surreal_admin_repository.dart`):
```dart
r'CREATE user SET name = $name, email = $email, username = $username, '
r'phone = IF $phone = NULL OR $phone = "" THEN none ELSE $phone END, '
r'role = $role, '
r'company_slug = IF $company_slug = NULL OR $company_slug = "" THEN none ELSE $company_slug END, '
r'vipps_sub = IF $vipps_sub = NULL OR $vipps_sub = "" THEN none ELSE $vipps_sub END, '
r'password_hash = crypto::argon2::generate($password)',
```

**Dart-side defense** — also strip nulls from maps before `.create()` or MERGE:
```dart
Map<String, dynamic> _removeNullsFromMap(Map<String, dynamic> map) {
  final cleaned = <String, dynamic>{};
  for (final entry in map.entries) {
    if (entry.value == null) continue;  // Strip null keys entirely
    if (entry.value is Map<String, dynamic>) {
      cleaned[entry.key] = _removeNullsFromMap(entry.value);
    } else {
      cleaned[entry.key] = entry.value;
    }
  }
  return cleaned;
}
```

**Rule:** Use BOTH defenses. SurrealQL coercion for raw queries, `_removeNullsFromMap` for SDK `.create()` / MERGE maps.

---

## 2. MERGE vs SET — Never Combine

```sql
-- ✅ CORRECT — MERGE with a map
UPDATE type::record("company", $id) MERGE $data

-- ✅ CORRECT — SET with individual fields
UPDATE type::record("user", $id) SET name = $name, role = $role

-- ❌ PROHIBITED — SurrealDB rejects this
UPDATE type::record("user", $id) MERGE $data SET name = $name
```

**When to use which:**
- **MERGE** — when passing an entire cleaned Dart map (`$data`). Preserves fields not in the map.
- **SET** — when building field-by-field with NULL→NONE coercion or conditional logic (e.g., optional password update).

---

## 3. Record ID Formatting

### In SurrealQL queries — use `type::record()`:
```dart
// ✅ Parameterized — safe, portable
r'SELECT * FROM type::record("company", $id)'
r'UPDATE type::record("user", $id) SET role = $role'
r'DELETE type::record("establishment", $id)'
```

### With SDK `.delete()` — use `table:$id`:
```dart
// ✅ SDK delete method expects this format
await connection.users.delete('user:$id');
await connection.companies.delete('company:$id');
```

### Backtick quoting for hyphens:
```sql
-- ✅ DB names with hyphens MUST be backtick-quoted
USE NS companies DB `company_dittodatto-as`;

-- ❌ Will fail
USE NS companies DB company_dittodatto-as;
```

---

## 4. Query Response Parsing — Two Shapes

The SurrealDB Dart SDK returns **inconsistent response shapes**. Always handle both.

```dart
/// Parse a list query result into typed models.
List<T> _parseList<T>(dynamic result, T Function(Map<String, dynamic>) fromJson) {
  List<dynamic> records;
  if (result is List && result.isNotEmpty) {
    final first = result.first;
    if (first is Map && first.containsKey('result')) {
      records = first['result'] as List? ?? [];   // Shape A: [{result: [...]}]
    } else {
      records = result;                            // Shape B: [record, record, ...]
    }
  } else {
    return [];
  }
  return records
      .whereType<Map<String, dynamic>>()
      .map((r) => fromJson(_normalizeRecord(r)))
      .toList();
}
```

**Never do this:**
```dart
// ❌ PROHIBITED — crashes on empty results or unexpected shape
final name = result.first['result'].first['name'];
```

### ID normalization — SDK returns prefixed IDs:
```dart
/// SDK returns "user:abc123" — strip table prefix for app use.
Map<String, dynamic> _normalizeRecord(dynamic record) {
  if (record is List) record = record.first;
  final map = Map<String, dynamic>.from(record);
  if (map['id'] is String) {
    final id = map['id'] as String;
    if (id.contains(':')) {
      map['id'] = id.split(':').last;
    }
  }
  return map;
}
```

---

## 5. Password Hashing — argon2, Never Plaintext

### In SurrealQL schemas (RECORD ACCESS SIGNIN):
```sql
DEFINE ACCESS bp_auth ON DATABASE TYPE RECORD
  SIGNIN (
    SELECT *
    FROM user
    WHERE email = $email
      AND crypto::argon2::compare(password_hash, $pass)
  )
  DURATION FOR TOKEN 24h, FOR SESSION 7d;
```

### In Dart CREATE/UPDATE queries:
```dart
// ✅ Hash on the DB side, not in Dart
r'password_hash = crypto::argon2::generate($password)'
```

**Never store plaintext passwords. Never hash in Dart — let SurrealDB's `crypto::argon2` do it.**

---

## 6. SCHEMAFULL + RECORD ACCESS Permissions

When a table is `SCHEMAFULL` with `RECORD ACCESS`, the authenticated user needs explicit SELECT permission on their own record:

```sql
-- ✅ REQUIRED — without this, RECORD ACCESS users can't read their own data
DEFINE TABLE user SCHEMAFULL
  PERMISSIONS
    FOR select WHERE id = $auth.id
    FOR create, update, delete NONE;
```

**Missing this causes silent empty results** — the query succeeds but returns nothing.

---

## 7. RECORD ACCESS SIGNIN — Match on Full Email

```sql
-- ✅ CORRECT — match on full email
WHERE email = $email

-- ❌ WRONG — username prefix matching allows collision attacks
WHERE string::starts_with(email, $username)
```

---

## 8. CREATE vs UPDATE Behavior

| Operation | Returns | Watch for |
|-----------|---------|-----------|
| `CREATE table SET ...` | Array with new record | Duplicate key → error (not upsert) |
| `UPDATE ... SET ...` | Array with updated record | Non-existent ID → creates the record (!) |
| `UPDATE ... MERGE $data` | Array with merged record | Preserves fields not in `$data` |
| `.create('table', map)` | The created record | Must strip nulls from map first |
| `.delete('table:$id')` | Deleted record or null | Safe on non-existent IDs |

---

## 9. Integration Tests Are Mandatory

**Every DB-facing feature needs an integration test against real SurrealDB before shipping.**

Test infrastructure:
- `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000
- `flutter test --tags integration` → runs tagged tests
- `./scripts/test-db-down.sh` → teardown

Test helper pattern (`test/integration/helpers/test_connection.dart`):
```dart
Future<SurrealConnection> connectTestAdmin({
  String url = 'ws://localhost:18000/rpc',
  String user = 'testadmin',
  String pass = 'testadmin-pass',
}) async {
  final result = await SurrealConnection.connect(
    user: user, pass: pass, url: url,
  );
  return result.connection;
}

Future<void> cleanTable(SurrealDB db, String table) async {
  try {
    await db.query('DELETE $table');
  } catch (_) {}
}
```

**Widget tests that mock SurrealDB prove nothing about data correctness.** Only integration tests against a real DB catch NULL/NONE, MERGE, permissions, and schema bugs.

---

## Quick Reference — Copy-Paste Templates

### CREATE with optional fields:
```dart
await db.query(
  r'CREATE tablename SET '
  r'required_field = $required, '
  r'optional_field = IF $optional = NULL OR $optional = "" THEN none ELSE $optional END',
  {'required': value, 'optional': nullableValue},
);
```

### UPDATE with MERGE:
```dart
final cleanedData = _removeNullsFromMap(data);
await db.query(
  r'UPDATE type::record("tablename", $id) MERGE $data',
  {'id': recordId, 'data': cleanedData},
);
```

### UPDATE with SET (when you need NULL→NONE coercion):
```dart
await db.query(
  r'UPDATE type::record("tablename", $id) SET '
  r'name = $name, '
  r'optional = IF $optional = NULL THEN none ELSE $optional END',
  {'id': recordId, 'name': name, 'optional': nullableValue},
);
```
