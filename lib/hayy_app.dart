import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/api_endpoints.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme.dart';
import 'l10n/app_localizations.dart';

class HayyApp extends ConsumerWidget {
  const HayyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router, locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: ApiEndpoints.useMockApi
          ? (context, child) => Stack(
                children: [child!, const _MockApiLabel()],
              )
          : null,
    );
  }
}

/// Tiny "MOCK API" pill under the status bar so a mock build is never
/// mistaken for the real backend. Ignores touches; covers no controls.
class _MockApiLabel extends StatelessWidget {
  const _MockApiLabel();

  @override
  Widget build(BuildContext context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 2,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.ink.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                child: Text(
                  'MOCK API',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
