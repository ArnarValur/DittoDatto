import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/core/auth_provider.dart';
import 'package:marketplace/features/auth/signup_screen.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:ditto_design/ditto_design.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class _MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  AuthState _currentState = const Unauthenticated();
  String? lastName;
  String? lastEmail;
  String? lastPassword;
  int signupCallCount = 0;

  @override
  Future<AuthState> build() async => _currentState;

  @override
  Future<void> signup(String name, String email, String password) async {
    lastName = name;
    lastEmail = email;
    lastPassword = password;
    signupCallCount++;
    state = const AsyncLoading();
    _currentState = Authenticated(
      accessToken: 'test-jwt',
      email: email,
      name: name,
    );
    state = AsyncData(_currentState);
  }

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> logout() async {
    _currentState = const Unauthenticated();
    state = AsyncData(_currentState);
  }
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Widget _buildSignupScreen({_MockAuthNotifier? mockNotifier}) {
  final notifier = mockNotifier ?? _MockAuthNotifier();
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => notifier),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: const SignupScreen(),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SignupScreen', () {
    testWidgets('renders all 4 form fields', (tester) async {
      await tester.pumpWidget(_buildSignupScreen());
      await tester.pumpAndSettle();

      expect(find.text('Fullt navn'), findsOneWidget);
      expect(find.text('E-post'), findsOneWidget);
      expect(find.text('Passord'), findsOneWidget);
      expect(find.text('Bekreft passord'), findsOneWidget);
    });

    testWidgets(
        'empty submit shows validation errors for name, email, password',
        (tester) async {
      await tester.pumpWidget(_buildSignupScreen());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Opprett konto').last);
      await tester.tap(find.text('Opprett konto').last);
      await tester.pumpAndSettle();

      expect(find.text('Skriv inn navnet ditt'), findsOneWidget);
      expect(find.text('Skriv inn e-postadressen din'), findsOneWidget);
      expect(find.text('Velg et passord'), findsOneWidget);
      // Confirm password passes when both are empty ('' == '').
      expect(find.text('Passordene stemmer ikke overens'), findsNothing);
    });

    testWidgets('short password shows Passordet må være minst 8 tegn',
        (tester) async {
      await tester.pumpWidget(_buildSignupScreen());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Passord'), 'short');
      await tester.ensureVisible(find.text('Opprett konto').last);
      await tester.tap(find.text('Opprett konto').last);
      await tester.pumpAndSettle();

      expect(find.text('Passordet må være minst 8 tegn'), findsOneWidget);
    });

    testWidgets('mismatched confirm shows Passordene stemmer ikke overens',
        (tester) async {
      await tester.pumpWidget(_buildSignupScreen());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Passord'), 'password123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Bekreft passord'), 'different');
      await tester.ensureVisible(find.text('Opprett konto').last);
      await tester.tap(find.text('Opprett konto').last);
      await tester.pumpAndSettle();

      expect(find.text('Passordene stemmer ikke overens'), findsOneWidget);
    });

    testWidgets('login link Logg inn is present', (tester) async {
      await tester.pumpWidget(_buildSignupScreen());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextButton, 'Logg inn'),
        findsOneWidget,
      );
    });

    testWidgets('submits signup with entered credentials', (tester) async {
      final mock = _MockAuthNotifier();
      await tester.pumpWidget(_buildSignupScreen(mockNotifier: mock));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Fullt navn'), 'Test User');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-post'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Passord'), 'password123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Bekreft passord'), 'password123');

      await tester.ensureVisible(find.text('Opprett konto').last);
      await tester.tap(find.text('Opprett konto').last);
      await tester.pumpAndSettle();

      expect(mock.signupCallCount, 1);
      expect(mock.lastName, 'Test User');
      expect(mock.lastEmail, 'test@example.com');
      expect(mock.lastPassword, 'password123');
    });
  });
}
