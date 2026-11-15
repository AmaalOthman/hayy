import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/communities_repository.dart';

/// Params: community id.
class SubscribeCommunity implements UseCase<void, String> {
  const SubscribeCommunity(this._repository);
  final CommunitiesRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.subscribe(params);
}
