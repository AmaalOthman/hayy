import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppGradients {
  /// Calm app background.
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
  );

  /// Metallic copper frame for rings and borders.
  static const LinearGradient copperMetal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.mutedCopper,
      AppColors.copperHighlight,
      AppColors.mutedCopper,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Header: dusk blue fading to copper (inferred from the design) (added).
  static const LinearGradient header = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.duskBlue, AppColors.mutedCopper],
  );
}

/// Wrap a screen body with the gradient background.
/// Use with `Scaffold(backgroundColor: Colors.transparent, ...)`.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: child,
      );
}
