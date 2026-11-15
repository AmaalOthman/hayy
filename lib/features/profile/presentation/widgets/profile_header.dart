import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/broker_profile.dart';

/// Gradient band with the broker's photo, name and agency, as other
/// brokers see them on posts.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final BrokerProfile profile;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.header),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xl),
            child: Column(
              children: [
                AppAvatar(
                  imageUrl: profile.photoUrl,
                  name: profile.fullName,
                  size: 96,
                  ringWidth: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  profile.fullName ?? '',
                  textAlign: TextAlign.center,
                  style: text.titleLarge?.copyWith(color: AppColors.white),
                ),
                if (profile.agencyName != null)
                  Text(
                    profile.agencyName!,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
