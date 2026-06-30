/// Service group model — groups related services for display.
///
/// Maps to the `service_group` SCHEMAFULL table in `company-blueprint.surql`.
/// Used by both EstablishmentPage (grouped display) and BP CRUD.
class ServiceGroup {
  const ServiceGroup({
    required this.id,
    required this.name,
    this.description,
    this.sortOrder = 0,
    this.showOnBookingPanel = true,
    this.multiSelect = false,
    this.isFeatured = false,
  });

  /// SurrealDB record ID (e.g. `service_group:abc123`).
  final String id;

  /// Group display name (e.g. "Hårklipp", "Behandlinger").
  final String name;

  /// Optional description shown below the group header.
  final String? description;

  /// Sort order for display (lower = first). Schema DEFAULT 0.
  final int sortOrder;

  /// Whether this group appears on the booking panel. Schema DEFAULT true.
  final bool showOnBookingPanel;

  /// Whether multiple services can be selected simultaneously. Schema DEFAULT false.
  final bool multiSelect;

  /// Whether this group is featured on the establishment page. Schema DEFAULT false.
  final bool isFeatured;

  /// Parse from SurrealDB JSON row.
  factory ServiceGroup.fromJson(Map<String, dynamic> json) {
    return ServiceGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      showOnBookingPanel: json['show_on_booking_panel'] as bool? ?? true,
      multiSelect: json['multi_select'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  /// Serialize to JSON for storage / transfer.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'sort_order': sortOrder,
        'show_on_booking_panel': showOnBookingPanel,
        'multi_select': multiSelect,
        'is_featured': isFeatured,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          sortOrder == other.sortOrder &&
          showOnBookingPanel == other.showOnBookingPanel &&
          multiSelect == other.multiSelect &&
          isFeatured == other.isFeatured;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        sortOrder,
        showOnBookingPanel,
        multiSelect,
        isFeatured,
      );
}
