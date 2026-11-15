import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Unread count pill. Dusk blue with white text (≈9:1 contrast); grey when
/// the community is muted, like WhatsApp.
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count, this.muted = false});

  final int count;
  final bool muted;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: muted ? AppColors.warmTravertine : AppColors.duskBlue,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          count > 99 ? '99+' : '$count',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: muted ? AppColors.ink : AppColors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
}
