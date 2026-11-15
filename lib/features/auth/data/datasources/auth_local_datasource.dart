import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/secure_storage_service.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
    (ref) => AuthLocalDataSource(ref.watch(secureStorageServiceProvider)));

class AuthLocalDataSource {
  const AuthLocalDataSource(this._storage);
  final SecureStorageService _storage;

  Future<bool> hasSession() async =>
      await _storage.readRefreshToken() != null;

  Future<void> saveTokens(String accessToken, String refreshToken) =>
      _storage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);

  Future<void> clear() => _storage.clearTokens();
}
