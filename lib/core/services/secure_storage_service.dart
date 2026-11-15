import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(const FlutterSecureStorage()),
);

/// Auth tokens live here (Keychain on iOS, Keystore-backed on Android,
/// WebCrypto + localStorage on web).
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() => _read(StorageKeys.accessToken);

  Future<String?> readRefreshToken() => _read(StorageKeys.refreshToken);

  /// Writes one after the other on purpose: on web, the first write creates
  /// the encryption key, and two parallel first writes each create their own
  /// key, leaving one value undecryptable (WebCrypto "OperationError").
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  /// A value that can't be decrypted (wiped Keystore after a restore, a
  /// changed web key) is useless: drop everything and treat the user as
  /// signed out, instead of failing every request.
  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      developer.log('Unreadable secure storage, clearing', error: error);
      try {
        await _storage.deleteAll();
      } catch (_) {
        // Nothing more we can do; reads will keep returning null.
      }
      return null;
    }
  }
}
