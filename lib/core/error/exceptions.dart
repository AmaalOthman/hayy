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

  final String? code;

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
