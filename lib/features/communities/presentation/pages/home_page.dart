import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_l10n.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/community.dart';
import '../community_labels.dart';
import '../providers/subscribed_communities_controller.dart';
import '../widgets/community_tile.dart';

/// Communities tab: joined communities, WhatsApp-style, latest activity first.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final communities = ref.watch(subscribedCommunitiesProvider);

    return Scaffold(
      body: Column(
        children: [
          GradientHeader(title: l10n.homeTitle, subtitle: l10n.homeSubtitle),
          Expanded(
            child: switch (communities) {
              AsyncData(:final value) when value.isEmpty => AppEmptyView(
                  icon: Icons.forum_outlined,
                  title: l10n.communitiesEmptyTitle,
                  message: l10n.communitiesEmptyBody,
                  actionLabel: l10n.exploreTitle,
                  onAction: () => context.go(RouteNames.explore),
                ),
              AsyncData(:final value) => _CommunityList(communities: value),
              AsyncError(:final error) => AppErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(subscribedCommunitiesProvider),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _CommunityList extends ConsumerWidget {
  const _CommunityList({required this.communities});
  final List<Community> communities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(subscribedCommunitiesProvider.notifier);

    void showFailure(String message) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    Future<void> leave(Community c) async {
      final messenger = ScaffoldMessenger.of(context);
      final failure = await controller.leave(c);
      if (failure != null) return showFailure(failure.localized(l10n));
      messenger.showSnackBar(SnackBar(
        content: Text(l10n.leftCommunity(c.areaName)),
        action: SnackBarAction(
          label: l10n.undo,
          textColor: AppColors.desertSandstone,
          onPressed: () => controller.join(c),
        ),
      ));
    }

    Future<void> showActions(Community c) async {
      final action = await showModalBottomSheet<_Action>(
        context: context,
        backgroundColor: AppColors.cardSurface,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                child: Text(c.fullName(l10n),
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              ListTile(
                leading: Icon(c.isMuted
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined),
                title: Text(c.isMuted ? l10n.unmute : l10n.mute),
                onTap: () => Navigator.pop(context, _Action.toggleMute),
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded,
                    color: AppColors.error),
                title: Text(l10n.leave,
                    style: const TextStyle(color: AppColors.error)),
                onTap: () => Navigator.pop(context, _Action.leave),
              ),
            ],
          ),
        ),
      );
      switch (action) {
        case _Action.toggleMute:
          final failure = await controller.setMuted(c, muted: !c.isMuted);
          if (failure != null) showFailure(failure.localized(l10n));
        case _Action.leave:
          await leave(c);
        case null:
          break;
      }
    }

    return RefreshIndicator(
      color: AppColors.duskBlue,
      onRefresh: () async {
        final failure = await controller.refresh();
        if (failure != null) showFailure(failure.localized(l10n));
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        itemCount: communities.length,
        separatorBuilder: (_, _) => const Divider(
            height: 1, indent: 80, color: AppColors.desertSandstone),
        itemBuilder: (context, i) {
          final c = communities[i];
          return CommunityTile(
            community: c,
            onTap: () => context.push(RouteNames.communityFeed(c.id)),
            onLongPress: () => showActions(c),
          );
        },
      ),
    );
  }
}

enum _Action { toggleMute, leave }
