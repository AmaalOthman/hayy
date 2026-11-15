import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hayy/core/services/secure_storage_service.dart';

typedef Reply = ({int status, Object? body});

/// Answers every HTTP call with [handler] and records the requests.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final Reply Function(RequestOptions options) handler;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final reply = handler(options);
    return ResponseBody.fromString(
      jsonEncode(reply.body),
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// In-memory token storage (the real one needs platform channels).
class FakeStorage implements SecureStorageService {
  FakeStorage({this.access, this.refresh});
  String? access;
  String? refresh;

  @override
  Future<String?> readAccessToken() async => access;
  @override
  Future<String?> readRefreshToken() async => refresh;
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> clearTokens() async => access = refresh = null;
}
