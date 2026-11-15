import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';
import '../services/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'mock/mock_api_adapter.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final sessionExpired = ref.watch(sessionExpiredProvider);
  final client = ApiClient.create(
    storage: ref.watch(secureStorageServiceProvider),
    onSessionExpired: () => sessionExpired.add(null),
    adapter: ApiEndpoints.useMockApi ? MockApiAdapter() : null,
  );
  ref.onDispose(client.close);
  return client;
});

class ApiClient {
  ApiClient._(this._dio, this._plainDio);

  factory ApiClient.create({
    required SecureStorageService storage,
    required void Function() onSessionExpired,
    String baseUrl = ApiEndpoints.baseUrl,
    HttpClientAdapter? adapter, // mock backend or a test fake
  }) {
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      sendTimeout: AppConstants.sendTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json'},
    );

    final plainDio = Dio(baseOptions);
    final dio = Dio(baseOptions);
    if (adapter != null) {
      plainDio.httpClientAdapter = adapter;
      dio.httpClientAdapter = adapter;
    }

    dio.interceptors.add(AuthInterceptor(
      storage: storage,
      plainDio: plainDio,
      onSessionExpired: onSessionExpired,
    ));
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (line) => debugPrint(line.toString()),
      ));
    }
    return ApiClient._(dio, plainDio);
  }

  final Dio _dio;
  final Dio _plainDio;

  /// Set `auth: false` for public endpoints (send/verify OTP).
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
    CancelToken? cancelToken,
  }) =>
      _send(() => _dio.get<T>(path,
          queryParameters: query,
          options: _options(auth),
          cancelToken: cancelToken));

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool auth = true,
    CancelToken? cancelToken,
  }) =>
      _send(() => _dio.post<T>(path,
          data: data,
          queryParameters: query,
          options: _options(auth),
          cancelToken: cancelToken));

  Future<T> put<T>(
    String path, {
    Object? data,
    bool auth = true,
    CancelToken? cancelToken,
  }) =>
      _send(() => _dio.put<T>(path,
          data: data, options: _options(auth), cancelToken: cancelToken));

  Future<T> patch<T>(
    String path, {
    Object? data,
    bool auth = true,
    CancelToken? cancelToken,
  }) =>
      _send(() => _dio.patch<T>(path,
          data: data, options: _options(auth), cancelToken: cancelToken));

  Future<T> delete<T>(
    String path, {
    Object? data,
    bool auth = true,
    CancelToken? cancelToken,
  }) =>
      _send(() => _dio.delete<T>(path,
          data: data, options: _options(auth), cancelToken: cancelToken));

  void close() {
    _dio.close();
    _plainDio.close();
  }

  static Options _options(bool auth) =>
      Options(extra: {AuthInterceptor.skipAuth: !auth});

  static Future<T> _send<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  static AppException _mapError(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout ||
        DioExceptionType.connectionError =>
          const NetworkException(),
        DioExceptionType.cancel => const CancelledException(),
        DioExceptionType.badCertificate =>
          const ServerException('Secure connection failed'),
        DioExceptionType.badResponse => _mapResponse(e.response),
        DioExceptionType.unknown =>
          ServerException(e.message ?? 'Unexpected error'),
      };

  /// Expects error bodies like `{"message": "...", "code": "..."}`.
  static AppException _mapResponse(Response<dynamic>? response) {
    final body = response?.data;
    final message =
        body is Map ? body['message']?.toString() : null;
    final code = body is Map ? body['code']?.toString() : null;

    return switch (response?.statusCode) {
      401 => UnauthorizedException(message ?? 'Your session has expired'),
      403 => ForbiddenException(message ?? 'Not allowed', code),
      final status => ServerException(
          message ?? 'Something went wrong',
          statusCode: status,
          code: code,
          data: body,
        ),
    };
  }
}
