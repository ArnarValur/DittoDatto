/// Represents a staff member available for booking.
///
/// Mock data for now — will be backed by a real `staff` table
/// when BP staff CRUD is built.
class MockStaff {
  const MockStaff({
    required this.id,
    required this.name,
    required this.title,
    this.avatarUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  final String id;
  final String name;
  final String title;
  final String? avatarUrl;
  final double rating;
  final int reviewCount;

  /// Predefined mock staff for House of the North demo.
  static const List<MockStaff> demoStaff = [
    MockStaff(
      id: 'staff:lars',
      name: 'Lars Jensen',
      title: 'Master Barber',
      rating: 4.9,
      reviewCount: 120,
    ),
    MockStaff(
      id: 'staff:elena',
      name: 'Elena Rodriguez',
      title: 'Senior Stylist',
      rating: 4.8,
      reviewCount: 85,
    ),
    MockStaff(
      id: 'staff:james',
      name: 'James Doe',
      title: 'Barber',
      rating: 4.5,
      reviewCount: 42,
    ),
  ];
}
