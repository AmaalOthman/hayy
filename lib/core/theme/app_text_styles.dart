import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Declare both families in pubspec.yaml.
/// A missing font falls back to the system font without crashing.
abstract final class AppTextStyles {
  static const String fontFamily = 'PlusJakartaSans';
  static const List<String> fontFallback = ['IBMPlexSansArabic'];

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    color: AppColors.ink,
    height: 1.35,
  );

  static final TextTheme textTheme = TextTheme(
    headlineMedium: _base.copyWith(fontSize: 26, fontWeight: FontWeight.w700),
    titleLarge: _base.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
    titleMedium: _base.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    titleSmall: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    bodyLarge: _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: _base.copyWith(
        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
    labelLarge: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    labelMedium: _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: _base.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
  );
}
