import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../communities/presentation/providers/subscribed_communities_controller.dart';

/// Bottom navigation from the design:
/// Communities · Search · (+ New post) · My posts · Profile.
/// The four tabs keep their state (IndexedStack); New post opens on top.
class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unread = ref.watch(totalUnreadProvider);

    void goTab(int branch) => shell.goBranch(
          branch,
          // Tapping the current tab again returns to its first page.
          initialLocation: branch == shell.currentIndex,
        );

    return Scaffold(
      body: shell,
      bottomNavigationBar: _HayyBottomBar(
        children: [
          _NavItem(
            icon: Icons.forum_outlined,
            selectedIcon: Icons.forum_rounded,
            label: l10n.navCommunities,
            selected: shell.currentIndex == 0,
            badge: unread,
            onTap: () => goTab(0),
          ),
          _NavItem(
            icon: Icons.search_rounded,
            selectedIcon: Icons.search_rounded,
            label: l10n.navSearch,
            selected: shell.currentIndex == 1,
            onTap: () => goTab(1),
          ),
          _NewPostButton(
            label: l10n.navNewPost,
            onTap: () => context.push(RouteNames.newPost),
          ),
          _NavItem(
            icon: Icons.article_outlined,
            selectedIcon: Icons.article_rounded,
            label: l10n.navMyPosts,
            selected: shell.currentIndex == 2,
            onTap: () => goTab(2),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: l10n.navProfile,
            selected: shell.currentIndex == 3,
            onTap: () => goTab(3),
          ),
        ],
      ),
    );
  }
}

class _HayyBottomBar extends StatelessWidget {
  const _HayyBottomBar({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          border: const Border(
              top: BorderSide(color: AppColors.desertSandstone)),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final c in children) Expanded(child: c)],
            ),
          ),
        ),
      );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.duskBlue : AppColors.textSecondary;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: selected ? AppColors.desertSandstone : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Badge(
                isLabelVisible: badge > 0,
                label: Text(badge > 99 ? '99+' : '$badge'),
                backgroundColor: AppColors.duskBlue,
                textColor: AppColors.white,
                child: Icon(selected ? selectedIcon : icon,
                    color: color, size: 22),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Raised copper circle in the middle of the bar.
class _NewPostButton extends StatelessWidget {
  const _NewPostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          // The circle rises 12px above the bar; the label sits at the
          // bottom like the other tabs. A Stack keeps the bar's height fixed.
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: -12,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.copperMetal,
                    border: Border.all(color: AppColors.cardSurface, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mutedCopper.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: AppColors.white, size: 30),
                ),
              ),
              Positioned(
                bottom: 9,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.copperText,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}
