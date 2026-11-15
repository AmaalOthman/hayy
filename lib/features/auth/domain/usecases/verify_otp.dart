import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams {
  const VerifyOtpParams({required this.phone, required this.code});
  final String phone;
  final String code;
}

class VerifyOtp implements UseCase<AuthSession, VerifyOtpParams> {
  const VerifyOtp(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<AuthSession>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(phone: params.phone, code: params.code);
}
