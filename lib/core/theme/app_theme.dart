import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static const ColorScheme _scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.duskBlue,
    onPrimary: AppColors.white,
    secondary: AppColors.mutedCopper,
    onSecondary: AppColors.ink,
    tertiary: AppColors.jadeGreen,
    onTertiary: AppColors.ink,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.cardSurface,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.warmTravertine,
    outlineVariant: AppColors.desertSandstone,
    surfaceContainerHighest: AppColors.desertSandstone,
  );

  static ThemeData get light {
    final text = AppTextStyles.textTheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: _scheme,
      scaffoldBackgroundColor: AppColors.appBackground,
      textTheme: text,
      fontFamily: AppTextStyles.fontFamily,
      fontFamilyFallback: AppTextStyles.fontFallback,
      dividerColor: AppColors.warmTravertine,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.duskBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: AppColors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: const BorderSide(color: AppColors.warmTravertine),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBg,
        selectedColor: AppColors.mutedCopper,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        showCheckmark: false,
        labelStyle: text.labelMedium,
        secondaryLabelStyle: text.labelMedium,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardSurface,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        hintStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.warmTravertine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.warmTravertine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.duskBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.duskBlue,
          foregroundColor: AppColors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.duskBlue,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: AppColors.mutedCopper),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.duskBlue,
          textStyle: text.labelLarge,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.mutedCopper,
        foregroundColor: AppColors.ink,
        elevation: 2,
        shape: StadiumBorder(),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardSurface,
        indicatorColor: AppColors.desertSandstone,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) =>
            text.labelSmall?.copyWith(
              color: states.contains(WidgetState.selected)
                  ? AppColors.duskBlue
                  : AppColors.textSecondary,
            )),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.duskBlue
                  : AppColors.textSecondary,
            )),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.duskBlue,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
    );
  }
}
