import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/broker_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile implements UseCase<BrokerProfile, NoParams> {
  const GetProfile(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Result<BrokerProfile>> call(NoParams params) =>
      _repository.getProfile();
}
