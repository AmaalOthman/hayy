import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_l10n.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/community.dart';
import '../providers/explore_controller.dart';
import '../widgets/community_filter_bar.dart';
import '../widgets/community_tile.dart';

/// Search tab: browse all communities by neighbourhood, Sale/Rental and
/// Residential/Commercial, and join or leave them.
class ExploreCommunitiesPage extends ConsumerStatefulWidget {
  const ExploreCommunitiesPage({super.key});

  @override
  ConsumerState<ExploreCommunitiesPage> createState() =>
      _ExploreCommunitiesPageState();
}

class _ExploreCommunitiesPageState
    extends ConsumerState<ExploreCommunitiesPage> {
  final _search = TextEditingController();
  final _debouncer = Debouncer();

  @override
  void dispose() {
    _search.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _toggleJoin(Community c) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final failure = await ref.read(exploreProvider.notifier).toggleJoin(c);
    if (failure != null) {
      messenger.showSnackBar(SnackBar(content: Text(failure.localized(l10n))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(exploreFilterProvider);
    final filterCtrl = ref.read(exploreFilterProvider.notifier);
    final results = ref.watch(exploreProvider);

    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            title: l10n.exploreTitle,
            subtitle: results.valueOrNull == null
                ? null
                : l10n.exploreSubtitle(results.value!.length),
            bottom: _SearchField(
              controller: _search,
              hint: l10n.searchCommunitiesHint,
              onChanged: (q) => _debouncer(() => filterCtrl.setQuery(q)),
              onClear: () {
                _search.clear();
                filterCtrl.setQuery('');
              },
            ),
          ),
          CommunityFilterBar(
            filter: filter,
            onTransactionChanged: filterCtrl.setTransaction,
            onUseChanged: filterCtrl.setUse,
          ),
          const Divider(height: 1, color: AppColors.desertSandstone),
          Expanded(
            child: switch (results) {
              AsyncData(:final value) when value.isEmpty => AppEmptyView(
                  icon: Icons.search_off_rounded,
                  message: l10n.noCommunitiesFound,
                ),
              AsyncData(:final value) => ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  itemCount: value.length,
                  separatorBuilder: (_, _) => const Divider(
                      height: 1, indent: 80, color: AppColors.desertSandstone),
                  itemBuilder: (context, i) {
                    final c = value[i];
                    return CommunityTile(
                      community: c,
                      onTap: () =>
                          context.push(RouteNames.communityFeed(c.id)),
                      trailing: _JoinButton(
                        joined: c.isSubscribed,
                        onPressed: () => _toggleJoin(c),
                      ),
                    );
                  },
                ),
              AsyncError(:final error) => AppErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(exploreProvider),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.close_rounded), onPressed: onClear),
          ),
          fillColor: AppColors.cardSurface,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdAll,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdAll,
            borderSide: const BorderSide(color: AppColors.desertSandstone),
          ),
        ),
      );
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.joined, required this.onPressed});

  final bool joined;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const size = Size(88, 36);
    final padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: joined
          ? OutlinedButton.icon(
              key: const ValueKey('joined'),
              onPressed: onPressed,
              icon: const Icon(Icons.check_rounded, size: 16),
              label: Text(l10n.joined),
              style: OutlinedButton.styleFrom(
                  minimumSize: size, padding: padding),
            )
          : FilledButton(
              key: const ValueKey('join'),
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                  minimumSize: size, padding: padding),
              child: Text(l10n.join),
            ),
    );
  }
}
