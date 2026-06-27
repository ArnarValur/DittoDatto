import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marketplace/core/auth_provider.dart';
import 'package:marketplace/features/profile/profile_screen.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:ditto_design/ditto_design.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class _AuthenticatedAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  @override
  Future<AuthState> build() async => const Authenticated(
        accessToken: 'test-jwt',
        email: 'test@example.com',
        name: 'Test User',
      );

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> signup(String name, String email, String password) async {}

  @override
  Future<void> logout() async {
    state = const AsyncData(Unauthenticated());
  }
}

class _LoadingAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  final _completer = Completer<AuthState>();

  @override
  Future<AuthState> build() => _completer.future;

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> signup(String name, String email, String password) async {}

  @override
  Future<void> logout() async {}
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Widget _buildProfileScreen(AsyncNotifier<AuthState> notifier) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => notifier as AuthNotifier),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      // ProfileScreen builds its own Scaffold.
      home: const ProfileScreen(),
    ),
  );
}

void _setPhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 1920);
  tester.view.devicePixelRatio = 1.0;
}

void _resetSize(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nb_NO');
  });

  group('ProfileScreen — authenticated', () {
    testWidgets('shows greeting Hei, Test 👋', (tester) async {
      _setPhoneSize(tester);
      addTearDown(() => _resetSize(tester));

      await tester
          .pumpWidget(_buildProfileScreen(_AuthenticatedAuthNotifier()));
      await tester.pumpAndSettle();

      expect(find.text('Hei, Test 👋'), findsOneWidget);
    });

    testWidgets('shows email', (tester) async {
      _setPhoneSize(tester);
      addTearDown(() => _resetSize(tester));

      await tester
          .pumpWidget(_buildProfileScreen(_AuthenticatedAuthNotifier()));
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('shows initials TU in avatar', (tester) async {
      _setPhoneSize(tester);
      addTearDown(() => _resetSize(tester));

      await tester
          .pumpWidget(_buildProfileScreen(_AuthenticatedAuthNotifier()));
      await tester.pumpAndSettle();

      expect(find.text('TU'), findsOneWidget);
    });

    testWidgets('shows Logg ut button', (tester) async {
      _setPhoneSize(tester);
      addTearDown(() => _resetSize(tester));

      await tester
          .pumpWidget(_buildProfileScreen(_AuthenticatedAuthNotifier()));
      await tester.pumpAndSettle();

      expect(find.text('Logg ut'), findsOneWidget);
    });

    testWidgets('shows Profil in AppBar', (tester) async {
      _setPhoneSize(tester);
      addTearDown(() => _resetSize(tester));

      await tester
          .pumpWidget(_buildProfileScreen(_AuthenticatedAuthNotifier()));
      await tester.pumpAndSettle();

      expect(find.text('Profil'), findsOneWidget);
    });
  });

  group('ProfileScreen — loading', () {
    testWidgets('shows CircularProgressIndicator', (tester) async {
      _setPhoneSize(tester);
      addTearDown(() => _resetSize(tester));

      await tester.pumpWidget(_buildProfileScreen(_LoadingAuthNotifier()));
      // Single pump — Riverpod is still loading (Completer never completes).
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
