import 'dart:developer' as developer;

import 'failures.dart';

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

Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } catch (error, stackTrace) {
    developer.log('guard caught', error: error, stackTrace: stackTrace);
    return Err(Failure.fromException(error));
  }
}
