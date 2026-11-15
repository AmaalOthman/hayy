import 'package:flutter_test/flutter_test.dart';
import 'package:hayy/core/constants/phone_countries.dart';
import 'package:hayy/core/utils/validators.dart';

void main() {
  test('normalizePhone strips spaces and the local leading 0', () {
    expect(Validators.normalizePhone('050 123 4567'), '501234567');
    expect(Validators.normalizePhone('501234567'), '501234567');
  });

  test('UAE mobiles: 9 digits starting with 5', () {
    const uae = PhoneCountries.uae;
    expect(Validators.isValidPhone('501234567', uae), isTrue);
    expect(Validators.isValidPhone('401234567', uae), isFalse);
    expect(Validators.isValidPhone('50123456', uae), isFalse);
    expect(uae.toE164('501234567'), '+971501234567');
  });

  test('Egypt mobiles: 10 digits starting with 1', () {
    expect(Validators.isValidPhone('1012345678', PhoneCountries.egypt), isTrue);
    expect(Validators.isValidPhone('2012345678', PhoneCountries.egypt), isFalse);
  });

  test('OTP must be exactly 6 digits', () {
    expect(Validators.isValidOtp('123456'), isTrue);
    expect(Validators.isValidOtp('12345'), isFalse);
    expect(Validators.isValidOtp('12a456'), isFalse);
  });
}
