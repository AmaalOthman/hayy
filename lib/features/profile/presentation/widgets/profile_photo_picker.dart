import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../l10n/app_localizations.dart';

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    required this.onPicked,
    this.imageUrl,
    this.name,
    this.enabled = true,
  });

  final ValueChanged<String> onPicked;
  final String? imageUrl;
  final String? name;
  final bool enabled;

  Future<void> _pick(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.cardSurface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: AppColors.duskBlue),
              title: Text(l10n.photoFromCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.duskBlue),
              title: Text(l10n.photoFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );
      if (file != null) onPicked(file.path);
    } on PlatformException {
      // Permission denied or no camera: the broker can simply try again.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPhoto = imageUrl != null && imageUrl!.isNotEmpty;

    return Semantics(
      button: true,
      label: hasPhoto ? l10n.changePhoto : l10n.addPhoto,
      child: GestureDetector(
        onTap: enabled ? () => _pick(context) : null,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mutedCopper.withValues(alpha: 0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: AppAvatar(
                    imageUrl: imageUrl,
                    name: name,
                    size: 112,
                    ringWidth: 3,
                  ),
                ),
                PositionedDirectional(
                  end: 0,
                  bottom: 2,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.duskBlue,
                      border: Border.all(color: AppColors.cardSurface, width: 3),
                    ),
                    child: const Icon(Icons.photo_camera_rounded,
                        size: 16, color: AppColors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasPhoto ? l10n.changePhoto : l10n.addPhoto,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppColors.duskBlue),
            ),
          ],
        ),
      ),
    );
  }
}
