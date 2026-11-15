import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/community_filter.dart';
import '../../domain/repositories/communities_repository.dart';
import '../datasources/communities_remote_datasource.dart';

final communitiesRepositoryProvider = Provider<CommunitiesRepository>((ref) =>
    CommunitiesRepositoryImpl(ref.watch(communitiesRemoteDataSourceProvider)));

class CommunitiesRepositoryImpl implements CommunitiesRepository {
  const CommunitiesRepositoryImpl(this._remote);
  final CommunitiesRemoteDataSource _remote;

  @override
  Future<Result<List<Community>>> getSubscribed() =>
      guard(_remote.getSubscribed);

  @override
  Future<Result<List<Community>>> search(CommunityFilter filter) =>
      guard(() => _remote.search(filter));

  @override
  Future<Result<void>> subscribe(String communityId) =>
      guard(() => _remote.subscribe(communityId));

  @override
  Future<Result<void>> unsubscribe(String communityId) =>
      guard(() => _remote.unsubscribe(communityId));

  @override
  Future<Result<void>> setMuted(String communityId, {required bool muted}) =>
      guard(() => _remote.setMuted(communityId, muted: muted));
}
