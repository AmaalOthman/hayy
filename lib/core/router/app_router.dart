import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/pending_approval_page.dart';
import '../../features/auth/presentation/pages/phone_login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/communities/presentation/pages/home_page.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // Re-run redirects whenever the auth state changes.
  final authChanges = ValueNotifier<int>(0);
  ref.listen(authControllerProvider, (_, _) => authChanges.value++);

  final router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: authChanges,
    redirect: (context, state) =>
        authRedirect(ref.read(authControllerProvider), state.matchedLocation),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (context, state) => _fade(state, const SplashPage()),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) => _fade(state, const PhoneLoginPage()),
      ),
      GoRoute(
        path: RouteNames.otp,
        // The phone number comes from the login page; without it, go back.
        redirect: (context, state) =>
            state.extra is String ? null : RouteNames.login,
        builder: (context, state) =>
            OtpVerificationPage(phone: state.extra! as String),
      ),
      GoRoute(
        path: RouteNames.pendingApproval,
        pageBuilder: (context, state) =>
            _fade(state, const PendingApprovalPage()),
      ),
      GoRoute(
        path: RouteNames.home,
        pageBuilder: (context, state) => _fade(state, const HomePage()),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    authChanges.dispose();
  });
  return router;
});

/// Where a user in [auth] may be. Returns null to stay on [location].
@visibleForTesting
String? authRedirect(AuthState auth, String location) {
  // The splash navigates itself once its intro and the session check finish.
  if (location == RouteNames.splash) return null;

  const signedOutRoutes = {RouteNames.login, RouteNames.otp};
  return switch (auth) {
    AuthUnknown() => RouteNames.splash,
    Unauthenticated() =>
      signedOutRoutes.contains(location) ? null : RouteNames.login,
    Authenticated(:final session) when !session.isApproved =>
      location == RouteNames.pendingApproval
          ? null
          : RouteNames.pendingApproval,
    Authenticated() => signedOutRoutes.contains(location) ||
            location == RouteNames.pendingApproval
        ? RouteNames.home
        : null,
  };
}

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );
