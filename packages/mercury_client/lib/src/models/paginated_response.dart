/// Generic paginated response wrapper.
///
/// Use with a typed factory:
/// ```dart
/// PaginatedResponse.fromJson(json, User.fromJson)
/// ```
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  /// Parse from JSON using a typed factory for [T].
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  /// Total number of pages based on [total] and [pageSize].
  int get totalPages => (total / pageSize).ceil();

  /// Whether there is a next page available.
  bool get hasNextPage => page < totalPages;

  /// Whether there is a previous page available.
  bool get hasPreviousPage => page > 1;
}
