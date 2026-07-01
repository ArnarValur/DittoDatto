import 'package:booking_ui/booking_ui.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/auth_provider.dart';

/// MercuryEngine API base URL, injected at build time.
const _mercuryUrl = String.fromEnvironment(
  'MERCURY_URL',
  defaultValue: 'http://dittodatto:8005',
);

/// Full-screen booking flow for the Marketplace.
///
/// Receives [EstablishmentData] via GoRouter extra. Renders the
/// [BookingFlowPage] from `booking_ui` package with real ME API
/// callbacks for availability and booking operations.
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({
    super.key,
    required this.data,
    required this.companySlug,
  });

  final EstablishmentData data;
  final String companySlug;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  MercuryApi? _api;
  BookingRepository? _repo;

  @override
  void initState() {
    super.initState();
    _initApi();
  }

  Future<void> _initApi() async {
    final auth = ref.read(dittoAuthProvider);
    final token = await auth.getConsumerToken();

    if (token != null && mounted) {
      setState(() {
        _api = MercuryApi(baseUrl: _mercuryUrl)..accessToken = token;
        _repo = BookingRepository(_api!);
      });
    }
  }

  @override
  void dispose() {
    _api?.close();
    super.dispose();
  }

  /// Fetch real availability from MercuryEngine API.
  Future<List<MockTimeSlot>> _fetchSlots(
    DateTime date,
    List<String> serviceIds,
    String? staffId,
  ) async {
    final repo = _repo;
    if (repo == null) {
      // Fallback to mock if API not initialized.
      return MockTimeSlot.generateForDate(date);
    }

    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final companySlug = widget.companySlug;

    final slots = await repo.getAvailability(
      companySlug: companySlug,
      serviceIds: serviceIds,
      date: dateStr,
      staffId: staffId,
    );

    // Convert ME TimeSlot → booking_ui MockTimeSlot
    // (the mock type is reused as the UI contract for now).
    return slots
        .where((s) => s.available)
        .map((s) {
      final hour = int.tryParse(s.time.split(':').first) ?? 0;
      final period = hour < 12 ? 'morning' : 'afternoon';
      return MockTimeSlot(time: s.time, period: period);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BookingFlowPage(
      establishmentData: widget.data,
      onClose: () => context.pop(),
      onFetchSlots: _fetchSlots,
    );
  }
}
