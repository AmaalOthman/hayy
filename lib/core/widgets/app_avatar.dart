import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Broker photo in a copper ring. Falls back to initials.
///
/// [imageUrl] may be `https://...`, a `data:` URI (mock backend) or a local
/// file path (a photo just picked, before upload).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 44,
    this.ringWidth = 2,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final double ringWidth;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(ringWidth),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.copperMetal,
        ),
        child: ClipOval(
          child: ColoredBox(
            color: AppColors.desertSandstone,
            child: _image() ?? _initials(context),
          ),
        ),
      );

  Widget? _image() {
    final url = imageUrl;
    if (url == null || url.isEmpty) return null;
    final fallback = Builder(builder: _initials);

    if (url.startsWith('data:')) {
      return Image.memory(
        UriData.parse(url).contentAsBytes(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    // Web: a just-picked photo is a blob: URL, not a file.
    if (url.startsWith('blob:')) {
      return Image.network(url,
          fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback);
    }
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => fallback,
      );
    }
    return Image.file(
      File(url),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }

  Widget _initials(BuildContext context) {
    final parts = (name ?? '').trim().split(RegExp(r'\s+'));
    final letters = parts
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p.characters.first.toUpperCase())
        .join();
    return Center(
      child: letters.isEmpty
          ? Icon(Icons.person_rounded,
              size: size * 0.5, color: AppColors.mutedCopper)
          : Text(
              letters,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: size * 0.34,
                    color: AppColors.duskBlue,
                  ),
            ),
    );
  }
}
