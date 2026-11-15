import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../posts/presentation/widgets/post_type_chip.dart';
import '../../domain/entities/community.dart';
import '../community_labels.dart';
import 'unread_badge.dart';

/// WhatsApp-style row. With [trailing] (explore) it shows the member count
/// and the given action; without it (home) the latest post, time and badge.
class CommunityTile extends StatelessWidget {
  const CommunityTile({
    super.key,
    required this.community,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  final Community community;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final c = community;
    final last = c.lastPost;
    final unread = c.unreadCount > 0;
    final showActivity = trailing == null;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            CommunityAvatar(community: c),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.areaName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
                        ),
                      ),
                      if (showActivity && last != null)
                        Text(
                          DateFormatter.chatTime(
                            last.createdAt,
                            locale: l10n.localeName,
                            yesterday: l10n.yesterday,
                          ),
                          style: text.bodySmall?.copyWith(
                            color: unread && !c.isMuted
                                ? AppColors.duskBlue
                                : AppColors.textSecondary,
                            fontWeight: unread ? FontWeight.w700 : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    showActivity
                        ? c.typeLabel(l10n)
                        : '${c.typeLabel(l10n)} · ${l10n.memberCount(c.memberCount)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelMedium
                        ?.copyWith(color: AppColors.copperText),
                  ),
                  if (showActivity) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        if (last != null) ...[
                          PostTypeChip(type: last.type, dense: true),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            last == null
                                ? l10n.noPostsYet
                                : '${last.authorName}: ${last.summary}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: last == null ? FontStyle.italic : null,
                            ),
                          ),
                        ),
                        if (c.isMuted)
                          const Padding(
                            padding: EdgeInsetsDirectional.only(start: 6),
                            child: Icon(Icons.notifications_off_outlined,
                                size: 16, color: AppColors.textSecondary),
                          ),
                        if (unread)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 6),
                            child: UnreadBadge(
                                count: c.unreadCount, muted: c.isMuted),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Area initials on the brand gradient. Sale and rental use different
/// gradients; a small badge shows residential (home) or commercial (office).
class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({super.key, required this.community, this.size = 52});

  final Community community;
  final double size;

  static const _rentalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.viewingFg, AppColors.duskBlue],
  );

  String get _initials {
    final words =
        community.areaName.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return (words.length > 1
            ? words.take(2).map((w) => w[0]).join()
            : community.areaName.substring(
                0, community.areaName.length.clamp(0, 2)))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: community.transaction == TransactionType.sale
                    ? AppGradients.header
                    : _rentalGradient,
              ),
              child: Text(
                _initials,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: size * 0.34,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
            PositionedDirectional(
              end: -2,
              bottom: -2,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardSurface,
                  border: Border.all(color: AppColors.warmTravertine),
                ),
                child: Icon(
                  community.use == PropertyUse.residential
                      ? Icons.home_rounded
                      : Icons.business_center_rounded,
                  size: 13,
                  color: AppColors.duskBlue,
                ),
              ),
            ),
          ],
        ),
      );
}
