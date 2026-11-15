import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  /// [phone] in E.164, e.g. `+971501234567`.
  Future<Result<void>> sendOtp(String phone);

  /// Verifies the code, stores the tokens and returns the session.
  Future<Result<AuthSession>> verifyOtp({
    required String phone,
    required String code,
  });

  /// The stored session refreshed from the server, or `null` when signed out.
  Future<Result<AuthSession?>> getCurrentSession();

  /// Always clears local tokens, even if the server call fails.
  Future<Result<void>> logout();
}
