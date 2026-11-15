abstract final class StorageKeys {
  // Secure storage (encrypted)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // Shared preferences (non-sensitive)
  static const String locale = 'locale';
  static const String cachedPostOptions = 'cached_post_options';
  static const String cachedPostOptionsAt = 'cached_post_options_at';
}
