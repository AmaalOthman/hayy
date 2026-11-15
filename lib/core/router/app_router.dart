import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/pending_approval_page.dart';
import '../../features/auth/presentation/pages/phone_login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/communities/presentation/pages/explore_communities_page.dart';
import '../../features/communities/presentation/pages/home_page.dart';
import '../../features/posts/presentation/pages/community_feed_page.dart';
import '../../features/posts/presentation/pages/create_post_page.dart';
import '../../features/posts/presentation/pages/my_posts_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/shell/presentation/pages/main_shell_page.dart';
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
        path: RouteNames.completeProfile,
        pageBuilder: (context, state) =>
            _fade(state, const EditProfilePage(isOnboarding: true)),
      ),
      GoRoute(
        path: RouteNames.pendingApproval,
        pageBuilder: (context, state) =>
            _fade(state, const PendingApprovalPage()),
      ),
      // Bottom navigation: each tab keeps its own stack and scroll position.
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, shell) =>
            _fade(state, MainShellPage(shell: shell)),
        branches: [
          _tab(RouteNames.home, const HomePage()),
          _tab(RouteNames.explore, const ExploreCommunitiesPage()),
          _tab(RouteNames.myPosts, const MyPostsPage()),
          _tab(RouteNames.profile, const ProfilePage()),
        ],
      ),
      // Full-screen pages pushed above the tabs (no bottom bar).
      GoRoute(
        path: RouteNames.communityFeedPattern,
        builder: (context, state) =>
            CommunityFeedPage(communityId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.newPost,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const CreatePostPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
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
  const onboardingRoutes = {
    ...signedOutRoutes,
    RouteNames.completeProfile,
    RouteNames.pendingApproval,
  };
  String? only(String route) => location == route ? null : route;

  // Sign up → complete profile → admin approval → app.
  return switch (auth) {
    AuthUnknown() => RouteNames.splash,
    Unauthenticated() =>
      signedOutRoutes.contains(location) ? null : RouteNames.login,
    Authenticated(:final session) when !session.hasProfile =>
      only(RouteNames.completeProfile),
    Authenticated(:final session) when !session.isApproved =>
      only(RouteNames.pendingApproval),
    Authenticated() =>
      onboardingRoutes.contains(location) ? RouteNames.home : null,
  };
}

StatefulShellBranch _tab(String path, Widget page) => StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (context, state) => page)],
    );

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
