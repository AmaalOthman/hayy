import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/community.dart';
import '../entities/community_filter.dart';
import '../repositories/communities_repository.dart';

class SearchCommunities implements UseCase<List<Community>, CommunityFilter> {
  const SearchCommunities(this._repository);
  final CommunitiesRepository _repository;

  @override
  Future<Result<List<Community>>> call(CommunityFilter params) =>
      _repository.search(params);
}
