import '../models/admin_stats.dart';
import '../models/category.dart';
import '../models/company.dart';
import '../models/enums.dart';
import '../models/paginated_response.dart';
import '../models/user.dart';

/// Repository interface for admin data operations.
///
/// Implementations can be mock (development) or HTTP (production).
abstract class AdminRepository {
  Future<AdminStats> getStats();

  // Users
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int pageSize = 50,
  });
  Future<void> updateUserRole(String userId, ActorRole newRole);
  Future<User> createUser(User user, {String? password});
  Future<User> updateUser(User user, {String? password});
  Future<void> deleteUser(String id);

  // Companies
  Future<PaginatedResponse<Company>> getCompanies({int page = 1, int pageSize = 50});
  Future<Company> createCompany(Company company);
  Future<Company> updateCompany(Company company);
  Future<void> deleteCompany(String id);

  // Company Provisioning
  /// Provisions a company's tenant database: creates the DB, applies the
  /// blueprint schema, and creates the bp_portal service user.
  ///
  /// [slug] is the company slug (e.g. 'my-company').
  /// [blueprintSql] is the full content of company-blueprint.surql.
  /// [bpPortalPassword] is the password for the bp_portal DB-level user.
  Future<void> provisionCompanyDatabase({
    required String slug,
    required String blueprintSql,
    required String bpPortalPassword,
  });

  /// Checks whether a company's tenant database has been provisioned.
  Future<bool> isCompanyProvisioned(String slug);

  /// Removes a company's tenant database (for cleanup/testing).
  Future<void> deprovisionCompanyDatabase(String slug);

  // Categories
  Future<PaginatedResponse<Category>> getCategories({int page = 1, int pageSize = 50});
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}

