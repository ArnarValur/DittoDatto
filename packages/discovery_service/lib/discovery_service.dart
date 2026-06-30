/// Discovery layer for DittoDatto.
///
/// Provides read access to platform-wide discovery data (listings,
/// categories, areas) and write access for publish-sync operations.
library;

export 'src/models/discovery_area.dart';
export 'src/models/discovery_category.dart';
export 'src/models/establishment_listing.dart';
export 'src/repositories/discovery_repository.dart';
export 'src/services/listing_sync_service.dart';
