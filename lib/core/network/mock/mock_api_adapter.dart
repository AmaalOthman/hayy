import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api_endpoints.dart';
import 'mock_communities.dart';

typedef _Reply = (int status, Object? body);

/// A fake backend that answers [ApiEndpoints] the way the real one should,
/// so the app can be built end to end before the API exists.
///
/// It replaces only Dio's transport: ApiClient, AuthInterceptor, datasources
/// and repositories all run their real code. Data is kept in
/// SharedPreferences, so it survives app restarts.
///
/// Test accounts:
/// - OTP code is always [validOtp].
/// - A new broker starts `pending` and is auto-approved [approvalDelay]
///   after completing the profile (simulates the admin).
/// - Numbers ending in `0000` are `suspended`.
class MockApiAdapter implements HttpClientAdapter {
  MockApiAdapter({
    this.latency = const Duration(milliseconds: 700),
    this.approvalDelay = const Duration(seconds: 10),
  });

  static const String validOtp = '123456';
  static const String _dbKey = 'mock_api_db';
  static const String _accessPrefix = 'mock-access.';
  static const String _refreshPrefix = 'mock-refresh.';

  final Duration latency;
  final Duration approvalDelay;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(latency);
    final prefs = await SharedPreferences.getInstance();
    final db = _Db.decode(prefs.getString(_dbKey));

    final (status, body) = await _route(options, db);

    await prefs.setString(_dbKey, db.encode());
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}

  Future<_Reply> _route(RequestOptions o, _Db db) async {
    switch ((o.method, o.path)) {
      case ('POST', ApiEndpoints.sendOtp):
        final phone = _json(o)['phone'];
        if (phone is! String || phone.isEmpty) {
          return _error(422, 'Phone number is required', 'invalid_phone');
        }
        return (200, {'sent': true});

      case ('POST', ApiEndpoints.verifyOtp):
        final body = _json(o);
        final phone = body['phone'] as String?;
        if (phone == null) {
          return _error(422, 'Phone number is required', 'invalid_phone');
        }
        if (body['code'] != validOtp) {
          return _error(422, 'Invalid code. Use $validOtp', 'invalid_otp');
        }
        final broker = db.brokers.putIfAbsent(phone, () => _newBroker(phone));
        return (200, {..._tokens(phone), 'broker': _publicBroker(broker)});

      case ('POST', ApiEndpoints.refreshToken):
        final token = _json(o)['refreshToken'];
        if (token is! String || !token.startsWith(_refreshPrefix)) {
          return _error(401, 'Invalid refresh token', 'invalid_token');
        }
        return (200, _tokens(token.substring(_refreshPrefix.length)));

      case ('POST', ApiEndpoints.logout):
        return (200, {'ok': true});

      case ('GET', ApiEndpoints.me):
        final broker = _authorizedBroker(o, db);
        if (broker == null) return _error(401, 'Unauthorized', 'unauthorized');
        return (200, _publicBroker(broker));

      case ('PUT', ApiEndpoints.me):
        final broker = _authorizedBroker(o, db);
        if (broker == null) return _error(401, 'Unauthorized', 'unauthorized');
        return _updateProfile(o, broker);
    }

    final broker = _authorizedBroker(o, db);
    if (broker != null) {
      final reply = MockCommunities.handle(o, broker);
      if (reply != null) return reply;
    }
    return _error(404, 'Mock API: no handler for ${o.method} ${o.path}',
        'not_found');
  }

  Future<_Reply> _updateProfile(
      RequestOptions o, Map<String, dynamic> broker) async {
    final fields = <String, String>{};
    String? photoUrl;

    final data = o.data;
    if (data is FormData) {
      fields.addEntries(data.fields);
      for (final file in data.files) {
        if (file.key != 'photo') continue;
        // Dio already consumed the original stream; read a fresh copy.
        final copy = file.value.clone();
        final bytes = await copy
            .finalize()
            .fold<BytesBuilder>(BytesBuilder(), (b, chunk) => b..add(chunk));
        final mime = copy.contentType?.mimeType ?? 'image/jpeg';
        photoUrl = 'data:$mime;base64,${base64Encode(bytes.takeBytes())}';
      }
    } else if (data is Map) {
      data.forEach((k, v) => fields['$k'] = '$v');
    }

    for (final key in ['fullName', 'agencyName', 'whatsappNumber']) {
      final value = fields[key]?.trim();
      if (value == null || value.isEmpty) {
        return _error(422, '$key is required', 'invalid_$key');
      }
      broker[key] = value;
    }
    if (photoUrl != null) broker['photoUrl'] = photoUrl;
    broker['profileCompletedAt'] ??= DateTime.now().millisecondsSinceEpoch;
    return (200, _publicBroker(broker));
  }

  Map<String, dynamic>? _authorizedBroker(RequestOptions o, _Db db) {
    final header = o.headers['Authorization'] as String?;
    const bearer = 'Bearer $_accessPrefix';
    if (header == null || !header.startsWith(bearer)) return null;
    return db.brokers[header.substring(bearer.length)];
  }

  /// What the real API would return: no internal fields, approval applied.
  Map<String, dynamic> _publicBroker(Map<String, dynamic> broker) {
    final completedAt = broker['profileCompletedAt'] as int?;
    if (broker['status'] == 'pending' &&
        completedAt != null &&
        DateTime.now().millisecondsSinceEpoch - completedAt >=
            approvalDelay.inMilliseconds) {
      broker['status'] = 'approved';
    }
    return {
      'id': broker['id'],
      'phone': broker['phone'],
      'status': broker['status'],
      'profileCompleted': completedAt != null,
      'fullName': broker['fullName'],
      'agencyName': broker['agencyName'],
      'whatsappNumber': broker['whatsappNumber'],
      'photoUrl': broker['photoUrl'],
    };
  }

  static Map<String, dynamic> _newBroker(String phone) => {
        'id': 'mock-${phone.replaceAll('+', '')}',
        'phone': phone,
        'status': phone.endsWith('0000') ? 'suspended' : 'pending',
      };

  static Map<String, String> _tokens(String phone) => {
        'accessToken': '$_accessPrefix$phone',
        'refreshToken': '$_refreshPrefix$phone',
      };

  static Map<String, dynamic> _json(RequestOptions o) =>
      o.data is Map ? Map<String, dynamic>.from(o.data as Map) : const {};

  static _Reply _error(int status, String message, String code) =>
      (status, {'message': message, 'code': code});
}

class _Db {
  _Db(this.brokers);

  factory _Db.decode(String? raw) {
    if (raw == null) return _Db({});
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final brokers = (json['brokers'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
    return _Db(brokers);
  }

  /// Keyed by phone number (E.164).
  final Map<String, Map<String, dynamic>> brokers;

  String encode() => jsonEncode({'brokers': brokers});
}
