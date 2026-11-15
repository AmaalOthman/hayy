import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/broker_profile.dart';
import '../providers/profile_controller.dart';
import '../widgets/profile_header.dart';

/// Profile tab: how other brokers see you, plus edit and log out.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    return Scaffold(
      body: switch (profile) {
        AsyncData(:final value) => _ProfileView(profile: value),
        AsyncError(:final error) => SafeArea(
            child: AppErrorView(
              error: error,
              onRetry: () => ref.invalidate(profileControllerProvider),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView({required this.profile});
  final BrokerProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ProfileHeader(profile: profile),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Card(
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.phone_iphone_rounded,
                  label: l10n.phoneLabel,
                  value: profile.phone,
                ),
                const Divider(height: 1, indent: 56),
                _InfoRow(
                  icon: Icons.chat_outlined,
                  label: l10n.whatsappLabel,
                  value: profile.whatsappNumber ?? profile.phone,
                ),
                const Divider(height: 1, indent: 56),
                _InfoRow(
                  icon: Icons.apartment_rounded,
                  label: l10n.agencyLabel,
                  value: profile.agencyName ?? '',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => context.push(RouteNames.editProfile),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.editProfileTitle),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).logout(),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text(l10n.logout),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: AppColors.duskBlue),
      title: Text(label, style: text.bodySmall),
      subtitle: Text(
        // LRM keeps "+971..." in order inside Arabic text, still aligned
        // to the start of the row.
        value.startsWith('+') ? '‎$value' : value,
        style: text.titleSmall,
      ),
    );
  }
}
