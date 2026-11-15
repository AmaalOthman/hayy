import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    local: ref.watch(authLocalDataSourceProvider),
  ),
);

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<void>> sendOtp(String phone) =>
      guard(() => _remote.sendOtp(phone));

  @override
  Future<Result<AuthSession>> verifyOtp({
    required String phone,
    required String code,
  }) =>
      guard(() async {
        final model = await _remote.verifyOtp(phone, code);
        await _local.saveTokens(model.accessToken, model.refreshToken);
        return model.broker.toEntity();
      });

  @override
  Future<Result<AuthSession?>> getCurrentSession() async {
    if (!await _local.hasSession()) return const Ok(null);

    final result = await guard(() => _remote.getMe());
    return switch (result) {
      Ok(:final value) => Ok(value.toEntity()),
      // Refresh token rejected: the interceptor already cleared the tokens.
      Err(failure: UnauthorizedFailure()) => const Ok(null),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<void>> logout() async {
    await guard(() => _remote.logout());
    return guard(() => _local.clear());
  }
}
