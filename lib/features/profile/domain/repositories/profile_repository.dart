import '../../../../core/error/result.dart';
import '../entities/broker_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<BrokerProfile>> getProfile();

  Future<Result<BrokerProfile>> updateProfile(ProfileUpdate update);
}
