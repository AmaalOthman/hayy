import '../../domain/entities/auth_session.dart';

sealed class AuthState {
  const AuthState();
}

/// App just started; the splash is checking the stored session.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Signed in. Routing still depends on `session.status` (admin approval).
final class Authenticated extends AuthState {
  const Authenticated(this.session);
  final AuthSession session;
}
