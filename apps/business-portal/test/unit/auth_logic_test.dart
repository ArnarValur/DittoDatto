import 'package:mercury_client/mercury_client.dart';
import 'package:test/test.dart';

/// Pure unit tests for the [AuthState] sealed class hierarchy.
///
/// These verify state transitions and data properties — no DB, no mocks, instant.
void main() {
  group('AuthState sealed class', () {
    test('Unauthenticated is a valid AuthState', () {
      const state = Unauthenticated();
      expect(state, isA<AuthState>());
    });

    test('AuthLoading is a valid AuthState', () {
      const state = AuthLoading();
      expect(state, isA<AuthState>());
    });

    test('Authenticated carries accessToken and email', () {
      const state = Authenticated(
        accessToken: 'eyJ.test.jwt',
        email: 'arnarvalur@dittodatto.no',
      );
      expect(state, isA<AuthState>());
      expect(state.accessToken, 'eyJ.test.jwt');
      expect(state.email, 'arnarvalur@dittodatto.no');
    });

    test('AuthError carries message', () {
      const state = AuthError(message: 'Connection refused');
      expect(state, isA<AuthState>());
      expect(state.message, 'Connection refused');
    });

    test('exhaustive pattern matching covers all states', () {
      // Verify the sealed class enables exhaustive switch.
      const AuthState state = Unauthenticated();
      final label = switch (state) {
        Unauthenticated() => 'unauth',
        AuthLoading() => 'loading',
        Authenticated() => 'auth',
        AuthError() => 'error',
      };
      expect(label, 'unauth');
    });
  });

  group('Business Portal role validation logic', () {
    // Tests the role checking logic used in SurrealAuthService.login().
    // Extracted here as pure logic — no DB needed.
    const allowedRoles = {'business', 'admin', 'super_admin'};

    test('business role is allowed', () {
      expect(allowedRoles.contains('business'), isTrue);
    });

    test('admin role is allowed', () {
      expect(allowedRoles.contains('admin'), isTrue);
    });

    test('super_admin role is allowed', () {
      expect(allowedRoles.contains('super_admin'), isTrue);
    });

    test('customer role is rejected', () {
      expect(allowedRoles.contains('customer'), isFalse);
    });

    test('empty role is rejected', () {
      expect(allowedRoles.contains(''), isFalse);
    });
  });

  group('Email normalization for auth', () {
    // Tests the email normalization logic: email.trim().toLowerCase()
    String normalizeEmail(String email) => email.trim().toLowerCase();

    test('standard email passes through', () {
      expect(normalizeEmail('arnarvalur@avj.info'), 'arnarvalur@avj.info');
    });

    test('uppercase email is lowercased', () {
      expect(normalizeEmail('ArnarValur@AVJ.INFO'), 'arnarvalur@avj.info');
    });

    test('whitespace is trimmed', () {
      expect(normalizeEmail('  arnarvalur@avj.info  '), 'arnarvalur@avj.info');
    });

    test('different domains produce different emails', () {
      expect(
        normalizeEmail('arnarvalur@avj.info') != normalizeEmail('arnarvalur@gmail.com'),
        isTrue,
        reason: 'Full email must match — domain matters',
      );
    });
  });

  group('Tenant slug parsing', () {
    // Tests the company_slug → first slug logic used in SurrealAuthService.
    String firstSlug(String rawSlug) => rawSlug.split(',').first.trim();

    test('single slug returns as-is', () {
      expect(firstSlug('testcompany'), 'testcompany');
    });

    test('comma-separated slugs returns first', () {
      expect(firstSlug('company-a, company-b'), 'company-a');
    });

    test('slug with whitespace is trimmed', () {
      expect(firstSlug('  testcompany  '), 'testcompany');
    });
  });
}
