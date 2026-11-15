import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../data/repositories/communities_repository_impl.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/community_filter.dart';
import '../../domain/usecases/search_communities.dart';
import 'subscribed_communities_controller.dart';

final searchCommunitiesProvider = Provider(
    (ref) => SearchCommunities(ref.watch(communitiesRepositoryProvider)));

final exploreFilterProvider =
    NotifierProvider<ExploreFilterController, CommunityFilter>(
        ExploreFilterController.new);

class ExploreFilterController extends Notifier<CommunityFilter> {
  @override
  CommunityFilter build() => const CommunityFilter();

  void setQuery(String query) => state = state.copyWith(query: query);
  void setTransaction(TransactionType? t) =>
      state = state.copyWith(transaction: () => t);
  void setUse(PropertyUse? u) => state = state.copyWith(use: () => u);
}

/// A community already loaded by the home list or explore, for headers.
final communityByIdProvider =
    Provider.family<Community?, String>((ref, id) {
  bool match(Community c) => c.id == id;
  return ref
          .watch(subscribedCommunitiesProvider)
          .valueOrNull
          ?.where(match)
          .firstOrNull ??
      ref.watch(exploreProvider).valueOrNull?.where(match).firstOrNull;
});

final exploreProvider =
    AsyncNotifierProvider<ExploreController, List<Community>>(
        ExploreController.new);

/// Browse results for the current filter. Join/leave are optimistic and
/// keep the home list in sync.
class ExploreController extends AsyncNotifier<List<Community>> {
  @override
  Future<List<Community>> build() async {
    final filter = ref.watch(exploreFilterProvider);
    return switch (await ref.read(searchCommunitiesProvider)(filter)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<Failure?> toggleJoin(Community community) async {
    final join = !community.isSubscribed;
    _replace(community.copyWith(isSubscribed: join));

    final result = join
        ? await ref.read(subscribeCommunityProvider)(community.id)
        : await ref.read(unsubscribeCommunityProvider)(community.id);

    final failure = result.failureOrNull;
    if (failure != null) {
      _replace(community);
    } else {
      ref.invalidate(subscribedCommunitiesProvider);
    }
    return failure;
  }

  void _replace(Community updated) {
    final list = state.valueOrNull;
    if (list == null) return;
    state = AsyncData([
      for (final c in list) c.id == updated.id ? updated : c,
    ]);
  }
}
