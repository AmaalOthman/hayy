// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hayy';

  @override
  String get splashTagline => 'The unified platform for brokers';

  @override
  String get splashOffline => 'We couldn\'t reach Hayy. Check your connection.';

  @override
  String get retry => 'Try again';

  @override
  String get loginTitle => 'Welcome to Hayy';

  @override
  String get loginSubtitle =>
      'Sign in with your mobile number to join your brokers community.';

  @override
  String get phoneLabel => 'Mobile number';

  @override
  String get continueButton => 'Continue';

  @override
  String get loginTerms => 'Hayy is for licensed real estate brokers only.';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String get otpSubtitle => 'Enter the 6-digit code we sent to';

  @override
  String get verifyButton => 'Verify';

  @override
  String otpResendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get otpResend => 'Resend code';

  @override
  String get otpSent => 'A new code is on its way';

  @override
  String get changeNumber => 'Change number';

  @override
  String get pendingTitle => 'Your account is under review';

  @override
  String get pendingBody =>
      'We verify every broker to keep Hayy brokers-only. We\'ll let you know as soon as you\'re approved.';

  @override
  String get suspendedTitle => 'Your account is suspended';

  @override
  String get suspendedBody => 'Contact Hayy support to restore your access.';

  @override
  String get checkStatus => 'Check status';

  @override
  String get stillPending =>
      'Still under review. We\'ll notify you once approved.';

  @override
  String get logout => 'Log out';

  @override
  String get completeProfileTitle => 'Complete your profile';

  @override
  String get completeProfileSubtitle =>
      'Brokers see this on every post you share, and our team uses it to approve your account.';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get agencyLabel => 'Agency name';

  @override
  String get whatsappLabel => 'WhatsApp number';

  @override
  String get whatsappHelper => 'Brokers will contact you on this number.';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get photoFromCamera => 'Take a photo';

  @override
  String get photoFromGallery => 'Choose from gallery';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get save => 'Save';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get errorFullName => 'Enter your full name';

  @override
  String get errorAgency => 'Enter your agency name';

  @override
  String get homeTitle => 'Communities';

  @override
  String get homeEmpty => 'Communities you join will appear here.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorInvalidPhone => 'Enter a valid mobile number';

  @override
  String get errorInvalidOtp => 'Enter the 6-digit code';
}
