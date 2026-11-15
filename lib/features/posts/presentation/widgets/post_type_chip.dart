import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/post_type.dart';

extension PostTypeL10n on PostType {
  String label(AppLocalizations l10n) => switch (this) {
        PostType.listing => l10n.postTypeListing,
        PostType.request => l10n.postTypeRequest,
        PostType.viewing => l10n.postTypeViewing,
      };

  /// Soft background + readable foreground from the palette.
  (Color bg, Color fg) get colors => switch (this) {
        PostType.listing => (AppColors.listingBg, AppColors.listingFg),
        PostType.request => (AppColors.requestBg, AppColors.requestFg),
        PostType.viewing => (AppColors.viewingBg, AppColors.viewingFg),
      };
}

/// Small tag: "Listing", "Request" or "Viewing", colour-coded.
class PostTypeChip extends StatelessWidget {
  const PostTypeChip({super.key, required this.type, this.dense = false});

  final PostType type;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = type.colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 6 : AppSpacing.sm,
        vertical: dense ? 1 : 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.label(AppLocalizations.of(context)),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: dense ? 10 : 11,
            ),
      ),
    );
  }
}
