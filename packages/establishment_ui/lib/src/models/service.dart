/// Service model — a bookable offering within an establishment.
///
/// Maps to the `service` SCHEMAFULL table in `company-blueprint.surql`.
/// Used by EstablishmentPage (service cards) and BP CRUD.
class Service {
  const Service({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    this.description,
    this.groupId,
    this.currency = 'NOK',
    this.bookingMode = 'standard',
    this.isActive = true,
    this.coverImage,
  });

  /// SurrealDB record ID (e.g. `service:svc1`).
  final String id;

  /// Service display title.
  final String title;

  /// Optional description text.
  final String? description;

  /// Record ID of the parent [ServiceGroup], or null if ungrouped.
  /// Schema: `option<record<service_group>>`.
  final String? groupId;

  /// Duration in minutes. Schema: `int`.
  final int duration;

  /// Price as a number. Schema: `number` (SurrealDB number → Dart double).
  final double price;

  /// Currency code. Schema DEFAULT 'NOK'.
  final String currency;

  /// Booking mode: 'standard', 'tableReservation', or 'ticketSystem'.
  /// Schema DEFAULT 'standard'.
  final String bookingMode;

  /// Whether this service is currently active/visible. Schema DEFAULT true.
  final bool isActive;

  /// Optional cover image URL. Schema: `option<string>`.
  final String? coverImage;

  /// Parse from SurrealDB JSON row.
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      groupId: json['group'] as String?,
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'NOK',
      bookingMode: json['booking_mode'] as String? ?? 'standard',
      isActive: json['is_active'] as bool? ?? true,
      coverImage: json['cover_image'] as String?,
    );
  }

  /// Serialize to JSON for storage / transfer.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        if (description != null) 'description': description,
        if (groupId != null) 'group': groupId,
        'duration': duration,
        'price': price,
        'currency': currency,
        'booking_mode': bookingMode,
        'is_active': isActive,
        if (coverImage != null) 'cover_image': coverImage,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          groupId == other.groupId &&
          duration == other.duration &&
          price == other.price &&
          currency == other.currency &&
          bookingMode == other.bookingMode &&
          isActive == other.isActive &&
          coverImage == other.coverImage;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        groupId,
        duration,
        price,
        currency,
        bookingMode,
        isActive,
        coverImage,
      );
}
