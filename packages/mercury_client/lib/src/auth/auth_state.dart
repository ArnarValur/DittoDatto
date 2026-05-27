/// Sealed authentication state ADT.
///
/// Admin app auth exists in exactly one of four states at any time.
/// Pattern-match on this in UI code for exhaustive handling.
sealed class AuthState {
  const AuthState();
}

/// User is not authenticated and no auth operation is in progress.
final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Authentication is in progress (login attempt or token restore).
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated with a valid access token.
final class Authenticated extends AuthState {
  const Authenticated({
    required this.accessToken,
    required this.email,
  });

  /// JWT access token.
  final String accessToken;

  /// Email of the authenticated user.
  final String email;
}

/// Authentication failed with an error.
///
/// Per PRD: the login screen does NOT display this error to the user
/// (maximum opacity). The state exists for internal flow control.
final class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;
}
