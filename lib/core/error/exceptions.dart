/// Thrown by the data layer only. Repositories catch these (through `guard`)
/// and turn them into `Failure`s, so domain and presentation never see them.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The server answered with an error status (other than 401/403).
final class ServerException extends AppException {
  const ServerException(
    super.message, {
    this.statusCode,
    this.code,
    this.data,
  });

  final int? statusCode;

  /// Machine-readable code from the backend, e.g. `repost_cooldown`.
  final String? code;

  /// Raw error body, for extra fields such as `availableAt`.
  final Object? data;
}

/// No connection, DNS failure or timeout.
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// 401 that survived a token refresh: the session is over.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Your session has expired']);
}

/// 403: signed in but not allowed, e.g. broker not approved by admin yet.
final class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Not allowed', this.code]);
  final String? code;
}

/// The request was cancelled on purpose (CancelToken). Not shown to users.
final class CancelledException extends AppException {
  const CancelledException([super.message = 'Request cancelled']);
}

/// Local storage read/write failed.
final class CacheException extends AppException {
  const CacheException([super.message = 'Local storage error']);
}
