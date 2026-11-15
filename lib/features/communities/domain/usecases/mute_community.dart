import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/communities_repository.dart';

class MuteCommunityParams {
  const MuteCommunityParams({required this.communityId, required this.muted});
  final String communityId;
  final bool muted;
}

class MuteCommunity implements UseCase<void, MuteCommunityParams> {
  const MuteCommunity(this._repository);
  final CommunitiesRepository _repository;

  @override
  Future<Result<void>> call(MuteCommunityParams params) =>
      _repository.setMuted(params.communityId, muted: params.muted);
}
