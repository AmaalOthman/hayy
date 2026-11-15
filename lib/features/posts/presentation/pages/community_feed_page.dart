import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../communities/presentation/community_labels.dart';
import '../../../communities/presentation/providers/explore_controller.dart';

/// One community's timeline. The header and "New post" action are in place;
/// the chat-like post list is built in the posts feature.
class CommunityFeedPage extends ConsumerWidget {
  const CommunityFeedPage({super.key, required this.communityId});

  final String communityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final community = ref.watch(communityByIdProvider(communityId));

    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            leading: const BackButton(color: Colors.white),
            title: community?.fullName(l10n) ?? '',
            subtitle: community == null
                ? null
                : '${l10n.homeSubtitle} · ${l10n.memberCount(community.memberCount)}',
          ),
          Expanded(
            child: AppEmptyView(
              icon: Icons.chat_bubble_outline_rounded,
              message: l10n.feedEmpty,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.newPost),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.navNewPost),
      ),
    );
  }
}
