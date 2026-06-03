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
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);

  // Companies
  Future<PaginatedResponse<Company>> getCompanies({int page = 1, int pageSize = 50});
  Future<Company> createCompany(Company company);
  Future<Company> updateCompany(Company company);
  Future<void> deleteCompany(String id);

  // Categories
  Future<PaginatedResponse<Category>> getCategories({int page = 1, int pageSize = 50});
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}
