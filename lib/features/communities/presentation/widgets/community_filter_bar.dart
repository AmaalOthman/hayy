import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/community_filter.dart';
import '../community_labels.dart';

/// [All] [Sale] [Rental] | [Residential] [Commercial]
/// Tapping a selected chip clears that dimension.
class CommunityFilterBar extends StatelessWidget {
  const CommunityFilterBar({
    super.key,
    required this.filter,
    required this.onTransactionChanged,
    required this.onUseChanged,
  });

  final CommunityFilter filter;
  final ValueChanged<TransactionType?> onTransactionChanged;
  final ValueChanged<PropertyUse?> onUseChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final noFilter = filter.transaction == null && filter.use == null;

    Widget chip(String label, bool selected, VoidCallback onTap) => Padding(
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
          child: ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onTap(),
          ),
        );

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        children: [
          chip(l10n.filterAll, noFilter, () {
            onTransactionChanged(null);
            onUseChanged(null);
          }),
          for (final t in TransactionType.values)
            chip(t.label(l10n), filter.transaction == t,
                () => onTransactionChanged(filter.transaction == t ? null : t)),
          const Padding(
            padding: EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: VerticalDivider(
                width: 1, indent: 10, endIndent: 10,
                color: AppColors.warmTravertine),
          ),
          for (final u in PropertyUse.values)
            chip(u.label(l10n), filter.use == u,
                () => onUseChanged(filter.use == u ? null : u)),
        ],
      ),
    );
  }
}
