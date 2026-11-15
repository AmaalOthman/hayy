import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class GetCurrentSession implements UseCase<AuthSession?, NoParams> {
  const GetCurrentSession(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<AuthSession?>> call(NoParams params) =>
      _repository.getCurrentSession();
}
