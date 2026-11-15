import 'dart:developer' as developer;

import 'failures.dart';

/// Either a value ([Ok]) or a [Failure] ([Err]). Every repository method
/// returns one of these, so callers can't forget to handle errors.
///
/// ```dart
/// switch (await sendOtp(phone)) {
///   case Ok(:final value): ...
///   case Err(:final failure): ...
/// }
/// ```
sealed class Result<T> {
  const Result();

  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T value) onSuccess,
  ) =>
      switch (this) {
        Ok<T>(:final value) => onSuccess(value),
        Err<T>(:final failure) => onFailure(failure),
      };

  bool get isOk => this is Ok<T>;

  T? get valueOrNull => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(:final failure) => failure,
      };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

/// Runs [body] and wraps the outcome. Use in repositories:
/// `Future<Result<Post>> getPost(id) => guard(() => _remote.getPost(id));`
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } catch (error, stackTrace) {
    developer.log('guard caught', error: error, stackTrace: stackTrace);
    return Err(Failure.fromException(error));
  }
}
