/// Reservation configuration for restaurant-type Establishments.
///
/// Maps to the SurrealDB `reservation_config` embedded object (10 subfields).
/// Only shown in BP when `establishmentType == restaurant` (ADR-0027).
///
/// See ADR-0029 for `large_party_handling` enum values.
class ReservationConfig {
  const ReservationConfig({
    this.maxGuests = 8,
    this.largePartyHandling = 'notify',
    this.largePartyContact,
    this.defaultDuration = 90,
    this.slotInterval = 30,
    this.bufferBetweenSlots = 0,
    this.capacityMode = 'pool',
    this.totalCapacity,
    this.autoConfirm = true,
  });

  /// Maximum guests per reservation before large-party handling triggers.
  /// Default: 8.
  final int maxGuests;

  /// How to handle over-max-guests bookings.
  /// Values: `notify` (default), `email`, `call`, `form`, `disabled`.
  /// See ADR-0029.
  final String largePartyHandling;

  /// Contact info shown for `email`/`call` large-party handling.
  /// Only relevant when `largePartyHandling` is not `disabled`.
  final String? largePartyContact;

  /// Default reservation duration in minutes. Default: 90.
  final int defaultDuration;

  /// Slot grid interval in minutes. Default: 30.
  final int slotInterval;

  /// Buffer between slots in minutes. Default: 0.
  final int bufferBetweenSlots;

  /// Capacity tracking mode: `pool`, `tables`, `hybrid`. Default: `pool`.
  final String capacityMode;

  /// Total capacity (seats/covers). Only relevant when `capacityMode != pool`.
  final int? totalCapacity;

  /// Whether to auto-confirm reservations. Default: true.
  final bool autoConfirm;

  /// Valid values for [largePartyHandling].
  static const largePartyHandlingValues = [
    'notify',
    'email',
    'call',
    'form',
    'disabled',
  ];

  /// Norwegian labels for large party handling values.
  static const largePartyHandlingLabels = {
    'notify': 'Varsle eier (tillat booking)',
    'email': 'Vis e-post',
    'call': 'Vis telefonnummer',
    'form': 'Vis forespørselsskjema',
    'disabled': 'Avslå store selskaper',
  };

  /// Valid values for [capacityMode].
  static const capacityModeValues = ['pool', 'tables', 'hybrid'];

  /// Norwegian labels for capacity mode values.
  static const capacityModeLabels = {
    'pool': 'Samlet kapasitet',
    'tables': 'Bordbasert',
    'hybrid': 'Hybrid',
  };

  /// Parse from SurrealDB JSON.
  factory ReservationConfig.fromJson(Map<String, dynamic> json) {
    return ReservationConfig(
      maxGuests: json['max_guests'] as int? ?? 8,
      largePartyHandling:
          json['large_party_handling'] as String? ?? 'notify',
      largePartyContact: json['large_party_contact'] as String?,
      defaultDuration: json['default_duration'] as int? ?? 90,
      slotInterval: json['slot_interval'] as int? ?? 30,
      bufferBetweenSlots: json['buffer_between_slots'] as int? ?? 0,
      capacityMode: json['capacity_mode'] as String? ?? 'pool',
      totalCapacity: json['total_capacity'] as int?,
      autoConfirm: json['auto_confirm'] as bool? ?? true,
    );
  }

  /// Serialize to JSON for SurrealDB.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'max_guests': maxGuests,
      'large_party_handling': largePartyHandling,
      'default_duration': defaultDuration,
      'slot_interval': slotInterval,
      'buffer_between_slots': bufferBetweenSlots,
      'capacity_mode': capacityMode,
      'auto_confirm': autoConfirm,
    };
    if (largePartyContact != null) {
      json['large_party_contact'] = largePartyContact;
    }
    if (totalCapacity != null) json['total_capacity'] = totalCapacity;
    return json;
  }

  /// Create a copy with overrides.
  ReservationConfig copyWith({
    int? maxGuests,
    String? largePartyHandling,
    String? Function()? largePartyContact,
    int? defaultDuration,
    int? slotInterval,
    int? bufferBetweenSlots,
    String? capacityMode,
    int? Function()? totalCapacity,
    bool? autoConfirm,
  }) {
    return ReservationConfig(
      maxGuests: maxGuests ?? this.maxGuests,
      largePartyHandling: largePartyHandling ?? this.largePartyHandling,
      largePartyContact: largePartyContact != null
          ? largePartyContact()
          : this.largePartyContact,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      slotInterval: slotInterval ?? this.slotInterval,
      bufferBetweenSlots: bufferBetweenSlots ?? this.bufferBetweenSlots,
      capacityMode: capacityMode ?? this.capacityMode,
      totalCapacity:
          totalCapacity != null ? totalCapacity() : this.totalCapacity,
      autoConfirm: autoConfirm ?? this.autoConfirm,
    );
  }

  /// Default reservation config with all schema defaults.
  static const defaults = ReservationConfig();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationConfig &&
          maxGuests == other.maxGuests &&
          largePartyHandling == other.largePartyHandling &&
          largePartyContact == other.largePartyContact &&
          defaultDuration == other.defaultDuration &&
          slotInterval == other.slotInterval &&
          bufferBetweenSlots == other.bufferBetweenSlots &&
          capacityMode == other.capacityMode &&
          totalCapacity == other.totalCapacity &&
          autoConfirm == other.autoConfirm;

  @override
  int get hashCode => Object.hash(
        maxGuests,
        largePartyHandling,
        largePartyContact,
        defaultDuration,
        slotInterval,
        bufferBetweenSlots,
        capacityMode,
        totalCapacity,
        autoConfirm,
      );
}
