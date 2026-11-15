import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

/// Temporary home so the auth flow has a destination. The subscribed
/// communities list replaces this body in the communities feature.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(gradient: AppGradients.header),
        ),
        actions: [
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          l10n.homeEmpty,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
