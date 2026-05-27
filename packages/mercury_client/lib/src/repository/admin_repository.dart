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
  Future<PaginatedResponse<User>> getUsers({int page = 1, int pageSize = 50});
  Future<void> updateUserRole(String userId, ActorRole newRole);

  // Companies
  Future<PaginatedResponse<Company>> getCompanies({int page = 1, int pageSize = 50});
  Future<Company> createCompany(Company company);
  Future<Company> updateCompany(Company company);

  // Categories
  Future<PaginatedResponse<Category>> getCategories({int page = 1, int pageSize = 50});
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}

/// Mock implementation with realistic Norwegian fake data.
class MockAdminRepository implements AdminRepository {
  MockAdminRepository({
    this.latency = const Duration(milliseconds: 600),
  }) {
    _initFakeData();
  }

  final Duration latency;

  final List<User> _users = [];
  final List<Company> _companies = [];
  final List<Category> _categories = [];

  void _initFakeData() {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));

    // Norwegian users
    _users.addAll([
      User(id: 'u001', name: 'Arnar Valur', email: 'arnar@dittodatto.no', phone: '+47 900 12 345', role: ActorRole.superAdmin, createdAt: monthAgo, updatedAt: now),
      User(id: 'u002', name: 'Höddi Jónsson', email: 'hoddi@dittodatto.no', phone: '+47 900 23 456', role: ActorRole.admin, createdAt: monthAgo, updatedAt: now),
      User(id: 'u003', name: 'Ingrid Pedersen', email: 'ingrid@frisorsalongen.no', phone: '+47 901 34 567', role: ActorRole.business, companySlug: 'frisorsalongen', createdAt: monthAgo, updatedAt: now),
      User(id: 'u004', name: 'Ole Hansen', email: 'ole@drammen-treningssenter.no', phone: '+47 902 45 678', role: ActorRole.business, companySlug: 'drammen-treningssenter', createdAt: monthAgo, updatedAt: now),
      User(id: 'u005', name: 'Kari Nordström', email: 'kari@hotell-nordre.no', role: ActorRole.business, companySlug: 'hotell-nordre', createdAt: monthAgo, updatedAt: now),
      User(id: 'u006', name: 'Lars Berge', email: 'lars@berge-bygg.no', phone: '+47 903 56 789', role: ActorRole.business, companySlug: 'berge-bygg', createdAt: monthAgo, updatedAt: now),
      User(id: 'u007', name: 'Marte Eriksen', email: 'marte.eriksen@gmail.com', role: ActorRole.customer, createdAt: monthAgo, updatedAt: now),
      User(id: 'u008', name: 'Erik Svendsen', email: 'erik.s@outlook.com', phone: '+47 904 67 890', role: ActorRole.customer, createdAt: monthAgo, updatedAt: now),
      User(id: 'u009', name: 'Sofie Andersen', email: 'sofie.a@proton.me', role: ActorRole.customer, createdAt: monthAgo, updatedAt: now),
      User(id: 'u010', name: 'Jonas Lie', email: 'jonas.lie@drammen.kommune.no', phone: '+47 905 78 901', role: ActorRole.customer, createdAt: monthAgo, updatedAt: now),
    ]);

    // Drammen-area companies
    _companies.addAll([
      Company(id: 'c001', name: 'Frisørsalongen', slug: 'frisorsalongen', description: 'Premium frisørsalong i Drammen sentrum', email: 'post@frisorsalongen.no', phone: '+47 32 83 00 00', address: 'Nedre Storgate 12', city: 'Drammen', postalCode: '3015', tier: CompanyTier.premium, onboardingStatus: OnboardingStatus.completed, ownerEmail: 'ingrid@frisorsalongen.no', createdAt: monthAgo, updatedAt: now),
      Company(id: 'c002', name: 'Drammen Treningssenter', slug: 'drammen-treningssenter', description: 'Moderne treningssenter med personlig trener', email: 'post@drammen-treningssenter.no', address: 'Grønland 56', city: 'Drammen', postalCode: '3045', tier: CompanyTier.premium, onboardingStatus: OnboardingStatus.completed, ownerEmail: 'ole@drammen-treningssenter.no', createdAt: monthAgo, updatedAt: now),
      Company(id: 'c003', name: 'Hotell Nordre', slug: 'hotell-nordre', description: 'Historisk hotell ved Drammenselva', email: 'resepsjon@hotell-nordre.no', phone: '+47 32 26 00 00', address: 'Bragernes Torg 1', city: 'Drammen', postalCode: '3017', tier: CompanyTier.enterprise, onboardingStatus: OnboardingStatus.completed, ownerEmail: 'kari@hotell-nordre.no', createdAt: monthAgo, updatedAt: now),
      Company(id: 'c004', name: 'Berge Bygg AS', slug: 'berge-bygg', description: 'Byggmester og renovering', email: 'post@berge-bygg.no', phone: '+47 32 89 00 00', address: 'Industriveien 8', city: 'Lier', postalCode: '3400', tier: CompanyTier.free, onboardingStatus: OnboardingStatus.inProgress, ownerEmail: 'lars@berge-bygg.no', createdAt: monthAgo, updatedAt: now),
      Company(id: 'c005', name: 'Café Elvebris', slug: 'cafe-elvebris', description: 'Koselig kafé med utsikt over Drammenselva', email: 'hei@elvebris.no', address: 'Elvegata 3', city: 'Drammen', postalCode: '3015', tier: CompanyTier.free, onboardingStatus: OnboardingStatus.notStarted, createdAt: monthAgo, updatedAt: now),
    ]);

    // Service categories
    _categories.addAll([
      Category(id: 'cat001', name: 'Frisør', slug: 'frisor', description: 'Frisørsalonger og barberere', icon: '💇', count: 23, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat002', name: 'Restaurant', slug: 'restaurant', description: 'Restauranter og kafeer', icon: '🍽️', count: 45, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat003', name: 'Trening', slug: 'trening', description: 'Treningssentre og PT', icon: '🏋️', count: 12, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat004', name: 'Hotell', slug: 'hotell', description: 'Hotell og overnatting', icon: '🏨', count: 8, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat005', name: 'Helse', slug: 'helse', description: 'Leger, tannleger og helsepersonell', icon: '⚕️', count: 31, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat006', name: 'Verksted', slug: 'verksted', description: 'Bilverksted og reparasjon', icon: '🔧', count: 15, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat007', name: 'Skjønnhet', slug: 'skjonnhet', description: 'Skjønnhetssalonger og spa', icon: '💆', count: 19, createdAt: monthAgo, updatedAt: now),
      Category(id: 'cat008', name: 'Rengjøring', slug: 'rengjoring', description: 'Rengjøringstjenester', icon: '🧹', count: 7, createdAt: monthAgo, updatedAt: now),
    ]);
  }

  @override
  Future<AdminStats> getStats() async {
    await Future<void>.delayed(latency);
    return AdminStats(
      userCount: _users.length,
      companyCount: _companies.length,
      categoryCount: _categories.length,
      engineHealthy: true,
    );
  }

  // ── Users ──

  @override
  Future<PaginatedResponse<User>> getUsers({int page = 1, int pageSize = 50}) async {
    await Future<void>.delayed(latency);
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, _users.length);
    return PaginatedResponse(
      items: _users.sublist(start, end),
      total: _users.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<void> updateUserRole(String userId, ActorRole newRole) async {
    await Future<void>.delayed(latency);
    final index = _users.indexWhere((u) => u.id == userId);
    if (index >= 0) {
      _users[index] = _users[index].copyWith(role: newRole);
    }
  }

  // ── Companies ──

  @override
  Future<PaginatedResponse<Company>> getCompanies({int page = 1, int pageSize = 50}) async {
    await Future<void>.delayed(latency);
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, _companies.length);
    return PaginatedResponse(
      items: _companies.sublist(start, end),
      total: _companies.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Company> createCompany(Company company) async {
    await Future<void>.delayed(latency);
    _companies.add(company);
    return company;
  }

  @override
  Future<Company> updateCompany(Company company) async {
    await Future<void>.delayed(latency);
    final index = _companies.indexWhere((c) => c.id == company.id);
    if (index >= 0) {
      _companies[index] = company;
    }
    return company;
  }

  // ── Categories ──

  @override
  Future<PaginatedResponse<Category>> getCategories({int page = 1, int pageSize = 50}) async {
    await Future<void>.delayed(latency);
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, _categories.length);
    return PaginatedResponse(
      items: _categories.sublist(start, end),
      total: _categories.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Category> createCategory(Category category) async {
    await Future<void>.delayed(latency);
    _categories.add(category);
    return category;
  }

  @override
  Future<Category> updateCategory(Category category) async {
    await Future<void>.delayed(latency);
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
    }
    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    await Future<void>.delayed(latency);
    _categories.removeWhere((c) => c.id == id);
  }
}
