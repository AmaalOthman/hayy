import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_text_styles.dart';

/// Use with FilledButton(style: AppButtonStyles.whatsapp, ...).
abstract final class AppButtonStyles {
  static ButtonStyle get _base => FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        textStyle: AppTextStyles.textTheme.labelLarge,
        elevation: 0,
      );

  /// Jade green WhatsApp action. Ink text keeps contrast above 6:1
  /// (white on jade is only about 2.3:1).
  static ButtonStyle get whatsapp => _base.copyWith(
        backgroundColor: const WidgetStatePropertyAll(AppColors.jadeGreen),
        foregroundColor: const WidgetStatePropertyAll(AppColors.ink),
      );

  /// Copper secondary action (Reply, Edit).
  static ButtonStyle get secondary => _base.copyWith(
        backgroundColor: const WidgetStatePropertyAll(AppColors.mutedCopper),
        foregroundColor: const WidgetStatePropertyAll(AppColors.ink),
      );

  /// Disabled-looking style, e.g. Repost before the 3-day rule passes.
  static ButtonStyle get disabled => _base.copyWith(
        backgroundColor: const WidgetStatePropertyAll(AppColors.warmTravertine),
        foregroundColor: const WidgetStatePropertyAll(AppColors.textSecondary),
      );
}
