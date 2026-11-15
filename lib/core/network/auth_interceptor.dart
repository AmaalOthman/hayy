import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_endpoints.dart';
import '../services/secure_storage_service.dart';

/// Fires when the refresh token is rejected. The auth controller listens to
/// `.stream` and sends the user back to the login screen.
final sessionExpiredProvider = Provider<StreamController<void>>((ref) {
  final controller = StreamController<void>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});

/// Adds the bearer token, and on a 401 refreshes it once and retries.
///
/// It is a [QueuedInterceptor]: when several requests hit 401 together, only
/// the first refreshes; the rest see the new token and just retry.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required SecureStorageService storage,
    required Dio plainDio,
    required void Function() onSessionExpired,
  })  : _storage = storage,
        _plainDio = plainDio,
        _onSessionExpired = onSessionExpired;

  /// Put `Options(extra: {AuthInterceptor.skipAuth: true})` on public calls
  /// (send/verify OTP) so no token is attached and 401s aren't refreshed.
  static const String skipAuth = 'skipAuth';
  static const String _retried = 'authRetried';

  final SecureStorageService _storage;

  /// Dio without interceptors, used for refresh and retry. Retrying through
  /// the main Dio would deadlock the queue if the retry failed again.
  final Dio _plainDio;
  final void Function() _onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final token = await _storage.readAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        options.extra[skipAuth] == true ||
        options.extra[_retried] == true) {
      return handler.next(err);
    }

    var token = await _storage.readAccessToken();
    // Already logged out by an earlier request in the queue.
    if (token == null) return handler.next(err);

    // Only refresh if no earlier request has done it already.
    if (options.headers['Authorization'] == 'Bearer $token') {
      try {
        token = await _refresh();
      } on DioException {
        // Network trouble while refreshing: keep the session, report the error.
        return handler.next(err);
      }
      if (token == null) {
        await _storage.clearTokens();
        _onSessionExpired();
        return handler.next(err);
      }
    }

    options
      ..headers['Authorization'] = 'Bearer $token'
      ..extra[_retried] = true;
    try {
      handler.resolve(await _plainDio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  /// New access token, or null when the server rejects the refresh token.
  /// Throws [DioException] on network errors so the session isn't dropped.
  Future<String?> _refresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) return null;
    try {
      final response = await _plainDio.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final access = response.data?['accessToken'] as String?;
      if (access == null) return null;
      await _storage.saveTokens(
        accessToken: access,
        refreshToken: response.data?['refreshToken'] as String? ?? refreshToken,
      );
      return access;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 400 || status == 401 || status == 403) return null;
      rethrow;
    }
  }
}
