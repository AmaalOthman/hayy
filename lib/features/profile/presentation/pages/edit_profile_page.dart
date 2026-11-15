import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/phone_countries.dart';
import '../../../../core/error/failure_l10n.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/phone_input_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/broker_profile.dart';
import '../providers/profile_controller.dart';
import '../widgets/profile_photo_picker.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key, this.isOnboarding = false});

  final bool isOnboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: !isOnboarding,
        title: isOnboarding ? null : Text(l10n.editProfileTitle),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        actions: [
          if (isOnboarding)
            TextButton(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).logout(),
              child: Text(l10n.logout),
            ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: switch (profile) {
            AsyncData(:final value) =>
              _ProfileForm(profile: value, isOnboarding: isOnboarding),
            AsyncError(:final error) => AppErrorView(
                error: error,
                onRetry: () => ref.invalidate(profileControllerProvider),
              ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.profile, required this.isOnboarding});

  final BrokerProfile profile;
  final bool isOnboarding;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _agency;
  late final TextEditingController _whatsapp;
  late PhoneCountry _whatsappCountry;
  String? _photoPath;
  String? _whatsappError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _name = TextEditingController(text: p.fullName);
    _agency = TextEditingController(text: p.agencyName);
    // Default the WhatsApp number to the verified login number.
    final (country, national) = PhoneCountries.split(p.whatsappNumber ?? p.phone);
    _whatsappCountry = country;
    _whatsapp = TextEditingController(text: national);
    _name.addListener(_refreshInitials);
  }

  @override
  void dispose() {
    _name.dispose();
    _agency.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  void _refreshInitials() {
    if (_photoPath == null && widget.profile.photoUrl == null) setState(() {});
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final national = Validators.normalizePhone(_whatsapp.text);
    final phoneOk = Validators.isValidPhone(national, _whatsappCountry);
    setState(() => _whatsappError = phoneOk ? null : l10n.errorInvalidPhone);
    if (!_formKey.currentState!.validate() || !phoneOk) return;

    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    final failure = await ref.read(profileControllerProvider.notifier).save(
          ProfileUpdate(
            fullName: _name.text.trim(),
            agencyName: _agency.text.trim(),
            whatsappNumber: _whatsappCountry.toE164(national),
            photoPath: _photoPath,
          ),
        );
    if (!mounted) return;

    if (failure != null) {
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(failure.localized(l10n))));
      return;
    }
    if (widget.isOnboarding) {
      // Profile is now complete: refreshing the session lets the router
      // move on to the approval screen. Keep the spinner until it does.
      await ref.read(authControllerProvider.notifier).checkSession();
      if (mounted) setState(() => _saving = false);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
        children: [
          if (widget.isOnboarding) ...[
            Text(l10n.completeProfileTitle, style: text.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.completeProfileSubtitle,
              style: text.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          Center(
            child: ProfilePhotoPicker(
              imageUrl: _photoPath ?? widget.profile.photoUrl,
              name: _name.text,
              enabled: !_saving,
              onPicked: (path) => setState(() => _photoPath = path),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  enabled: !_saving,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(
                    labelText: l10n.fullNameLabel,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) =>
                      Validators.isValidName(v) ? null : l10n.errorFullName,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _agency,
                  enabled: !_saving,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.organizationName],
                  decoration: InputDecoration(
                    labelText: l10n.agencyLabel,
                    prefixIcon: const Icon(Icons.apartment_rounded),
                  ),
                  validator: (v) => (v?.trim().length ?? 0) >= 2
                      ? null
                      : l10n.errorAgency,
                ),
                const SizedBox(height: AppSpacing.lg),
                PhoneInputField(
                  controller: _whatsapp,
                  country: _whatsappCountry,
                  label: l10n.whatsappLabel,
                  errorText: _whatsappError,
                  enabled: !_saving,
                  onSubmitted: _save,
                  onCountryChanged: (c) => setState(() {
                    _whatsappCountry = c;
                    _whatsappError = null;
                  }),
                ),
                if (_whatsappError == null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: AppSpacing.md, top: AppSpacing.xs),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(l10n.whatsappHelper, style: text.bodySmall),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.white),
                  )
                : Text(widget.isOnboarding ? l10n.saveAndContinue : l10n.save),
          ),
        ],
      ),
    );
  }
}
