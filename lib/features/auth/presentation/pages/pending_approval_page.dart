import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure_l10n.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_session.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_state.dart';

/// Shown while the admin hasn't approved the broker (or has suspended them).
/// Once approved, "Check status" updates the auth state and the router
/// redirect takes the broker home.
class PendingApprovalPage extends ConsumerStatefulWidget {
  const PendingApprovalPage({super.key});

  @override
  ConsumerState<PendingApprovalPage> createState() =>
      _PendingApprovalPageState();
}

class _PendingApprovalPageState extends ConsumerState<PendingApprovalPage> {
  bool _checking = false;

  Future<void> _checkStatus() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _checking = true);
    final failure =
        await ref.read(authControllerProvider.notifier).checkSession();
    if (!mounted) return;
    setState(() => _checking = false);

    final state = ref.read(authControllerProvider);
    if (failure != null) {
      messenger.showSnackBar(SnackBar(content: Text(failure.localized(l10n))));
    } else if (state is Authenticated && !state.session.isApproved) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.stillPending)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final suspended = switch (ref.watch(authControllerProvider)) {
      Authenticated(:final session) =>
        session.status == BrokerStatus.suspended,
      _ => false,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  _StatusRing(
                    icon: suspended
                        ? Icons.lock_outline_rounded
                        : Icons.hourglass_top_rounded,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    suspended ? l10n.suspendedTitle : l10n.pendingTitle,
                    style: text.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    suspended ? l10n.suspendedBody : l10n.pendingBody,
                    style: text.bodyLarge
                        ?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _checking ? null : _checkStatus,
                      child: _checking
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.white),
                            )
                          : Text(l10n.checkStatus),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: _checking
                        ? null
                        : () =>
                            ref.read(authControllerProvider.notifier).logout(),
                    child: Text(l10n.logout),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Large copper ring with a soft glow, echoing the brand swatches.
class _StatusRing extends StatelessWidget {
  const _StatusRing({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 120,
        height: 120,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.copperMetal,
          boxShadow: [
            BoxShadow(
              color: AppColors.mutedCopper.withValues(alpha: 0.25),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardSurface,
          ),
          child: Icon(icon, size: 48, color: AppColors.duskBlue),
        ),
      );
}
