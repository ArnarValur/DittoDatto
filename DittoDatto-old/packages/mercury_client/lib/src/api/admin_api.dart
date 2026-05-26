import '../models/auth.dart';
import '../models/category.dart';
import '../models/company.dart';
import '../models/enums.dart';
import '../models/user.dart';
import 'mercury_api.dart';

/// Admin-specific API methods — platform management endpoints.
///
/// All endpoints require ADMIN or SUPER_ADMIN role (ADR-0011).
/// These are platform-wide operations — no company slug scoping.
class AdminApi {
  const AdminApi(this._api);

  final MercuryApi _api;

  // ─── Stats ──────────────────────────────────────────────────────────

  /// GET /admin/stats — Dashboard statistics.
  Future<AdminStats> getStats() async {
    final json = await _api.get('/admin/stats');
    return AdminStats.fromJson(json as Map<String, dynamic>);
  }

  // ─── Users ──────────────────────────────────────────────────────────

  /// GET /admin/users — Paginated user list.
  Future<PaginatedResponse<User>> listUsers({
    int limit = 50,
    int offset = 0,
  }) async {
    final json = await _api.get('/admin/users', queryParams: {
      'limit': limit.toString(),
      'offset': offset.toString(),
    });
    return PaginatedResponse.fromJson(
      json as Map<String, dynamic>,
      User.fromJson,
    );
  }

  /// GET /admin/users/{id} — Single user.
  Future<User> getUser(String id) async {
    final json = await _api.get('/admin/users/$id');
    return User.fromJson(json as Map<String, dynamic>);
  }

  /// PUT /admin/users/{id}/role — Update user role.
  Future<User> updateUserRole(String id, ActorRole role) async {
    final json = await _api.put('/admin/users/$id/role', body: {
      'role': role.value,
    });
    return User.fromJson(json as Map<String, dynamic>);
  }

  // ─── Companies ──────────────────────────────────────────────────────

  /// GET /admin/companies — Paginated company list.
  Future<PaginatedResponse<Company>> listCompanies({
    int limit = 50,
    int offset = 0,
  }) async {
    final json = await _api.get('/admin/companies', queryParams: {
      'limit': limit.toString(),
      'offset': offset.toString(),
    });
    return PaginatedResponse.fromJson(
      json as Map<String, dynamic>,
      Company.fromJson,
    );
  }

  /// POST /admin/companies — Create company registry entry.
  Future<Company> createCompany(Company company) async {
    final json = await _api.post('/admin/companies', body: company.toJson());
    return Company.fromJson(json as Map<String, dynamic>);
  }

  /// PUT /admin/companies/{id} — Update company.
  Future<Company> updateCompany(String id, Company company) async {
    final json = await _api.put('/admin/companies/$id', body: company.toJson());
    return Company.fromJson(json as Map<String, dynamic>);
  }

  // ─── Categories ─────────────────────────────────────────────────────

  /// GET /admin/categories — All platform categories.
  Future<List<Category>> listCategories() async {
    final json = await _api.get('/admin/categories');
    return (json as List<dynamic>)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /admin/categories — Create category.
  Future<Category> createCategory(Category category) async {
    final json = await _api.post(
      '/admin/categories',
      body: category.toJson(),
    );
    return Category.fromJson(json as Map<String, dynamic>);
  }

  /// PUT /admin/categories/{id} — Update category.
  Future<Category> updateCategory(String id, Category category) async {
    final json = await _api.put(
      '/admin/categories/$id',
      body: category.toJson(),
    );
    return Category.fromJson(json as Map<String, dynamic>);
  }

  /// DELETE /admin/categories/{id} — Hard delete category.
  Future<void> deleteCategory(String id) async {
    await _api.delete('/admin/categories/$id');
  }
}
