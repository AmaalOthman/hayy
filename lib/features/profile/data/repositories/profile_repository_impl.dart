import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/broker_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
    (ref) => ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider)));

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote);
  final ProfileRemoteDataSource _remote;

  @override
  Future<Result<BrokerProfile>> getProfile() => guard(_remote.getProfile);

  @override
  Future<Result<BrokerProfile>> updateProfile(ProfileUpdate update) =>
      guard(() => _remote.updateProfile(update));
}
