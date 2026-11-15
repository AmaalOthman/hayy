import '../../l10n/app_localizations.dart';
import 'failures.dart';

extension FailureL10n on Failure {
String localized(AppLocalizations l10n) => switch (this) {
        NetworkFailure() => l10n.errorNetwork,
        UnauthorizedFailure() => l10n.errorSessionExpired,
        ServerFailure(statusCode: final status?) when status >= 500 =>
          l10n.errorGeneric,
        ServerFailure(:final message) ||
        ValidationFailure(:final message) ||
        ForbiddenFailure(:final message) =>
          message,
        CancelledFailure() || CacheFailure() || UnknownFailure() =>
          l10n.errorGeneric,
      };
}
