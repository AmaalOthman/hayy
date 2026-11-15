import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtp implements UseCase<void, String> {
  const SendOtp(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String phone) => _repository.sendOtp(phone);
}
