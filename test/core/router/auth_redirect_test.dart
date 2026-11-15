import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/router/app_router.dart';
import 'package:hayy/core/router/route_names.dart';
import 'package:hayy/features/auth/domain/entities/auth_session.dart';
import 'package:hayy/features/auth/presentation/providers/auth_state.dart';

Authenticated _broker(BrokerStatus status, {bool hasProfile = true}) =>
    Authenticated(AuthSession(
      brokerId: '1',
      phone: '+971501234567',
      status: status,
      hasProfile: hasProfile,
    ));

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
    expect(authRedirect(s, RouteNames.completeProfile), RouteNames.login);
    expect(authRedirect(s, RouteNames.pendingApproval), RouteNames.login);
  });

  test('new broker must complete the profile first', () {
    final s = _broker(BrokerStatus.pending, hasProfile: false);
    expect(authRedirect(s, RouteNames.otp), RouteNames.completeProfile);
    expect(authRedirect(s, RouteNames.home), RouteNames.completeProfile);
    expect(authRedirect(s, RouteNames.pendingApproval),
        RouteNames.completeProfile);
    expect(authRedirect(s, RouteNames.completeProfile), isNull);
  });

  test('pending or suspended brokers are held on the approval page', () {
    for (final status in [BrokerStatus.pending, BrokerStatus.suspended]) {
      final s = _broker(status);
      expect(authRedirect(s, RouteNames.home), RouteNames.pendingApproval);
      expect(authRedirect(s, RouteNames.completeProfile),
          RouteNames.pendingApproval);
      expect(authRedirect(s, RouteNames.pendingApproval), isNull);
    }
  });

  test('approved brokers skip onboarding screens', () {
    final s = _broker(BrokerStatus.approved);
    expect(authRedirect(s, RouteNames.home), isNull);
    for (final route in [
      RouteNames.login,
      RouteNames.otp,
      RouteNames.completeProfile,
      RouteNames.pendingApproval,
    ]) {
      expect(authRedirect(s, route), RouteNames.home);
    }
  });
}
