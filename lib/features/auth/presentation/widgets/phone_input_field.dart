import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/phone_countries.dart';
import '../../../../core/theme/theme.dart';

/// Mobile number with a country picker. Always laid out left-to-right,
/// even in Arabic, because phone numbers read LTR.
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    required this.label,
    this.errorText,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final PhoneCountry country;
  final ValueChanged<PhoneCountry> onCountryChanged;
  final String label;
  final String? errorText;
  final VoidCallback? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.telephoneNumberNational],
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          // +1 allows a typed leading 0 (e.g. 050...), stripped on submit.
          LengthLimitingTextInputFormatter(country.nationalLength + 1),
        ],
        style: text.titleMedium?.copyWith(letterSpacing: 1.2),
        onSubmitted: (_) => onSubmitted?.call(),
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          prefixIcon: _CountryPicker(
            country: country,
            enabled: enabled,
            onChanged: onCountryChanged,
          ),
        ),
      ),
    );
  }
}

class _CountryPicker extends StatelessWidget {
  const _CountryPicker({
    required this.country,
    required this.onChanged,
    required this.enabled,
  });

  final PhoneCountry country;
  final ValueChanged<PhoneCountry> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return PopupMenuButton<PhoneCountry>(
      enabled: enabled,
      initialValue: country,
      onSelected: onChanged,
      color: AppColors.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      itemBuilder: (_) => [
        for (final c in PhoneCountries.all)
          PopupMenuItem(
            value: c,
            child: Text('${c.flag}  +${c.dialCode}', style: text.bodyLarge),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppSpacing.md, right: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.xs),
            Text('+${country.dialCode}', style: text.titleMedium),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.only(left: AppSpacing.xs),
              color: AppColors.warmTravertine,
            ),
          ],
        ),
      ),
    );
  }
}
