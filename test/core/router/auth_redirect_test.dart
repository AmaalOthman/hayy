import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/router/app_router.dart';
import 'package:hayy/core/router/route_names.dart';
import 'package:hayy/features/auth/domain/entities/auth_session.dart';
import 'package:hayy/features/auth/presentation/providers/auth_state.dart';

Authenticated _broker(BrokerStatus status) => Authenticated(
    AuthSession(brokerId: '1', phone: '+971501234567', status: status));

void main() {
  test('splash is never redirected', () {
    expect(authRedirect(const AuthUnknown(), RouteNames.splash), isNull);
    expect(authRedirect(const Unauthenticated(), RouteNames.splash), isNull);
  });

  test('unknown state goes back to splash', () {
    expect(authRedirect(const AuthUnknown(), RouteNames.home),
        RouteNames.splash);
  });

  test('signed out: only login and otp', () {
    const s = Unauthenticated();
    expect(authRedirect(s, RouteNames.login), isNull);
    expect(authRedirect(s, RouteNames.otp), isNull);
    expect(authRedirect(s, RouteNames.home), RouteNames.login);
    expect(authRedirect(s, RouteNames.pendingApproval), RouteNames.login);
  });

  test('pending or suspended brokers are held on the approval page', () {
    for (final status in [BrokerStatus.pending, BrokerStatus.suspended]) {
      final s = _broker(status);
      expect(authRedirect(s, RouteNames.home), RouteNames.pendingApproval);
      expect(authRedirect(s, RouteNames.otp), RouteNames.pendingApproval);
      expect(authRedirect(s, RouteNames.pendingApproval), isNull);
    }
  });

  test('approved brokers skip auth screens', () {
    final s = _broker(BrokerStatus.approved);
    expect(authRedirect(s, RouteNames.home), isNull);
    expect(authRedirect(s, RouteNames.login), RouteNames.home);
    expect(authRedirect(s, RouteNames.otp), RouteNames.home);
    expect(authRedirect(s, RouteNames.pendingApproval), RouteNames.home);
  });
}
