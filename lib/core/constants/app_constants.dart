abstract final class AppConstants {
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
