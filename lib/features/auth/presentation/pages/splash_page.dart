import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_controller.dart';

const String hayyLogoHeroTag = 'hayy-logo';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );

  bool _started = false;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    precacheImage(const AssetImage(AppAssets.heroBackground), context);
    precacheImage(const AssetImage(AppAssets.logo), context);
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
      _ambient.value = 1;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final session = ref.read(authControllerProvider.notifier).checkSession();
    _ambient.forward();
    try {
      await _intro.forward().orCancel;
    } on TickerCanceled {
      return; 
    }
    _finish(await session == null);
  }

  Future<void> _retry() async {
    setState(() => _failed = false);
    _finish(await ref.read(authControllerProvider.notifier).checkSession() ==
        null);
  }

  void _finish(bool ok) {
    if (!mounted) return;
    ok ? context.go(RouteNames.home) : setState(() => _failed = true);
  }

  @override
  void dispose() {
    _intro.dispose();
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: AnimatedBuilder(
          animation: Listenable.merge([_intro, _ambient]),
          builder: (context, _) {
            final t = _intro.value;
            double phase(double from, double to,
                    [Curve curve = Curves.easeOutCubic]) =>
                curve.transform(((t - from) / (to - from)).clamp(0.0, 1.0));

            final photoIn = phase(0.0, 0.40, Curves.easeOut);
            final logoIn = phase(0.15, 0.55);
            final sweep = phase(0.52, 0.86, Curves.easeInOut);
            final lineIn = phase(0.62, 0.82);
            final taglineIn = phase(0.70, 0.96);
            final zoom =
                1.14 - 0.08 * Curves.easeOutSine.transform(_ambient.value);

            return Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: photoIn,
                  child: Transform.scale(
                    scale: zoom,
                    alignment: const Alignment(0, -0.3),
                    child: Image.asset(
                      AppAssets.heroBackground,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: _scrim),
                ),
                _CopperGlow(opacity: logoIn),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 5),
                      _AnimatedLogo(appear: logoIn, sweep: sweep),
                      const SizedBox(height: AppSpacing.xl),
                      Container(
                        width: 64 * lineIn,
                        height: 1.5,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.copperMetal,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Opacity(
                        opacity: taglineIn,
                        child: Transform.translate(
                          offset: Offset(0, 12 * (1 - taglineIn)),
                          child: Text(
                            isRtl
                                ? l10n.splashTagline
                                : l10n.splashTagline.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: AppColors.desertSandstone,
                                  // Letter spacing breaks joined Arabic letters.
                                  letterSpacing: isRtl ? 0 : 3.2,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 4),
                      SizedBox(
                        height: 96,
                        child: _failed
                            ? _OfflineRetry(onRetry: _retry)
                            : _intro.isCompleted
                                ? const _CopperProgress()
                                : null,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static const LinearGradient _scrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x991A212E),
      Color(0x661A212E),
      Color(0xBF1A212E),
      Color(0xF51A212E),
    ],
    stops: [0.0, 0.38, 0.72, 1.0],
  );
}

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({required this.appear, required this.sweep});

  final double appear;
  final double sweep;

  @override
  Widget build(BuildContext context) {
    Widget logo = Image.asset(AppAssets.logo, width: 168);

    if (sweep > 0 && sweep < 1) {
      logo = ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: const Alignment(-1, -0.4),
          end: const Alignment(1, 0.4),
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0),
          ],
          stops: const [0.35, 0.5, 0.65],
          transform: _SlideGradient(-1.2 + 2.4 * sweep),
        ).createShader(bounds),
        child: logo,
      );
    }

    // Blur-to-focus as it appears.
    if (appear < 1) {
      final blur = (1 - appear) * 12;
      logo = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: logo,
      );
    }

    return Opacity(
      opacity: appear,
      child: Transform.scale(
        scale: 0.86 + 0.14 * appear,
        child: Hero(tag: hayyLogoHeroTag, child: logo),
      ),
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.percent);
  final double percent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * percent, 0, 0);
}

class _CopperGlow extends StatelessWidget {
  const _CopperGlow({required this.opacity});
  final double opacity;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Align(
          alignment: const Alignment(0, -0.18),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.mutedCopper.withValues(alpha: 0.30),
                  AppColors.mutedCopper.withValues(alpha: 0),
                ]),
              ),
            ),
          ),
        ),
      );
}

class _CopperProgress extends StatelessWidget {
  const _CopperProgress();

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: 96,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.mutedCopper,
              backgroundColor: AppColors.white.withValues(alpha: 0.12),
            ),
          ),
        ),
      );
}

class _OfflineRetry extends StatelessWidget {
  const _OfflineRetry({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            l10n.splashOffline,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.white.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.desertSandstone,
              minimumSize: const Size(140, 44),
            ),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
