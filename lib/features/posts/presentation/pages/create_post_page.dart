import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../l10n/app_localizations.dart';

/// Entry point of the guided post form (type → area → building → size/floor
/// → note). The steps live in widgets/create_post_steps and come next.
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            leading: const CloseButton(color: Colors.white),
            title: l10n.newPostTitle,
          ),
          Expanded(
            child: AppEmptyView(
              icon: Icons.edit_note_rounded,
              message: l10n.newPostNext,
            ),
          ),
        ],
      ),
    );
  }
}
