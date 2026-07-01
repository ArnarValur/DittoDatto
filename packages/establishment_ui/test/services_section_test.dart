import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper to wrap a widget in a MaterialApp scaffold for testing.
Widget _wrap(Widget child, {double width = 400}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: width,
        child: child,
      ),
    ),
  );
}

/// Helper to wrap a sliver widget in a CustomScrollView.
Widget _wrapSliver(Widget sliver, {double width = 400}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: width,
        child: CustomScrollView(slivers: [sliver]),
      ),
    ),
  );
}

// ── Test data ──────────────────────────────────────────────────────

const _standardService = Service(
  id: 'service:svc1',
  title: 'Herreklipp',
  duration: 30,
  price: 450,
  currency: 'NOK',
  bookingMode: 'standard',
  description: 'Klassisk herreklipp med styling.',
);

const _freeService = Service(
  id: 'service:svc2',
  title: 'Gratis konsultasjon',
  duration: 15,
  price: 0,
  currency: 'NOK',
  bookingMode: 'standard',
);

const _reservationService = Service(
  id: 'service:svc3',
  title: 'Bord for 4',
  duration: 120,
  price: 199.50,
  currency: 'NOK',
  bookingMode: 'tableReservation',
  description: 'Reservasjon ved vinduet.',
);

const _ticketService = Service(
  id: 'service:svc4',
  title: 'VIP-billett',
  duration: 180,
  price: 1200,
  currency: 'NOK',
  bookingMode: 'ticketSystem',
);

const _inactiveService = Service(
  id: 'service:svc5',
  title: 'Deaktivert',
  duration: 30,
  price: 100,
  isActive: false,
);

const _ungroupedService = Service(
  id: 'service:svc6',
  title: 'Øyebryn',
  duration: 15,
  price: 200,
  groupId: null,
);

const _groupHair = ServiceGroup(
  id: 'service_group:hair',
  name: 'Hår',
  description: 'Alle hårklipp og behandlinger.',
  sortOrder: 0,
);

const _groupBeard = ServiceGroup(
  id: 'service_group:beard',
  name: 'Skjegg',
  sortOrder: 1,
);

const _groupEmpty = ServiceGroup(
  id: 'service_group:empty',
  name: 'Tom gruppe',
  sortOrder: 2,
);

void main() {
  group('ServiceCard', () {
    testWidgets('standard — shows title, price, duration', (tester) async {
      await tester.pumpWidget(_wrap(ServiceCard(service: _standardService)));

      expect(find.text('Herreklipp'), findsOneWidget);
      expect(find.text('kr 450'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
    });

    testWidgets('standard — shows description when present', (tester) async {
      await tester.pumpWidget(_wrap(ServiceCard(service: _standardService)));

      expect(find.text('Klassisk herreklipp med styling.'), findsOneWidget);
    });

    testWidgets('standard — shows Gratis for zero price', (tester) async {
      await tester.pumpWidget(_wrap(ServiceCard(service: _freeService)));

      expect(find.text('Gratis'), findsOneWidget);
      expect(find.text('15 min'), findsOneWidget);
    });

    testWidgets('tableReservation — shows price, hides duration',
        (tester) async {
      await tester
          .pumpWidget(_wrap(ServiceCard(service: _reservationService)));

      expect(find.text('Bord for 4'), findsOneWidget);
      expect(find.text('kr 199,50'), findsOneWidget);
      // Duration should NOT be shown for table reservations.
      expect(find.text('2 t'), findsNothing);
      expect(find.text('120 min'), findsNothing);
    });

    testWidgets('tableReservation — shows description', (tester) async {
      await tester
          .pumpWidget(_wrap(ServiceCard(service: _reservationService)));

      expect(find.text('Reservasjon ved vinduet.'), findsOneWidget);
    });

    testWidgets('ticketSystem — shows Billett chip', (tester) async {
      await tester.pumpWidget(_wrap(ServiceCard(service: _ticketService)));

      expect(find.text('VIP-billett'), findsOneWidget);
      expect(find.text('kr 1200'), findsOneWidget);
      expect(find.text('Billett'), findsOneWidget);
    });

    testWidgets('renders optional icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        ServiceCard(
          service: _standardService,
          icon: Icons.content_cut,
        ),
      ));

      expect(find.byIcon(Icons.content_cut), findsOneWidget);
    });

    testWidgets('omits icon when not provided', (tester) async {
      await tester.pumpWidget(_wrap(ServiceCard(service: _standardService)));

      // No arbitrary icon should appear.
      expect(find.byIcon(Icons.content_cut), findsNothing);
    });
  });

  group('ServiceGroupSection', () {
    testWidgets('renders group name and description', (tester) async {
      await tester.pumpWidget(_wrap(
        ServiceGroupSection(
          group: _groupHair,
          services: const [_standardService],
        ),
      ));

      expect(find.text('Hår'), findsOneWidget);
      expect(
        find.text('Alle hårklipp og behandlinger.'),
        findsOneWidget,
      );
    });

    testWidgets('renders all services in group', (tester) async {
      await tester.pumpWidget(_wrap(
        ServiceGroupSection(
          group: _groupHair,
          services: const [_standardService, _freeService],
        ),
      ));

      expect(find.text('Herreklipp'), findsOneWidget);
      expect(find.text('Gratis konsultasjon'), findsOneWidget);
    });

    testWidgets('hides when services list is empty', (tester) async {
      await tester.pumpWidget(_wrap(
        const ServiceGroupSection(
          group: _groupEmpty,
          services: [],
        ),
      ));

      expect(find.text('Tom gruppe'), findsNothing);
    });

    testWidgets('can collapse and expand', (tester) async {
      await tester.pumpWidget(_wrap(
        ServiceGroupSection(
          group: _groupHair,
          services: const [_standardService],
        ),
      ));

      // Initially expanded.
      expect(find.text('Herreklipp'), findsOneWidget);

      // Tap to collapse.
      await tester.tap(find.text('Hår'));
      await tester.pumpAndSettle();

      // Service card should be hidden after collapse.
      expect(find.text('kr 450'), findsNothing);

      // Tap to expand again.
      await tester.tap(find.text('Hår'));
      await tester.pumpAndSettle();

      expect(find.text('Herreklipp'), findsOneWidget);
    });
  });

  group('UngroupedServiceSection', () {
    testWidgets('renders Øvrige tjenester header', (tester) async {
      await tester.pumpWidget(_wrap(
        const UngroupedServiceSection(services: [_ungroupedService]),
      ));

      expect(find.text('Øvrige tjenester'), findsOneWidget);
      expect(find.text('Øyebryn'), findsOneWidget);
    });

    testWidgets('hides when empty', (tester) async {
      await tester.pumpWidget(_wrap(
        const UngroupedServiceSection(services: []),
      ));

      expect(find.text('Øvrige tjenester'), findsNothing);
    });
  });

  group('EstablishmentServicesSection', () {
    testWidgets('groups services by ServiceGroup, sorted by sortOrder',
        (tester) async {
      final data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        serviceGroups: const [_groupBeard, _groupHair], // beard sortOrder=1, hair=0
        services: [
          const Service(
            id: 'service:a',
            title: 'Skjeggtrimming',
            duration: 20,
            price: 200,
            groupId: 'service_group:beard',
          ),
          _standardService.copyWithGroupId('service_group:hair'),
        ],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      // Both group headers should appear.
      expect(find.text('Hår'), findsOneWidget);
      expect(find.text('Skjegg'), findsOneWidget);

      // Services rendered.
      expect(find.text('Herreklipp'), findsOneWidget);
      expect(find.text('Skjeggtrimming'), findsOneWidget);

      // Hair (sortOrder 0) should appear before Beard (sortOrder 1).
      final hairPos = tester.getTopLeft(find.text('Hår'));
      final beardPos = tester.getTopLeft(find.text('Skjegg'));
      expect(hairPos.dy, lessThan(beardPos.dy));
    });

    testWidgets('filters out inactive services', (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [_standardService, _inactiveService],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      expect(find.text('Herreklipp'), findsOneWidget);
      expect(find.text('Deaktivert'), findsNothing);
    });

    testWidgets('shows ungrouped fallback for services without group',
        (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [_ungroupedService],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      expect(find.text('Øvrige tjenester'), findsOneWidget);
      expect(find.text('Øyebryn'), findsOneWidget);
    });

    testWidgets('hides section when zero active services', (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [_inactiveService],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      // Section title should not appear.
      expect(find.text('Tjenester'), findsNothing);
    });

    testWidgets('hides section when services list is empty', (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      expect(find.text('Tjenester'), findsNothing);
    });

    testWidgets('renders section title', (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [_standardService],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      expect(find.text('Tjenester'), findsOneWidget);
    });

    testWidgets('uses custom section icon when provided', (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [_standardService],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(
          data: data,
          sectionIcon: Icons.spa,
        ),
      ));

      expect(find.byIcon(Icons.spa), findsOneWidget);
    });

    testWidgets('omits icon when not provided', (tester) async {
      const data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        services: [_standardService],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      // No icon should appear in the header.
      expect(find.byIcon(Icons.spa), findsNothing);
      expect(find.byIcon(Icons.content_cut), findsNothing);
    });

    testWidgets('skips empty groups with no matching services',
        (tester) async {
      final data = EstablishmentData(
        name: 'Test',
        establishmentType: EstablishmentType.venue,
        address: 'Test 1',
        city: 'Oslo',
        zip: '0001',
        serviceGroups: const [_groupEmpty, _groupHair],
        services: [
          _standardService.copyWithGroupId('service_group:hair'),
        ],
      );

      await tester.pumpWidget(_wrapSliver(
        EstablishmentServicesSection(data: data),
      ));

      // Group with no services should not render.
      expect(find.text('Tom gruppe'), findsNothing);
      expect(find.text('Hår'), findsOneWidget);
    });
  });
}

/// Extension to create a copy of a Service with a different groupId.
extension _ServiceCopy on Service {
  Service copyWithGroupId(String? gid) => Service(
        id: id,
        title: title,
        description: description,
        groupId: gid,
        duration: duration,
        price: price,
        currency: currency,
        bookingMode: bookingMode,
        isActive: isActive,
        coverImage: coverImage,
      );
}
