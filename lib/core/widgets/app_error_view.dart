import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../error/failure_l10n.dart';
import '../error/failures.dart';
import '../theme/theme.dart';

/// Full-area error with a retry button, for screens whose data failed to load.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, required this.onRetry});

  /// Usually a [Failure]; anything else shows the generic message.
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = this.error;
    final isOffline = error is NetworkFailure;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              size: 48,
              color: AppColors.mutedCopper,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              error is Failure ? error.localized(l10n) : l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
