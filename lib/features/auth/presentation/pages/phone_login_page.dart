import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/phone_countries.dart';
import '../../../../core/error/failure_l10n.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_controller.dart';
import '../widgets/phone_input_field.dart';
import 'splash_page.dart' show hayyLogoHeroTag;

class PhoneLoginPage extends ConsumerStatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  ConsumerState<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends ConsumerState<PhoneLoginPage> {
  final _phone = TextEditingController();
  PhoneCountry _country = PhoneCountries.uae;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final national = Validators.normalizePhone(_phone.text);
    if (!Validators.isValidPhone(national, _country)) {
      setState(() => _error = l10n.errorInvalidPhone);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
    });
    final phone = _country.toE164(national);
    final failure =
        await ref.read(authControllerProvider.notifier).sendOtp(phone);
    if (!mounted) return;
    setState(() => _loading = false);

    if (failure == null) {
      context.push(RouteNames.otp, extra: phone);
    } else {
      setState(() => _error = failure.localized(l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(height: constraints.maxHeight * 0.42),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.loginTitle, style: text.headlineMedium),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.loginSubtitle,
                            style: text.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          PhoneInputField(
                            controller: _phone,
                            country: _country,
                            label: l10n.phoneLabel,
                            errorText: _error,
                            enabled: !_loading,
                            onSubmitted: _submit,
                            onCountryChanged: (c) => setState(() {
                              _country = c;
                              _error = null;
                            }),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : Text(l10n.continueButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.verified_user_outlined,
                                size: 16, color: AppColors.mutedCopper),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(l10n.loginTerms,
                                  style: text.bodySmall,
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skyline photo fading into the cream page, with the logo from the splash.
class _Header extends StatelessWidget {
  const _Header({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.heroBackground,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.1),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xB31A212E),
                    Color(0x991A212E),
                    Color(0x00FAF8F3),
                    AppColors.appBackground,
                  ],
                  stops: [0.0, 0.5, 0.82, 1.0],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.5),
              child: SafeArea(
                bottom: false,
                child: Hero(
                  tag: hayyLogoHeroTag,
                  child: Image.asset(AppAssets.logo, width: 104),
                ),
              ),
            ),
          ],
        ),
      );
}
