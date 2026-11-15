import 'package:flutter/foundation.dart';

abstract final class ApiEndpoints {
 static const bool useMockApi =
      bool.fromEnvironment('USE_MOCK_API', defaultValue: !kReleaseMode);

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api/v1',
  );

  // Auth 
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Profile
  static const String me = '/me';

  // Communities
  static const String communities = '/communities';
  static const String subscribedCommunities = '/me/communities';
  static String subscription(String communityId) =>
      '/communities/$communityId/subscription';
  static String mute(String communityId) => '/communities/$communityId/mute';

  // Predefined post options
  static const String areas = '/options/areas';
  static String buildings(String areaId) => '/options/areas/$areaId/buildings';
  static const String sizeRanges = '/options/size-ranges';
  static const String floorRanges = '/options/floor-ranges';

  // Posts
  static String communityPosts(String communityId) =>
      '/communities/$communityId/posts';
  static const String posts = '/posts';
  static String post(String postId) => '/posts/$postId';
  static String repost(String postId) => '/posts/$postId/repost';
  static String closePost(String postId) => '/posts/$postId/close';
  static String replies(String postId) => '/posts/$postId/replies';
  static String report(String postId) => '/posts/$postId/report';
  static const String myPosts = '/me/posts';

  // Notifications
  static const String deviceTokens = '/me/device-tokens';
}
