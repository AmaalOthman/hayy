import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure_l10n.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_controller.dart';
import '../widgets/otp_input_field.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = 0;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = AppConstants.otpResendCooldown.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) timer.cancel();
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _verify([String? value]) async {
    final l10n = AppLocalizations.of(context);
    final code = value ?? _code.text;
    if (_loading) return;
    if (!Validators.isValidOtp(code)) {
      setState(() => _error = l10n.errorInvalidOtp);
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });
    final failure = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(phone: widget.phone, code: code);
    if (!mounted || failure == null) return;

    setState(() {
      _loading = false;
      _error = failure.localized(l10n);
    });
    _code.clear();
    _focus.requestFocus();
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final failure =
        await ref.read(authControllerProvider.notifier).sendOtp(widget.phone);
    if (!mounted) return;
    if (failure == null) {
      _startCooldown();
      messenger.showSnackBar(SnackBar(content: Text(l10n.otpSent)));
    } else {
      setState(() => _error = failure.localized(l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CopperBadge(icon: Icons.sms_outlined),
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.otpTitle, style: text.headlineMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.otpSubtitle,
                  style:
                      text.bodyLarge?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.phone,
                  textDirection: TextDirection.ltr,
                  style: text.titleMedium?.copyWith(color: AppColors.duskBlue),
                ),
                const SizedBox(height: AppSpacing.xl),
                OtpInputField(
                  controller: _code,
                  focusNode: _focus,
                  hasError: _error != null,
                  enabled: !_loading,
                  onCompleted: _verify,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: _error == null
                      ? const SizedBox(width: double.infinity)
                      : Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(_error!,
                              style: text.bodySmall
                                  ?.copyWith(color: AppColors.error)),
                        ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading ? null : _verify,
                    child: _loading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.white),
                          )
                        : Text(l10n.verifyButton),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _secondsLeft > 0
                        ? Text(l10n.otpResendIn(_secondsLeft),
                            style: text.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary))
                        : TextButton(
                            onPressed: _loading ? null : _resend,
                            child: Text(l10n.otpResend),
                          ),
                    TextButton(
                      onPressed:
                          _loading ? null : () => Navigator.of(context).pop(),
                      child: Text(l10n.changeNumber),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CopperBadge extends StatelessWidget {
  const _CopperBadge({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.copperMetal,
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardSurface,
          ),
          child: Icon(icon, color: AppColors.duskBlue, size: 28),
        ),
      );
}
