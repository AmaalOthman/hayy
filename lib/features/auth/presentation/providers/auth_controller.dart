import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_state.dart';

final sendOtpProvider =
    Provider<SendOtp>((ref) => SendOtp(ref.watch(authRepositoryProvider)));
final verifyOtpProvider =
    Provider<VerifyOtp>((ref) => VerifyOtp(ref.watch(authRepositoryProvider)));
final getCurrentSessionProvider = Provider<GetCurrentSession>(
    (ref) => GetCurrentSession(ref.watch(authRepositoryProvider)));
final logoutProvider =
    Provider<Logout>((ref) => Logout(ref.watch(authRepositoryProvider)));

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Single source of truth for "who is signed in". The router listens to it.
/// Actions return a [Failure] (or null on success) for the page to display.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final subscription = ref
        .watch(sessionExpiredProvider)
        .stream
        .listen((_) => state = const Unauthenticated());
    ref.onDispose(subscription.cancel);
    return const AuthUnknown();
  }

  /// Loads the stored session from the server. On failure the state is left
  /// unchanged, so the caller can offer a retry.
  Future<Failure?> checkSession() async {
    final result = await ref.read(getCurrentSessionProvider)(const NoParams());
    if (result case Ok(:final value)) {
      state = value == null ? const Unauthenticated() : Authenticated(value);
    }
    return result.failureOrNull;
  }

  Future<Failure?> sendOtp(String phone) async =>
      (await ref.read(sendOtpProvider)(phone)).failureOrNull;

  Future<Failure?> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final result = await ref
        .read(verifyOtpProvider)(VerifyOtpParams(phone: phone, code: code));
    if (result case Ok(:final value)) state = Authenticated(value);
    return result.failureOrNull;
  }

  Future<void> logout() async {
    await ref.read(logoutProvider)(const NoParams());
    state = const Unauthenticated();
  }
}
