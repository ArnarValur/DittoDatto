import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_client/mercury_client.dart';

import 'package:business_portal/features/auth/auth_provider.dart';
import 'package:business_portal/features/auth/login_screen.dart';

/// Mock auth notifier for login screen tests.
class _MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  AuthState _currentState = const Unauthenticated();
  String? lastEmail;
  String? lastPassword;
  int loginCallCount = 0;

  @override
  Future<AuthState> build() async => _currentState;

  @override
  Future<void> login(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    loginCallCount++;
    state = const AsyncLoading();
    _currentState = Authenticated(accessToken: 'test-jwt', email: email);
    state = AsyncData(_currentState);
  }

  @override
  Future<void> logout() async {
    _currentState = const Unauthenticated();
    state = AsyncData(_currentState);
  }
}

Widget _buildLoginScreen({_MockAuthNotifier? mockNotifier}) {
  final notifier = mockNotifier ?? _MockAuthNotifier();
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => notifier),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: const LoginScreen(),
    ),
  );
}

void main() {
  group('LoginScreen (redesigned)', () {
    // ── Storefront icon (replaces lock) ──

    testWidgets('renders storefront icon (not lock)', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.storefront_rounded), findsOneWidget);
      // Lock icon should be gone.
      expect(find.byIcon(Icons.lock_rounded), findsNothing);
    });

    // ── Norwegian headings ──

    testWidgets('shows Norwegian heading', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.text('DittoDatto Forretningsportal'), findsOneWidget);
    });

    testWidgets('shows Norwegian subtitle', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(
        find.text('Velkommen tilbake. Skriv inn dine påloggingsdetaljer.'),
        findsOneWidget,
      );
    });

    // ── Norwegian form fields ──

    testWidgets('renders E-post field with Norwegian label', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'E-post'), findsOneWidget);
    });

    testWidgets('renders Passord field with Norwegian label', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Passord'), findsOneWidget);
    });

    // ── Password visibility toggle ──

    testWidgets('has password visibility toggle', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      // Should have a visibility toggle icon button.
      expect(
        find.byIcon(Icons.visibility_off_rounded),
        findsOneWidget,
      );
    });

    testWidgets('toggling visibility shows password text', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      // Enter a password.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Passord'),
        'mypassword',
      );

      // Initially obscured.
      var editableText = tester.widget<EditableText>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Passord'),
          matching: find.byType(EditableText),
        ),
      );
      expect(editableText.obscureText, isTrue);

      // Tap the toggle.
      await tester.tap(find.byIcon(Icons.visibility_off_rounded));
      await tester.pumpAndSettle();

      // Now should be visible.
      editableText = tester.widget<EditableText>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Passord'),
          matching: find.byType(EditableText),
        ),
      );
      expect(editableText.obscureText, isFalse);
    });

    // ── Norwegian button ──

    testWidgets('renders "Logg inn" button', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ElevatedButton, 'Logg inn →'),
        findsOneWidget,
      );
    });

    // ── Contact admin text ──

    testWidgets('shows "Kontakt oss ved problemer med innlogging" text',
        (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(
        find.text('Kontakt oss ved problemer med innlogging'),
        findsOneWidget,
      );
    });

    // ── Functional: validation still works ──

    testWidgets('validates empty fields shows Påkrevd', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Logg inn →'));
      await tester.pumpAndSettle();

      expect(find.text('Påkrevd'), findsWidgets);
    });

    // ── Functional: login submission still works ──

    testWidgets('submits login with entered credentials', (tester) async {
      final mock = _MockAuthNotifier();
      await tester.pumpWidget(_buildLoginScreen(mockNotifier: mock));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'E-post'),
        'arnarvalur@dittodatto.no',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Passord'),
        'secret123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Logg inn →'));
      await tester.pumpAndSettle();

      expect(mock.loginCallCount, 1);
      expect(mock.lastEmail, 'arnarvalur@dittodatto.no');
      expect(mock.lastPassword, 'secret123');
    });

    testWidgets('submits login with lowercased email', (tester) async {
      final mock = _MockAuthNotifier();
      await tester.pumpWidget(_buildLoginScreen(mockNotifier: mock));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'E-post'),
        'ArnarValur@dittodatto.no',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Passord'),
        'secret123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Logg inn →'));
      await tester.pumpAndSettle();

      expect(mock.lastEmail, 'arnarvalur@dittodatto.no');
    });
  });
}
