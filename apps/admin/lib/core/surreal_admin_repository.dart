import 'package:mercury_client/mercury_client.dart';

import 'surreal_connection.dart';

/// Admin repository backed by real SurrealDB queries.
///
/// Routes queries to the correct namespace/database:
/// - Users → `users/profiles`
/// - Companies → `companies/registry`
/// - Categories → `companies/discovery`
class SurrealAdminRepository implements AdminRepository {
  SurrealAdminRepository({required this.connection});

  final SurrealConnection connection;

  // ── Stats ──

  @override
  Future<AdminStats> getStats() async {
    await connection.users.use('users', 'profiles');
    final userResult = await connection.users.query(
      'SELECT count() FROM user GROUP ALL',
    );
    final userCount = _extractCount(userResult);

    await connection.companies.use('companies', 'registry');
    final companyResult = await connection.companies.query(
      'SELECT count() FROM company GROUP ALL',
    );
    final companyCount = _extractCount(companyResult);

    await connection.companies.use('companies', 'discovery');
    final categoryResult = await connection.companies.query(
      'SELECT count() FROM category GROUP ALL',
    );
    final categoryCount = _extractCount(categoryResult);

    return AdminStats(
      userCount: userCount,
      companyCount: companyCount,
      categoryCount: categoryCount,
      engineHealthy: true, // No engine deployed yet — report healthy.
    );
  }

  // ── Users ──

  @override
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int pageSize = 50,
    String? searchQuery,
  }) async {
    await connection.users.use('users', 'profiles');
    final start = (page - 1) * pageSize;

    String countQuery = "SELECT count() FROM user WHERE role IN ['customer', 'business']";
    String selectQuery = "SELECT * FROM user WHERE role IN ['customer', 'business']";
    final Map<String, dynamic> params = {
      'pageSize': pageSize,
      'start': start,
    };

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      params['search'] = '%${searchQuery.trim().toLowerCase()}%';
      final searchClause = r' AND (string::lowercase(name) LIKE $search OR string::lowercase(email) LIKE $search)';
      countQuery += searchClause;
      selectQuery += searchClause;
    }

    countQuery += ' GROUP ALL';
    selectQuery += r' ORDER BY created_at DESC LIMIT $pageSize START $start';

    final countResult = await connection.users.query(countQuery, params);
    final total = _extractCount(countResult);

    final result = await connection.users.query(selectQuery, params);
    final items = _parseList<User>(result, User.fromJson);

    return PaginatedResponse(
      items: items,
      total: total,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<void> updateUserRole(String userId, ActorRole newRole) async {
    await connection.users.use('users', 'profiles');
    await connection.users.query(
      r'UPDATE type::record("user", $id) SET role = $role, updated_at = time::now()',
      {'id': userId, 'role': newRole.value},
    );
  }

  @override
  Future<User> createUser(User user) async {
    await connection.users.use('users', 'profiles');
    final data = user.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');

    final result = await connection.users.create('user', data);
    return User.fromJson(_normalizeRecord(result));
  }

  // ── Companies ──

  @override
  Future<PaginatedResponse<Company>> getCompanies({
    int page = 1,
    int pageSize = 50,
  }) async {
    await connection.companies.use('companies', 'registry');
    final start = (page - 1) * pageSize;

    final countResult = await connection.companies.query(
      'SELECT count() FROM company GROUP ALL',
    );
    final total = _extractCount(countResult);

    final result = await connection.companies.query(
      r'SELECT * FROM company ORDER BY created_at DESC LIMIT $pageSize START $start',
      {'pageSize': pageSize, 'start': start},
    );

    final items = _parseList<Company>(result, Company.fromJson);

    return PaginatedResponse(
      items: items,
      total: total,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Company> createCompany(Company company) async {
    await connection.companies.use('companies', 'registry');
    final data = company.toJson()
      ..remove('id')
      ..['created_at'] = DateTime.now().toIso8601String()
      ..['updated_at'] = DateTime.now().toIso8601String();

    final result = await connection.companies.create('company', data);
    return Company.fromJson(_normalizeRecord(result));
  }

  @override
  Future<Company> updateCompany(Company company) async {
    await connection.companies.use('companies', 'registry');
    final data = company.toJson()
      ..remove('id')
      ..['updated_at'] = DateTime.now().toIso8601String();

    final result = await connection.companies.update(
      'company:${company.id}',
      data,
    );
    return Company.fromJson(_normalizeRecord(result));
  }

  // ── Categories ──

  @override
  Future<PaginatedResponse<Category>> getCategories({
    int page = 1,
    int pageSize = 50,
  }) async {
    await connection.companies.use('companies', 'discovery');
    final start = (page - 1) * pageSize;

    final countResult = await connection.companies.query(
      'SELECT count() FROM category GROUP ALL',
    );
    final total = _extractCount(countResult);

    final result = await connection.companies.query(
      r'SELECT * FROM category ORDER BY name ASC LIMIT $pageSize START $start',
      {'pageSize': pageSize, 'start': start},
    );

    final items = _parseList<Category>(result, Category.fromJson);

    return PaginatedResponse(
      items: items,
      total: total,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Category> createCategory(Category category) async {
    await connection.companies.use('companies', 'discovery');
    final data = category.toJson()
      ..remove('id')
      ..['created_at'] = DateTime.now().toIso8601String()
      ..['updated_at'] = DateTime.now().toIso8601String();

    final result = await connection.companies.create('category', data);
    return Category.fromJson(_normalizeRecord(result));
  }

  @override
  Future<Category> updateCategory(Category category) async {
    await connection.companies.use('companies', 'discovery');
    final data = category.toJson()
      ..remove('id')
      ..['updated_at'] = DateTime.now().toIso8601String();

    final result = await connection.companies.update(
      'category:${category.id}',
      data,
    );
    return Category.fromJson(_normalizeRecord(result));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await connection.companies.use('companies', 'discovery');
    await connection.companies.delete('category:$id');
  }

  // ── Helpers ──

  /// Extract count from a `SELECT count() ... GROUP ALL` result.
  int _extractCount(dynamic result) {
    try {
      if (result is List && result.isNotEmpty) {
        final first = result.first;
        if (first is Map && first.containsKey('count')) {
          return (first['count'] as num).toInt();
        }
        // Nested result format: [{result: [{count: N}]}]
        if (first is Map && first.containsKey('result')) {
          final inner = first['result'];
          if (inner is List && inner.isNotEmpty && inner.first is Map) {
            return ((inner.first as Map)['count'] as num?)?.toInt() ?? 0;
          }
        }
      }
    } catch (_) {}
    return 0;
  }

  /// Parse a query result into a typed list.
  List<T> _parseList<T>(
    dynamic result,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      List<dynamic> records;

      if (result is List && result.isNotEmpty) {
        final first = result.first;
        if (first is Map && first.containsKey('result')) {
          records = first['result'] as List? ?? [];
        } else {
          records = result;
        }
      } else {
        return [];
      }

      return records
          .whereType<Map<String, dynamic>>()
          .map((r) => fromJson(_normalizeRecord(r)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Normalize a SurrealDB record for Dart model consumption.
  ///
  /// SurrealDB returns `id` as a record link (e.g. `user:abc123`).
  /// Our Dart models expect a plain string ID.
  Map<String, dynamic> _normalizeRecord(dynamic record) {
    if (record is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }
    final map = Map<String, dynamic>.from(record);

    // Convert SurrealDB record ID (e.g. "user:abc123") to plain ID.
    if (map['id'] is String) {
      final id = map['id'] as String;
      if (id.contains(':')) {
        map['id'] = id.split(':').last;
      }
    }

    return map;
  }
}
