import 'package:flutter/material.dart';

/// Hayy "Serenitas" palette.
/// Tokens marked (added) are not in the design file; they were derived to
/// keep text readable (WCAG AA) and to cover states the design doesn't show.
abstract final class AppColors {
  // Brand
  static const Color duskBlue = Color(0xFF3C4A6A);
  static const Color mutedCopper = Color(0xFFA87C63);
  static const Color desertSandstone = Color(0xFFE1CAB3);
  static const Color jadeGreen = Color(0xFF86B39E);
  static const Color warmTravertine = Color(0xFFD4BFAB);
  static const Color copperHighlight = Color(0xFFCBB5A8);

  // Surfaces and text
  static const Color appBackground = Color(0xFFFAF8F3);
  static const Color cardSurface = Color(0xFFF8F6F1);
  static const Color backgroundStart = Color(0xFFEBE0D2);
  static const Color backgroundEnd = Color(0xFFF6EFEB);
  static const Color ink = Color(0xFF1A212E);
  static const Color textSecondary = Color(0xFF5F6676); // (added)
  static const Color white = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = jadeGreen;
  static const Color error = Color(0xFFB3261E); // (added)

  // Post types: soft background + readable foreground (added)
  static const Color listingBg = Color(0xFFDDE3EE);
  static const Color listingFg = duskBlue;
  static const Color requestBg = Color(0xFFEFE0D5);
  static const Color requestFg = Color(0xFF7A5440);
  static const Color viewingBg = Color(0xFFDCEBE3);
  static const Color viewingFg = Color(0xFF3F6B57);

  // Quiet chip background (added)
  static const Color chipBg = Color(0xFFDCEBE3);
}
