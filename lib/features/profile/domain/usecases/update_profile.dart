import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/broker_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile implements UseCase<BrokerProfile, ProfileUpdate> {
  const UpdateProfile(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Result<BrokerProfile>> call(ProfileUpdate params) =>
      _repository.updateProfile(params);
}
