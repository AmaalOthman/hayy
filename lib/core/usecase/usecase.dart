import '../error/result.dart';

/// One business action. Call it like a function: `await sendOtp(params)`.
abstract interface class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

/// A use case that keeps emitting, e.g. the realtime community feed.
abstract interface class StreamUseCase<T, P> {
  Stream<Result<T>> call(P params);
}

/// For use cases that take no input.
final class NoParams {
  const NoParams();
}
