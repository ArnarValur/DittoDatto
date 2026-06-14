import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:business_portal/features/auth/auth_provider.dart';
import 'package:business_portal/features/shell/portal_shell.dart';

/// Mock auth notifier for shell tests.
class _MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  @override
  Future<AuthState> build() async => const Authenticated(
        accessToken: 'test-jwt',
        email: 'arnarvalur@dittodatto.no',
      );

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> logout() async {
    state = const AsyncData(Unauthenticated());
  }
}

Widget _buildShell({int selectedIndex = 0}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _MockAuthNotifier()),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: PortalShell(
        currentIndex: selectedIndex,
        onDestinationSelected: (_) {},
        child: const Center(child: Text('Body Content')),
      ),
    ),
  );
}

void main() {
  group('PortalShell', () {
    testWidgets('renders DittoDashboardShell with body', (tester) async {
      await tester.pumpWidget(_buildShell());
      await tester.pumpAndSettle();

      // Verify the shell renders and the body content is visible.
      expect(find.text('Body Content'), findsOneWidget);
      // Verify DittoDashboardShell is in the widget tree.
      expect(find.byType(DittoDashboardShell), findsOneWidget);
    });

    testWidgets('renders all 7 navigation labels', (tester) async {
      // Use a wide enough viewport for the sidebar to show.
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildShell());
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Establishments'), findsOneWidget);
      expect(find.text('Appointments'), findsOneWidget);
      expect(find.text('Table Reservations'), findsOneWidget);
      expect(find.text('Staff'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget);
    });

    testWidgets('renders portal header branding', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildShell());
      await tester.pumpAndSettle();

      // Verify the portal branding text is visible.
      expect(find.text('Business Portal'), findsOneWidget);
    });

    testWidgets('renders user email in footer', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildShell());
      await tester.pumpAndSettle();

      // Should display the username portion of the email.
      expect(find.text('arnarvalur'), findsOneWidget);
    });

    testWidgets('renders logout button', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildShell());
      await tester.pumpAndSettle();

      // Verify logout button is present.
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });
  });
}
