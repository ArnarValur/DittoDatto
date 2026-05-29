import 'package:ditto_admin/features/auth/login_screen.dart';
import 'package:ditto_admin/features/auth/auth_provider.dart';
import 'package:ditto_design/ditto_design.dart';
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

      // Click Sign In without entering any credentials
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Form validation should trigger and display 'Required' errors
      expect(find.text('Required'), findsNWidgets(2));
    });

    testWidgets('Displays loading indicator when authenticating', (tester) async {
      // Overriding authProvider to state AuthLoading
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => MockAuthLoadingNotifier()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify loading indicator is displayed instead of 'Sign In' text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign In'), findsNothing);
    });
  });
}

class MockAuthLoadingNotifier extends Notifier<AuthState> implements AuthNotifier {
  @override
  AuthState build() => const AuthLoading();

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> logout() async {}
}
