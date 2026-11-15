import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/repositories/communities_repository_impl.dart';
import '../../domain/entities/community.dart';
import '../../domain/usecases/get_subscribed_communities.dart';
import '../../domain/usecases/mute_community.dart';
import '../../domain/usecases/subscribe_community.dart';
import '../../domain/usecases/unsubscribe_community.dart';
import 'explore_controller.dart';

final getSubscribedCommunitiesProvider = Provider((ref) =>
    GetSubscribedCommunities(ref.watch(communitiesRepositoryProvider)));
final subscribeCommunityProvider = Provider(
    (ref) => SubscribeCommunity(ref.watch(communitiesRepositoryProvider)));
final unsubscribeCommunityProvider = Provider(
    (ref) => UnsubscribeCommunity(ref.watch(communitiesRepositoryProvider)));
final muteCommunityProvider =
    Provider((ref) => MuteCommunity(ref.watch(communitiesRepositoryProvider)));

final subscribedCommunitiesProvider =
    AsyncNotifierProvider<SubscribedCommunitiesController, List<Community>>(
        SubscribedCommunitiesController.new);

/// Unread posts across joined, unmuted communities (badge on the nav tab).
final totalUnreadProvider = Provider<int>((ref) =>
    ref.watch(subscribedCommunitiesProvider).valueOrNull?.fold<int>(
        0, (sum, c) => c.isMuted ? sum : sum + c.unreadCount) ??
    0);

/// The home list. Mute and leave are optimistic: the UI changes at once
/// and rolls back if the server refuses.
class SubscribedCommunitiesController
    extends AsyncNotifier<List<Community>> {
  @override
  Future<List<Community>> build() async {
    ref.watch(authControllerProvider
        .select((s) => s is Authenticated ? s.session.brokerId : null));
    return _fetch();
  }

  Future<List<Community>> _fetch() async =>
      switch (await ref.read(getSubscribedCommunitiesProvider)(
          const NoParams())) {
        Ok(:final value) => value,
        Err(:final failure) => throw failure,
      };

  /// Pull-to-refresh: keeps the current list if the reload fails.
  Future<Failure?> refresh() async {
    try {
      state = AsyncData(await _fetch());
      return null;
    } on Failure catch (failure) {
      if (!state.hasValue) state = AsyncError(failure, StackTrace.current);
      return failure;
    }
  }

  Future<Failure?> setMuted(Community community, {required bool muted}) =>
      _optimistic(
        (list) => [
          for (final c in list)
            c.id == community.id ? c.copyWith(isMuted: muted) : c,
        ],
        () => ref.read(muteCommunityProvider)(
            MuteCommunityParams(communityId: community.id, muted: muted)),
      );

  Future<Failure?> leave(Community community) async {
    final failure = await _optimistic(
      (list) => list.where((c) => c.id != community.id).toList(),
      () => ref.read(unsubscribeCommunityProvider)(community.id),
    );
    // Explore shows Join/Joined: keep it in sync.
    if (failure == null) ref.invalidate(exploreProvider);
    return failure;
  }

  /// Re-joins after "Undo".
  Future<Failure?> join(Community community) async {
    final failure =
        (await ref.read(subscribeCommunityProvider)(community.id))
            .failureOrNull;
    if (failure == null) {
      ref.invalidate(exploreProvider);
      await refresh();
    }
    return failure;
  }

  Future<Failure?> _optimistic(
    List<Community> Function(List<Community>) change,
    Future<Result<void>> Function() request,
  ) async {
    final before = state.valueOrNull;
    if (before != null) state = AsyncData(change(before));
    final failure = (await request()).failureOrNull;
    if (failure != null && before != null) state = AsyncData(before);
    return failure;
  }
}
