import '../../../l10n/app_localizations.dart';
import '../domain/entities/community.dart';

extension TransactionTypeL10n on TransactionType {
  String label(AppLocalizations l10n) => switch (this) {
        TransactionType.sale => l10n.transactionSale,
        TransactionType.rental => l10n.transactionRental,
      };
}

extension PropertyUseL10n on PropertyUse {
  String label(AppLocalizations l10n) => switch (this) {
        PropertyUse.residential => l10n.useResidential,
        PropertyUse.commercial => l10n.useCommercial,
      };
}

extension CommunityL10n on Community {
  /// "Sale · Residential"
  String typeLabel(AppLocalizations l10n) =>
      '${transaction.label(l10n)} · ${use.label(l10n)}';

  /// "Dubai Marina – Rental – Residential", as in the brief.
  String fullName(AppLocalizations l10n) =>
      '$areaName – ${transaction.label(l10n)} – ${use.label(l10n)}';
}
