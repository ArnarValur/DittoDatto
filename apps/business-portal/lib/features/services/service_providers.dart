import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import 'service_group_repository.dart';
import 'service_repository.dart';

// ── Service Groups ─────────────────────────────────────────────────────

/// Provides all service groups for the current tenant, sorted by sort_order.
final serviceGroupsProvider =
    AsyncNotifierProvider<ServiceGroupsNotifier, List<ServiceGroup>>(
  ServiceGroupsNotifier.new,
);

/// Manages service groups with CRUD operations.
class ServiceGroupsNotifier extends AsyncNotifier<List<ServiceGroup>> {
  @override
  Future<List<ServiceGroup>> build() async {
    ref.watch(tenantConnectionProvider);
    return _fetchAll();
  }

  ServiceGroupRepository? get _repo {
    final db = ref.read(tenantConnectionProvider);
    if (db == null) return null;
    return ServiceGroupRepository(db.companies.query);
  }

  Future<List<ServiceGroup>> _fetchAll() async {
    final repo = _repo;
    if (repo == null) return [];
    return repo.fetchAll();
  }

  /// Create a new service group.
  Future<void> create({
    required String establishmentId,
    required String name,
    String? description,
    int sortOrder = 0,
    bool showOnBookingPanel = true,
    bool multiSelect = false,
  }) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.create(
      establishmentId: establishmentId,
      name: name,
      description: description,
      sortOrder: sortOrder,
      showOnBookingPanel: showOnBookingPanel,
      multiSelect: multiSelect,
    );
    state = AsyncData(await _fetchAll());
  }

  /// Update an existing service group.
  Future<void> updateGroup(ServiceGroup group) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.update(group);
    state = AsyncData(await _fetchAll());
  }

  /// Delete a service group.
  Future<void> delete(String id) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.delete(id);
    state = AsyncData(await _fetchAll());
  }
}

// ── Services ───────────────────────────────────────────────────────────

/// Provides all services for the current tenant, sorted by title.
final servicesProvider =
    AsyncNotifierProvider<ServicesNotifier, List<Service>>(
  ServicesNotifier.new,
);

/// Manages services with CRUD operations.
class ServicesNotifier extends AsyncNotifier<List<Service>> {
  @override
  Future<List<Service>> build() async {
    ref.watch(tenantConnectionProvider);
    return _fetchAll();
  }

  ServiceRepository? get _repo {
    final db = ref.read(tenantConnectionProvider);
    if (db == null) return null;
    return ServiceRepository(db.companies.query);
  }

  Future<List<Service>> _fetchAll() async {
    final repo = _repo;
    if (repo == null) return [];
    return repo.fetchAll();
  }

  /// Create a new service.
  Future<void> create({
    required String establishmentId,
    required String title,
    required int duration,
    required double price,
    String? description,
    String? groupId,
    String currency = 'NOK',
    String bookingMode = 'standard',
    bool isActive = true,
  }) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.create(
      establishmentId: establishmentId,
      title: title,
      duration: duration,
      price: price,
      description: description,
      groupId: groupId,
      currency: currency,
      bookingMode: bookingMode,
      isActive: isActive,
    );
    state = AsyncData(await _fetchAll());
  }

  /// Update an existing service.
  Future<void> updateService(Service service) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.update(service);
    state = AsyncData(await _fetchAll());
  }

  /// Delete a service.
  Future<void> delete(String id) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.delete(id);
    state = AsyncData(await _fetchAll());
  }
}
