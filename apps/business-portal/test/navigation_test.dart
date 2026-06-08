import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:business_portal/features/auth/auth_provider.dart';
import 'package:business_portal/features/dashboard/dashboard_screen.dart';
import 'package:business_portal/features/establishments/establishments_screen.dart';
import 'package:business_portal/features/appointments/appointments_screen.dart';
import 'package:business_portal/features/table_reservations/table_reservations_screen.dart';
import 'package:business_portal/features/staff/staff_screen.dart';
import 'package:business_portal/features/services/services_screen.dart';
import 'package:business_portal/features/inbox/inbox_screen.dart';
import 'package:business_portal/router.dart';

/// Mock auth notifier that is always authenticated.
class _AuthenticatedNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  @override
  Future<AuthState> build() async => const Authenticated(
        accessToken: 'test-jwt',
        email: 'arnarvalur@dittodatto.no',
      );

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> logout() async {}
}

Widget _buildApp() {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _AuthenticatedNotifier()),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          theme: DittoTheme.dark,
          routerConfig: router,
        );
      },
    ),
  );
}

void main() {
  group('Placeholder screen navigation', () {
    testWidgets('initial route shows DashboardScreen', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('tapping Establishments nav shows EstablishmentsScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Establishments'));
      await tester.pumpAndSettle();

      expect(find.byType(EstablishmentsScreen), findsOneWidget);
    });

    testWidgets('tapping Appointments nav shows AppointmentsScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Appointments'));
      await tester.pumpAndSettle();

      expect(find.byType(AppointmentsScreen), findsOneWidget);
    });

    testWidgets('tapping Table Reservations nav shows TableReservationsScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Table Reservations'));
      await tester.pumpAndSettle();

      expect(find.byType(TableReservationsScreen), findsOneWidget);
    });

    testWidgets('tapping Staff nav shows StaffScreen', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Staff'));
      await tester.pumpAndSettle();

      expect(find.byType(StaffScreen), findsOneWidget);
    });

    testWidgets('tapping Services nav shows ServicesScreen', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Services'));
      await tester.pumpAndSettle();

      expect(find.byType(ServicesScreen), findsOneWidget);
    });

    testWidgets('tapping Inbox nav shows InboxScreen', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Inbox'));
      await tester.pumpAndSettle();

      expect(find.byType(InboxScreen), findsOneWidget);
    });
  });
}
