import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/app_localizations.dart';

/// My posts tab. Shows the empty state until the posts feature lists the
/// broker's own posts with repost / edit / close.
class MyPostsPage extends StatelessWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(title: l10n.navMyPosts),
          Expanded(
            child: AppEmptyView(
              icon: Icons.article_outlined,
              message: l10n.myPostsEmpty,
            ),
          ),
        ],
      ),
    );
  }
}
