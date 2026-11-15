import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/community.dart';
import '../repositories/communities_repository.dart';

class GetSubscribedCommunities implements UseCase<List<Community>, NoParams> {
  const GetSubscribedCommunities(this._repository);
  final CommunitiesRepository _repository;

  @override
  Future<Result<List<Community>>> call(NoParams params) =>
      _repository.getSubscribed();
}
