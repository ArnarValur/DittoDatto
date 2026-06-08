import 'dart:convert';
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
  }) async {
    await connection.users.use('users', 'profiles');
    final start = (page - 1) * pageSize;

    final countResult = await connection.users.query(
      "SELECT count() FROM user GROUP ALL",
    );
    final total = _extractCount(countResult);

    final result = await connection.users.query(
      r"SELECT * FROM user ORDER BY created_at DESC LIMIT $pageSize START $start",
      {'pageSize': pageSize, 'start': start},
    );
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
    final rawData = user.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');

    final data = jsonDecode(jsonEncode(rawData)) as Map<String, dynamic>;
    final cleanedData = _removeNullsFromMap(data);
    final result = await connection.users.create('user', cleanedData);
    return User.fromJson(_normalizeRecord(result));
  }

  @override
  Future<User> updateUser(User user) async {
    await connection.users.use('users', 'profiles');
    final rawData = user.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');

    final data = jsonDecode(jsonEncode(rawData)) as Map<String, dynamic>;
    final cleanedData = _removeNullsFromMap(data);
    
    final result = await connection.users.query(
      r'UPDATE type::record("user", $id) MERGE $data SET phone = IF $phone = NULL OR $phone = "" THEN none ELSE $phone END, company_slug = IF $company_slug = NULL OR $company_slug = "" THEN none ELSE $company_slug END',
      {
        'id': user.id,
        'data': cleanedData,
        'phone': user.phone,
        'company_slug': user.companySlug,
      },
    );
    
    final list = _parseList<User>(result, User.fromJson);
    if (list.isEmpty) {
      throw Exception('Failed to update user: record not found');
    }
    return list.first;
  }

  @override
  Future<void> deleteUser(String id) async {
    await connection.users.use('users', 'profiles');
    await connection.users.delete('user:$id');
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
    final rawData = company.toJson()
      ..remove('id')
      ..['created_at'] = DateTime.now().toUtc().toIso8601String()
      ..['updated_at'] = DateTime.now().toUtc().toIso8601String();

    final data = jsonDecode(jsonEncode(rawData)) as Map<String, dynamic>;
    final cleanedData = _removeNullsFromMap(data);
    final result = await connection.companies.create('company', cleanedData);
    final createdCompany = Company.fromJson(_normalizeRecord(result));

    // Fetch all companies owned by this owner to list all slugs
    final ownerCompaniesResult = await connection.companies.query(
      r'SELECT * FROM company WHERE owner_id = $ownerId',
      {'ownerId': company.ownerId},
    );
    final ownerCompanies = _parseList<Company>(ownerCompaniesResult, Company.fromJson);
    if (!ownerCompanies.any((c) => c.id == createdCompany.id)) {
      ownerCompanies.add(createdCompany);
    }
    final allSlugs = ownerCompanies.map((c) => c.slug).join(', ');

    // Atomically connect the User profile with the new company slugs!
    await connection.users.use('users', 'profiles');
    await connection.users.query(
      r'UPDATE type::record("user", $owner_id) SET role = IF role = "admin" OR role = "super_admin" THEN role ELSE "business" END, company_slug = $slugs, company_membership_ids = $comp_ids, company_memberships = $memberships',
      {
        'owner_id': company.ownerId,
        'slugs': allSlugs,
        'comp_ids': ownerCompanies.map((c) => c.id).toList(),
        'memberships': ownerCompanies.map((c) => {
          'company_id': c.id,
          'role': 'owner',
          'assigned_at': DateTime.now().toUtc().toIso8601String(),
        }).toList(),
      },
    );

    return createdCompany;
  }

  @override
  Future<Company> updateCompany(Company company) async {
    await connection.companies.use('companies', 'registry');
    
    // Get the old company details to check if owner changed
    final oldResult = await connection.companies.query(
      r'SELECT * FROM type::record("company", $id)',
      {'id': company.id},
    );
    final oldList = _parseList<Company>(oldResult, Company.fromJson);
    final String? oldOwnerId = oldList.isNotEmpty ? oldList.first.ownerId : null;

    final rawData = company.toJson()
      ..remove('id')
      ..['updated_at'] = DateTime.now().toUtc().toIso8601String();

    final data = jsonDecode(jsonEncode(rawData)) as Map<String, dynamic>;
    final cleanedData = _removeNullsFromMap(data);
    
    final result = await connection.companies.query(
      r'UPDATE type::record("company", $id) MERGE $data',
      {
        'id': company.id,
        'data': cleanedData,
      },
    );
    
    final list = _parseList<Company>(result, Company.fromJson);
    if (list.isEmpty) {
      throw Exception('Failed to update company: record not found');
    }
    
    final updatedCompany = list.first;

    // If owner changed, update the user records!
    if (oldOwnerId != null && oldOwnerId != updatedCompany.ownerId) {
      // Check if the old owner still owns any other companies (besides this one)
      await connection.companies.use('companies', 'registry');
      final otherCompaniesResult = await connection.companies.query(
        r'SELECT * FROM company WHERE owner_id = $ownerId AND id != $company_id',
        {
          'ownerId': oldOwnerId,
          'company_id': updatedCompany.id,
        },
      );
      final otherCompanies = _parseList<Company>(otherCompaniesResult, Company.fromJson);

      await connection.users.use('users', 'profiles');

      if (otherCompanies.isNotEmpty) {
        // The old owner still owns other companies. Update their primary slugs and memberships.
        final otherSlugs = otherCompanies.map((c) => c.slug).join(', ');
        final otherMemberships = otherCompanies.map((c) => {
          'company_id': c.id,
          'role': 'owner',
          'assigned_at': DateTime.now().toUtc().toIso8601String(),
        }).toList();

        await connection.users.query(
          r'UPDATE type::record("user", $ownerId) SET company_slug = $next_slugs, company_membership_ids = $comp_ids, company_memberships = $memberships',
          {
            'ownerId': oldOwnerId,
            'next_slugs': otherSlugs,
            'comp_ids': otherCompanies.map((c) => c.id).toList(),
            'memberships': otherMemberships,
          },
        );
      } else {
        // The old owner owns no other companies. Revert them to customer, preserving administrative roles.
        await connection.users.query(
          r'UPDATE type::record("user", $ownerId) SET role = IF role = "admin" OR role = "super_admin" THEN role ELSE "customer" END, company_slug = none, company_membership_ids = [], company_memberships = []',
          {
            'ownerId': oldOwnerId,
          },
        );
      }

      // 2. Add company membership/slug to the new owner
      await connection.companies.use('companies', 'registry');
      final newOwnerCompaniesResult = await connection.companies.query(
        r'SELECT * FROM company WHERE owner_id = $ownerId',
        {'ownerId': updatedCompany.ownerId},
      );
      final newOwnerCompanies = _parseList<Company>(newOwnerCompaniesResult, Company.fromJson);
      if (!newOwnerCompanies.any((c) => c.id == updatedCompany.id)) {
        newOwnerCompanies.add(updatedCompany);
      }
      final newSlugs = newOwnerCompanies.map((c) => c.slug).join(', ');

      await connection.users.use('users', 'profiles');
      await connection.users.query(
        r'UPDATE type::record("user", $owner_id) SET role = IF role = "admin" OR role = "super_admin" THEN role ELSE "business" END, company_slug = $slugs, company_membership_ids = $comp_ids, company_memberships = $memberships',
        {
          'owner_id': updatedCompany.ownerId,
          'slugs': newSlugs,
          'comp_ids': newOwnerCompanies.map((c) => c.id).toList(),
          'memberships': newOwnerCompanies.map((c) => {
            'company_id': c.id,
            'role': 'owner',
            'assigned_at': DateTime.now().toUtc().toIso8601String(),
          }).toList(),
        },
      );
    }

    return updatedCompany;
  }

  @override
  Future<void> deleteCompany(String id) async {
    await connection.companies.use('companies', 'registry');
    final queryResult = await connection.companies.query(
      r'SELECT * FROM company WHERE id = $id',
      {'id': id},
    );
    final companies = _parseList<Company>(queryResult, Company.fromJson);
    if (companies.isNotEmpty) {
      final comp = companies.first;
      
      // Check if they own any other companies
      final otherCompaniesResult = await connection.companies.query(
        r'SELECT * FROM company WHERE owner_id = $ownerId AND id != $company_id',
        {
          'ownerId': comp.ownerId,
          'company_id': comp.id,
        },
      );
      final otherCompanies = _parseList<Company>(otherCompaniesResult, Company.fromJson);

      await connection.users.use('users', 'profiles');

      if (otherCompanies.isNotEmpty) {
        final otherSlugs = otherCompanies.map((c) => c.slug).join(', ');
        final otherMemberships = otherCompanies.map((c) => {
          'company_id': c.id,
          'role': 'owner',
          'assigned_at': DateTime.now().toUtc().toIso8601String(),
        }).toList();

        await connection.users.query(
          r'UPDATE type::record("user", $ownerId) SET company_slug = $next_slugs, company_membership_ids = $comp_ids, company_memberships = $memberships',
          {
            'ownerId': comp.ownerId,
            'next_slugs': otherSlugs,
            'comp_ids': otherCompanies.map((c) => c.id).toList(),
            'memberships': otherMemberships,
          },
        );
      } else {
        await connection.users.query(
          r'UPDATE type::record("user", $ownerId) SET role = IF role = "admin" OR role = "super_admin" THEN role ELSE "customer" END, company_slug = none, company_membership_ids = [], company_memberships = []',
          {
            'ownerId': comp.ownerId,
          },
        );
      }
    }

    await connection.companies.use('companies', 'registry');
    await connection.companies.delete('company:$id');
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
    final rawData = category.toJson()
      ..remove('id')
      ..['created_at'] = DateTime.now().toUtc().toIso8601String()
      ..['updated_at'] = DateTime.now().toUtc().toIso8601String();

    final data = jsonDecode(jsonEncode(rawData)) as Map<String, dynamic>;
    final cleanedData = _removeNullsFromMap(data);
    final result = await connection.companies.create('category', cleanedData);
    return Category.fromJson(_normalizeRecord(result));
  }

  @override
  Future<Category> updateCategory(Category category) async {
    await connection.companies.use('companies', 'discovery');
    final rawData = category.toJson()
      ..remove('id')
      ..['updated_at'] = DateTime.now().toUtc().toIso8601String();

    final data = jsonDecode(jsonEncode(rawData)) as Map<String, dynamic>;
    final cleanedData = _removeNullsFromMap(data);
    
    final result = await connection.companies.query(
      r'UPDATE type::record("category", $id) MERGE $data',
      {
        'id': category.id,
        'data': cleanedData,
      },
    );
    
    final list = _parseList<Category>(result, Category.fromJson);
    if (list.isEmpty) {
      throw Exception('Failed to update category: record not found');
    }
    return list.first;
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
    if (record is List) {
      if (record.isEmpty) return <String, dynamic>{};
      record = record.first;
    }
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

  /// Recursively removes keys with null values and filters out empty maps.
  Map<String, dynamic> _removeNullsFromMap(Map<String, dynamic> map) {
    final copy = <String, dynamic>{};
    map.forEach((key, value) {
      if (value != null) {
        if (value is Map<String, dynamic>) {
          final cleaned = _removeNullsFromMap(value);
          if (cleaned.isNotEmpty) {
            copy[key] = cleaned;
          }
        } else if (value is Map) {
          final cleaned = _removeNullsFromMap(Map<String, dynamic>.from(value));
          if (cleaned.isNotEmpty) {
            copy[key] = cleaned;
          }
        } else if (value is List) {
          final cleaned = _removeNullsFromList(value);
          if (cleaned.isNotEmpty) {
            copy[key] = cleaned;
          }
        } else {
          copy[key] = value;
        }
      }
    });
    return copy;
  }

  /// Recursively removes keys with null values from elements in a list.
  List<dynamic> _removeNullsFromList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return _removeNullsFromMap(item);
      } else if (item is Map) {
        return _removeNullsFromMap(Map<String, dynamic>.from(item));
      } else if (item is List) {
        return _removeNullsFromList(item);
      }
      return item;
    }).toList();
  }
}
