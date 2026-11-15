// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حيّ';

  @override
  String get splashTagline => 'المنصة الموحّدة للوسطاء العقاريين';

  @override
  String get splashOffline => 'تعذّر الاتصال بحيّ. تحقّق من اتصالك بالإنترنت.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loginTitle => 'أهلاً بك في حيّ';

  @override
  String get loginSubtitle => 'سجّل الدخول برقم جوالك وانضم إلى مجتمع الوسطاء.';

  @override
  String get phoneLabel => 'رقم الجوال';

  @override
  String get continueButton => 'متابعة';

  @override
  String get loginTerms => 'حيّ مخصّص للوسطاء العقاريين المرخّصين فقط.';

  @override
  String get otpTitle => 'تأكيد رقمك';

  @override
  String get otpSubtitle => 'أدخل الرمز المكوّن من 6 أرقام المرسل إلى';

  @override
  String get verifyButton => 'تأكيد';

  @override
  String otpResendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get otpResend => 'إعادة إرسال الرمز';

  @override
  String get otpSent => 'تم إرسال رمز جديد';

  @override
  String get changeNumber => 'تغيير الرقم';

  @override
  String get pendingTitle => 'حسابك قيد المراجعة';

  @override
  String get pendingBody =>
      'نراجع كل وسيط للحفاظ على حيّ مجتمعاً للوسطاء فقط. سنُعلمك فور اعتماد حسابك.';

  @override
  String get suspendedTitle => 'تم إيقاف حسابك';

  @override
  String get suspendedBody => 'تواصل مع دعم حيّ لاستعادة الوصول إلى حسابك.';

  @override
  String get checkStatus => 'تحقّق من الحالة';

  @override
  String get stillPending => 'حسابك ما زال قيد المراجعة. سنُعلمك فور اعتماده.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get completeProfileTitle => 'أكمل ملفك الشخصي';

  @override
  String get completeProfileSubtitle =>
      'يظهر ملفك للوسطاء مع كل منشور تشاركه، ويستخدمه فريقنا لاعتماد حسابك.';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get agencyLabel => 'اسم الوكالة';

  @override
  String get whatsappLabel => 'رقم واتساب';

  @override
  String get whatsappHelper => 'سيتواصل معك الوسطاء على هذا الرقم.';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get photoFromCamera => 'التقاط صورة';

  @override
  String get photoFromGallery => 'اختيار من المعرض';

  @override
  String get saveAndContinue => 'حفظ ومتابعة';

  @override
  String get save => 'حفظ';

  @override
  String get profileSaved => 'تم حفظ الملف الشخصي';

  @override
  String get errorFullName => 'أدخل اسمك الكامل';

  @override
  String get errorAgency => 'أدخل اسم الوكالة';

  @override
  String get homeTitle => 'المجتمعات';

  @override
  String get homeSubtitle => 'مجتمع الوسطاء';

  @override
  String get navCommunities => 'المجتمعات';

  @override
  String get navSearch => 'بحث';

  @override
  String get navNewPost => 'منشور جديد';

  @override
  String get navMyPosts => 'منشوراتي';

  @override
  String get navProfile => 'حسابي';

  @override
  String get communitiesEmptyTitle => 'لم تنضم لأي مجتمع بعد';

  @override
  String get communitiesEmptyBody =>
      'انضم إلى المناطق التي تعمل بها لتظهر هنا عروضها وطلباتها.';

  @override
  String get exploreTitle => 'استكشف المجتمعات';

  @override
  String exploreSubtitle(int count) {
    return '$count مجتمعاً في دبي';
  }

  @override
  String get searchCommunitiesHint => 'ابحث عن منطقة';

  @override
  String get noCommunitiesFound => 'لا توجد مجتمعات مطابقة لبحثك.';

  @override
  String get noPostsYet => 'لا توجد منشورات بعد';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وسيط',
      many: '$count وسيطاً',
      few: '$count وسطاء',
      two: 'وسيطان',
      one: 'وسيط واحد',
      zero: 'لا يوجد وسطاء',
    );
    return '$_temp0';
  }

  @override
  String get join => 'انضمام';

  @override
  String get joined => 'منضم';

  @override
  String get leave => 'مغادرة المجتمع';

  @override
  String leftCommunity(String name) {
    return 'غادرت $name';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get mute => 'كتم الإشعارات';

  @override
  String get unmute => 'إلغاء كتم الإشعارات';

  @override
  String get muted => 'مكتوم';

  @override
  String get filterAll => 'الكل';

  @override
  String get transactionSale => 'بيع';

  @override
  String get transactionRental => 'إيجار';

  @override
  String get useResidential => 'سكني';

  @override
  String get useCommercial => 'تجاري';

  @override
  String get postTypeListing => 'عرض';

  @override
  String get postTypeRequest => 'طلب';

  @override
  String get postTypeViewing => 'معاينة';

  @override
  String get yesterday => 'أمس';

  @override
  String get feedEmpty =>
      'لا توجد منشورات في هذا المجتمع بعد. كن أول من يشارك عرضاً أو طلباً.';

  @override
  String get newPostTitle => 'منشور جديد';

  @override
  String get newPostNext => 'نموذج إنشاء المنشور هو الخطوة التالية.';

  @override
  String get myPostsEmpty =>
      'ستظهر هنا منشوراتك مع خيارات إعادة النشر والتعديل.';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get errorGeneric => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get errorSessionExpired => 'انتهت جلستك. سجّل الدخول مرة أخرى.';

  @override
  String get errorInvalidPhone => 'أدخل رقم جوال صحيح';

  @override
  String get errorInvalidOtp => 'أدخل الرمز المكوّن من 6 أرقام';
}
