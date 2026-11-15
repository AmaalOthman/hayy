import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/constants/api_endpoints.dart';
import 'package:hayy/core/error/exceptions.dart';
import 'package:hayy/core/error/failures.dart';
import 'package:hayy/core/error/result.dart';
import 'package:hayy/core/network/api_client.dart';
import '../../helpers/fakes.dart';

void main() {
  late FakeStorage storage;
  late int sessionExpiredCount;

  ApiClient clientWith(FakeAdapter adapter) => ApiClient.create(
        storage: storage,
        onSessionExpired: () => sessionExpiredCount++,
        baseUrl: 'https://test.local',
        adapter: adapter,
      );

  setUp(() {
    storage = FakeStorage(access: 'old', refresh: 'r1');
    sessionExpiredCount = 0;
  });

  test('returns the body and sends the bearer token', () async {
    final adapter = FakeAdapter((_) => (status: 200, body: {'ok': true}));
    final data = await clientWith(adapter).get<Map<String, dynamic>>('/me');

    expect(data, {'ok': true});
    expect(adapter.requests.single.headers['Authorization'], 'Bearer old');
  });

  test('auth: false sends no token', () async {
    final adapter = FakeAdapter((_) => (status: 200, body: {}));
    await clientWith(adapter).post<dynamic>(ApiEndpoints.sendOtp, auth: false);

    expect(adapter.requests.single.headers['Authorization'], isNull);
  });

  test('maps error bodies to ServerException with code', () async {
    final adapter = FakeAdapter((_) => (
          status: 422,
          body: {'message': 'Too soon', 'code': 'repost_cooldown'},
        ));

    final result =
        await guard(() => clientWith(adapter).post<dynamic>('/posts/1/repost'));

    expect(result.failureOrNull,
        const ValidationFailure('Too soon', code: 'repost_cooldown'));
  });

  test('maps 403 to ForbiddenException', () async {
    final adapter = FakeAdapter((_) => (
          status: 403,
          body: {'message': 'Pending approval', 'code': 'not_approved'},
        ));

    expect(
      () => clientWith(adapter).post<dynamic>('/posts'),
      throwsA(isA<ForbiddenException>()
          .having((e) => e.code, 'code', 'not_approved')),
    );
  });

  test('on 401 refreshes once and retries with the new token', () async {
    final adapter = FakeAdapter((o) {
      if (o.path == ApiEndpoints.refreshToken) {
        return (status: 200, body: {'accessToken': 'new', 'refreshToken': 'r2'});
      }
      return o.headers['Authorization'] == 'Bearer new'
          ? (status: 200, body: {'id': 1})
          : (status: 401, body: {'message': 'expired'});
    });

    final data = await clientWith(adapter).get<Map<String, dynamic>>('/me');

    expect(data, {'id': 1});
    expect(storage.access, 'new');
    expect(storage.refresh, 'r2');
    expect(adapter.requests.map((r) => r.path),
        ['/me', ApiEndpoints.refreshToken, '/me']);
    expect(sessionExpiredCount, 0);
  });

  test('when refresh is rejected, clears tokens and expires session',
      () async {
    final adapter = FakeAdapter((_) => (status: 401, body: {}));

    await expectLater(
      clientWith(adapter).get<dynamic>('/me'),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(storage.access, isNull);
    expect(sessionExpiredCount, 1);
  });
}
