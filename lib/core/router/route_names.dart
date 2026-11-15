/// Route paths used by [GoRouter]. Keep every path here, never inline.
abstract final class RouteNames {
  // Onboarding
  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String completeProfile = '/complete-profile';
  static const String pendingApproval = '/pending-approval';

  // Bottom navigation tabs
  static const String home = '/home';
  static const String explore = '/explore';
  static const String myPosts = '/my-posts';
  static const String profile = '/profile';

  // Full-screen pages above the tabs
  static const String editProfile = '/profile/edit';
  static const String newPost = '/posts/new';
  static const String communityFeedPattern = '/communities/:id';
  static String communityFeed(String id) => '/communities/$id';
}
