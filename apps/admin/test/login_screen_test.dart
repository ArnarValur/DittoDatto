import 'dart:async';

import 'package:ditto_admin/features/auth/login_screen.dart';
import 'package:ditto_admin/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

class FakeAuthService implements AuthService {
  @override
  Future<AuthState> login(String email, String password) async {
    return const Unauthenticated();
  }

  @override
  Future<AuthState> logout() async {
    return const Unauthenticated();
  }

  @override
  Future<AuthState> tryRestore() async {
    return const Unauthenticated();
  }
}

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('Renders all required Login components', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(FakeAuthService()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Let the AsyncNotifier build() complete.
      await tester.pumpAndSettle();

      // Verify Lock Icon exists
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);

      // Verify Email and Password fields exist
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Verify Sign In button exists
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('Shows validation error on empty fields', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(FakeAuthService()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Click Sign In without entering any credentials
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Form validation should trigger and display 'Required' errors
      expect(find.text('Required'), findsNWidgets(2));
    });

    testWidgets('Displays loading indicator when authenticating', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Directly set the provider value to loading state.
            authProvider.overrideWith(() => _AlwaysLoadingNotifier()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // The notifier build() is pending → isLoading is true.
      // Verify loading indicator is displayed instead of 'Sign In' text.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign In'), findsNothing);
    });
  });
}

/// Notifier whose build() never completes — state stays [AsyncLoading].
class _AlwaysLoadingNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  @override
  Future<AuthState> build() {
    // A completer that never completes keeps the provider in AsyncLoading.
    return Completer<AuthState>().future;
  }

  @override
  Future<void> login(String email, String password) async {}
  @override
  Future<void> logout() async {}
}
