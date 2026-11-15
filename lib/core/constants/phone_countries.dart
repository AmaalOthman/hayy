/// Countries a broker can sign up from. UAE first: Hayy launches in Dubai.
class PhoneCountry {
  const PhoneCountry({
    required this.isoCode,
    required this.dialCode,
    required this.flag,
    required this.nationalLength,
    required this.mobilePrefixes,
  });

  final String isoCode;
  final String dialCode;
  final String flag;

  /// Digits after the country code, without the leading 0.
  final int nationalLength;

  /// First digit(s) of a valid mobile number, e.g. UAE mobiles start with 5.
  final List<String> mobilePrefixes;

  /// `0501234567` → `+971501234567`
  String toE164(String national) => '+$dialCode$national';
}

abstract final class PhoneCountries {
  static const PhoneCountry uae = PhoneCountry(
    isoCode: 'AE',
    dialCode: '971',
    flag: '🇦🇪',
    nationalLength: 9,
    mobilePrefixes: ['5'],
  );
  static const PhoneCountry saudi = PhoneCountry(
    isoCode: 'SA',
    dialCode: '966',
    flag: '🇸🇦',
    nationalLength: 9,
    mobilePrefixes: ['5'],
  );
  static const PhoneCountry egypt = PhoneCountry(
    isoCode: 'EG',
    dialCode: '20',
    flag: '🇪🇬',
    nationalLength: 10,
    mobilePrefixes: ['1'],
  );

  static const List<PhoneCountry> all = [uae, saudi, egypt];
}
