import '../constants/app_constants.dart';
import '../constants/phone_countries.dart';

abstract final class Validators {
  static final RegExp _nonDigits = RegExp(r'\D');
  static final RegExp _leadingZeros = RegExp(r'^0+');

  /// Keeps digits only and drops the local leading 0: `050 123 4567` → `501234567`.
  static String normalizePhone(String input) =>
      input.replaceAll(_nonDigits, '').replaceFirst(_leadingZeros, '');

  /// [national] must already be normalized.
  static bool isValidPhone(String national, PhoneCountry country) =>
      national.length == country.nationalLength &&
      country.mobilePrefixes.any(national.startsWith);

  static bool isValidOtp(String code) =>
      code.length == AppConstants.otpLength && !code.contains(_nonDigits);
}
