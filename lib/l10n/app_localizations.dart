import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hayy'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'The unified platform for brokers'**
  String get splashTagline;

  /// No description provided for @splashOffline.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach Hayy. Check your connection.'**
  String get splashOffline;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Hayy'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your mobile number to join your brokers community.'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneLabel;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'Hayy is for licensed real estate brokers only.'**
  String get loginTerms;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to'**
  String get otpSubtitle;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String otpResendIn(int seconds);

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpResend;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way'**
  String get otpSent;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is under review'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In en, this message translates to:
  /// **'We verify every broker to keep Hayy brokers-only. We\'ll let you know as soon as you\'re approved.'**
  String get pendingBody;

  /// No description provided for @suspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended'**
  String get suspendedTitle;

  /// No description provided for @suspendedBody.
  ///
  /// In en, this message translates to:
  /// **'Contact Hayy support to restore your access.'**
  String get suspendedBody;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check status'**
  String get checkStatus;

  /// No description provided for @stillPending.
  ///
  /// In en, this message translates to:
  /// **'Still under review. We\'ll notify you once approved.'**
  String get stillPending;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Brokers see this on every post you share, and our team uses it to approve your account.'**
  String get completeProfileSubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @agencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Agency name'**
  String get agencyLabel;

  /// No description provided for @whatsappLabel.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number'**
  String get whatsappLabel;

  /// No description provided for @whatsappHelper.
  ///
  /// In en, this message translates to:
  /// **'Brokers will contact you on this number.'**
  String get whatsappHelper;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @photoFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photoFromCamera;

  /// No description provided for @photoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoFromGallery;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get saveAndContinue;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @errorFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get errorFullName;

  /// No description provided for @errorAgency.
  ///
  /// In en, this message translates to:
  /// **'Enter your agency name'**
  String get errorAgency;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Brokers community'**
  String get homeSubtitle;

  /// No description provided for @navCommunities.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get navCommunities;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navNewPost.
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get navNewPost;

  /// No description provided for @navMyPosts.
  ///
  /// In en, this message translates to:
  /// **'My posts'**
  String get navMyPosts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @communitiesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No communities yet'**
  String get communitiesEmptyTitle;

  /// No description provided for @communitiesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Join the neighbourhoods you work in to see their listings and requests here.'**
  String get communitiesEmptyBody;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore communities'**
  String get exploreTitle;

  /// No description provided for @exploreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} communities across Dubai'**
  String exploreSubtitle(int count);

  /// No description provided for @searchCommunitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Search neighbourhoods'**
  String get searchCommunitiesHint;

  /// No description provided for @noCommunitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No communities match your search.'**
  String get noCommunitiesFound;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 broker} other{{count} brokers}}'**
  String memberCount(int count);

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave community'**
  String get leave;

  /// No description provided for @leftCommunity.
  ///
  /// In en, this message translates to:
  /// **'You left {name}'**
  String leftCommunity(String name);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get mute;

  /// No description provided for @unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute notifications'**
  String get unmute;

  /// No description provided for @muted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get muted;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @transactionSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get transactionSale;

  /// No description provided for @transactionRental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get transactionRental;

  /// No description provided for @useResidential.
  ///
  /// In en, this message translates to:
  /// **'Residential'**
  String get useResidential;

  /// No description provided for @useCommercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get useCommercial;

  /// No description provided for @postTypeListing.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get postTypeListing;

  /// No description provided for @postTypeRequest.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get postTypeRequest;

  /// No description provided for @postTypeViewing.
  ///
  /// In en, this message translates to:
  /// **'Viewing'**
  String get postTypeViewing;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @feedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No posts in this community yet. Be the first to share a listing or a request.'**
  String get feedEmpty;

  /// No description provided for @newPostTitle.
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get newPostTitle;

  /// No description provided for @newPostNext.
  ///
  /// In en, this message translates to:
  /// **'The guided post form is the next step.'**
  String get newPostNext;

  /// No description provided for @myPostsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Posts you share will appear here, with repost and edit options.'**
  String get myPostsEmpty;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number'**
  String get errorInvalidPhone;

  /// No description provided for @errorInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get errorInvalidOtp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
