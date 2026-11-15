import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<void>> sendOtp(String phone);

  Future<Result<AuthSession>> verifyOtp({
    required String phone,
    required String code,
  });

  Future<Result<AuthSession?>> getCurrentSession();

  Future<Result<void>> logout();
}
