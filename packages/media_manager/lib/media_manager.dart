/// DittoDatto shared media management package.
///
/// Provides media CRUD, gallery display, inline picker widgets,
/// and an abstract storage backend for swappable object stores.
///
/// ## Usage
///
/// ```dart
/// import 'package:media_manager/media_manager.dart';
/// ```
library;

// Models
export 'src/models/media_item.dart';
export 'src/models/media_category.dart';

// Storage
export 'src/storage/media_storage_backend.dart';
export 'src/storage/storage_upload_result.dart';

// Repository
export 'src/repository/media_repository.dart';

// Upload orchestration
export 'src/upload/media_upload_state.dart';

// Widgets — added in Phase 2 and 3:
// export 'src/widgets/media_gallery_page.dart';
// export 'src/widgets/media_picker_widget.dart';
// export 'src/widgets/media_picker_modal.dart';
