import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

/// Dusk-blue-to-copper screen header from the design
/// ("New Cairo – Sale – Residential / Brokers community").
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

  /// Optional content under the title, e.g. a search field.
  final Widget? bottom;

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
            padding: EdgeInsetsDirectional.fromSTEB(
              leading == null ? AppSpacing.lg : AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ?leading,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: text.bodySmall?.copyWith(
                                color: AppColors.white.withValues(alpha: 0.82),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ...actions,
                  ],
                ),
                if (bottom != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        top: AppSpacing.md, end: AppSpacing.sm),
                    child: bottom,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
