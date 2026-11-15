import 'package:equatable/equatable.dart';

import 'exceptions.dart';

/// What the domain and UI layers receive instead of exceptions.
/// `sealed`, so a `switch` over a Failure must handle every case.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  /// Maps anything thrown in the data layer to a Failure.
  factory Failure.fromException(Object error) => switch (error) {
        ServerException(statusCode: 400 || 422, :final message, :final code) =>
          ValidationFailure(message, code: code),
        ServerException e => ServerFailure(e.message,
            statusCode: e.statusCode, code: e.code, data: e.data),
        NetworkException e => NetworkFailure(e.message),
        UnauthorizedException e => UnauthorizedFailure(e.message),
        ForbiddenException e => ForbiddenFailure(e.message, code: e.code),
        CancelledException e => CancelledFailure(e.message),
        CacheException e => CacheFailure(e.message),
        _ => UnknownFailure(error.toString()),
      };

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode, this.code, this.data});

  final int? statusCode;
  final String? code;

  /// Raw error body, for extra fields such as `availableAt`.
  final Object? data;

  @override
  List<Object?> get props => [message, statusCode, code];
}

/// 400/422: the server rejected the input (e.g. repost before 3 days).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.code});
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Your session has expired']);
}

/// Signed in but not allowed: typically an account waiting for admin approval.
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message, {this.code});
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Request cancelled on purpose. UI should ignore it.
final class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Request cancelled']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
