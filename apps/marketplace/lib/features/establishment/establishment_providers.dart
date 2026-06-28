import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'establishment_debug_service.dart';

/// Debug provider — fetches real establishment data from the Hub.
///
/// `autoDispose` ensures the WebSocket closes when the user navigates
/// away from the establishment screen. Re-entering the screen triggers
/// a fresh fetch — so BP edits show up immediately.
///
/// Invalidate to force re-fetch: `ref.invalidate(establishmentDebugProvider)`.
///
/// Temporary. Will be replaced by the discovery layer provider.
final establishmentDebugProvider =
    FutureProvider.autoDispose<EstablishmentData>((ref) {
  final service = EstablishmentDebugService();
  ref.onDispose(service.dispose);
  return service.fetch();
});
