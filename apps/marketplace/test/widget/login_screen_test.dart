import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/core/auth_provider.dart';
import 'package:marketplace/features/auth/login_screen.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:ditto_design/ditto_design.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

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
  Future<void> signup(String name, String email, String password) async {}

  @override
  Future<void> logout() async {
    _currentState = const Unauthenticated();
    state = AsyncData(_currentState);
  }
}

class _FailingAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  @override
  Future<AuthState> build() async => const Unauthenticated();

  @override
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = const AsyncData(Unauthenticated());
  }

  @override
  Future<void> signup(String name, String email, String password) async {}

  @override
  Future<void> logout() async {}
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

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

Widget _buildLoginScreenFailing() {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _FailingAuthNotifier()),
    ],
    child: MaterialApp(
      theme: DittoTheme.light,
      home: const LoginScreen(),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('LoginScreen', () {
    testWidgets('renders E-post and Passord form fields', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.text('E-post'), findsOneWidget);
      expect(find.text('Passord'), findsOneWidget);
    });

    testWidgets('empty submit shows both validation errors', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logg inn'));
      await tester.pumpAndSettle();

      expect(find.text('Skriv inn e-postadressen din'), findsOneWidget);
      expect(find.text('Skriv inn passordet ditt'), findsOneWidget);
    });

    testWidgets('invalid email (no @) shows Ugyldig e-postadresse',
        (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-post'), 'bademail');
      await tester.tap(find.text('Logg inn'));
      await tester.pumpAndSettle();

      expect(find.text('Ugyldig e-postadresse'), findsOneWidget);
    });

    testWidgets('empty password shows Skriv inn passordet ditt',
        (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-post'), 'a@b.com');
      await tester.tap(find.text('Logg inn'));
      await tester.pumpAndSettle();

      expect(find.text('Skriv inn passordet ditt'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    });

    testWidgets('signup link Opprett konto is present', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.text('Opprett konto'), findsOneWidget);
    });

    testWidgets('submits login with entered credentials', (tester) async {
      final mock = _MockAuthNotifier();
      await tester.pumpWidget(_buildLoginScreen(mockNotifier: mock));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-post'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Passord'), 'secret123');
      await tester.tap(find.text('Logg inn'));
      await tester.pumpAndSettle();

      expect(mock.loginCallCount, 1);
      expect(mock.lastEmail, 'test@example.com');
      expect(mock.lastPassword, 'secret123');
    });

    testWidgets('failed login shows SnackBar Feil e-post eller passord',
        (tester) async {
      await tester.pumpWidget(_buildLoginScreenFailing());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-post'), 'wrong@bad.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Passord'), 'wrongpass');
      await tester.tap(find.text('Logg inn'));
      await tester.pumpAndSettle();

      expect(find.text('Feil e-post eller passord'), findsOneWidget);
    });
  });
}
