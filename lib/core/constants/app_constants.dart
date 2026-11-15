abstract final class AppConstants {
  /// A post can be reposted once this has passed since the original post or
  /// the last repost. The UI uses it to show the countdown; the server enforces it.
  static const Duration repostCooldown = Duration(days: 3);

  // Network
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // Auth
  static const int otpLength = 6;
  static const Duration otpResendCooldown = Duration(seconds: 60);

  // Lists
  static const int feedPageSize = 30;
  static const Duration searchDebounce = Duration(milliseconds: 350);
}
