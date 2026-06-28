/// Shared establishment page UI components for DittoDatto.
///
/// Provides the [EstablishmentPage] widget and its sub-components,
/// consumed by Business Portal (preview mode) and Public Marketplace
/// (customer-facing page). Uses [ditto_design] tokens for consistent
/// styling across apps.
library;

// Models
export 'src/models/establishment_data.dart';
export 'src/models/norwegian_address.dart';

// Page
export 'src/establishment_page.dart';

// Sections
export 'src/sections/establishment_gallery_section.dart';
export 'src/sections/establishment_info_bar.dart';
export 'src/sections/establishment_about_grid.dart';
export 'src/sections/establishment_contact_section.dart';
export 'src/sections/establishment_action_buttons.dart';

export 'src/sections/establishment_services_section.dart';
export 'src/sections/establishment_events_section.dart';
export 'src/sections/establishment_map_section.dart';

// Services
export 'src/services/kartverket_service.dart';
export 'src/services/nominatim_service.dart';
