import '../../../../core/error/result.dart';
import '../entities/community.dart';
import '../entities/community_filter.dart';

abstract interface class CommunitiesRepository {
  /// Communities the broker joined, most recent activity first.
  Future<Result<List<Community>>> getSubscribed();

  /// The full catalogue (100+), filtered. Each item says if it's joined.
  Future<Result<List<Community>>> search(CommunityFilter filter);

  Future<Result<void>> subscribe(String communityId);
  Future<Result<void>> unsubscribe(String communityId);

  /// Mutes push notifications for one community.
  Future<Result<void>> setMuted(String communityId, {required bool muted});
}
