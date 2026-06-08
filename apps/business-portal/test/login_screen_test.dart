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
      theme: DittoTheme.dark,
      home: const LoginScreen(),
    ),
  );
}

void main() {
  group('LoginScreen', () {
    testWidgets('renders email field', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    });

    testWidgets('renders password field with obscured text', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Verify the password field uses obscureText via EditableText.
      final editableText = tester.widget<EditableText>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Password'),
          matching: find.byType(EditableText),
        ),
      );
      expect(editableText.obscureText, isTrue);
    });

    testWidgets('renders Sign In button', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ElevatedButton, 'Sign In'),
        findsOneWidget,
      );
    });

    testWidgets('renders lock icon', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    });

    testWidgets('validates empty email shows Required', (tester) async {
      await tester.pumpWidget(_buildLoginScreen());
      await tester.pumpAndSettle();

      // Tap Sign In without filling fields.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsWidgets);
    });

    testWidgets('submits login with entered credentials', (tester) async {
      final mock = _MockAuthNotifier();
      await tester.pumpWidget(_buildLoginScreen(mockNotifier: mock));
      await tester.pumpAndSettle();

      // Enter credentials.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'arnarvalur@dittodatto.no',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret123',
      );

      // Tap Sign In.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(mock.loginCallCount, 1);
      expect(mock.lastEmail, 'arnarvalur@dittodatto.no');
      expect(mock.lastPassword, 'secret123');
    });
  });
}
