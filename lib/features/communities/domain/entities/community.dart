import 'package:equatable/equatable.dart';

import '../../../posts/domain/entities/post_type.dart';

enum TransactionType {
  sale,
  rental;

  static TransactionType fromJson(String? v) => v == 'rental' ? rental : sale;
  String toJson() => name;
}

enum PropertyUse {
  residential,
  commercial;

  static PropertyUse fromJson(String? v) =>
      v == 'commercial' ? commercial : residential;
  String toJson() => name;
}

/// One neighbourhood × transaction × use, e.g.
/// "Dubai Marina – Rental – Residential". Works like a WhatsApp group.
class Community extends Equatable {
  const Community({
    required this.id,
    required this.areaId,
    required this.areaName,
    required this.transaction,
    required this.use,
    required this.memberCount,
    this.isSubscribed = false,
    this.isMuted = false,
    this.unreadCount = 0,
    this.lastPost,
  });

  final String id;
  final String areaId;
  final String areaName;
  final TransactionType transaction;
  final PropertyUse use;
  final int memberCount;

  // Per-broker state.
  final bool isSubscribed;
  final bool isMuted;
  final int unreadCount;
  final LastPostPreview? lastPost;

  Community copyWith({bool? isSubscribed, bool? isMuted, int? unreadCount}) =>
      Community(
        id: id,
        areaId: areaId,
        areaName: areaName,
        transaction: transaction,
        use: use,
        memberCount: memberCount,
        isSubscribed: isSubscribed ?? this.isSubscribed,
        isMuted: isMuted ?? this.isMuted,
        unreadCount: unreadCount ?? this.unreadCount,
        lastPost: lastPost,
      );

  @override
  List<Object?> get props => [
        id,
        areaId,
        areaName,
        transaction,
        use,
        memberCount,
        isSubscribed,
        isMuted,
        unreadCount,
        lastPost,
      ];
}

/// The latest post, shown under the community name like a chat preview.
class LastPostPreview extends Equatable {
  const LastPostPreview({
    required this.type,
    required this.summary,
    required this.authorName,
    required this.createdAt,
  });

  final PostType type;

  /// Structured details, e.g. "Building X · 1,500 sq ft · Floor 5–10".
  final String summary;
  final String authorName;
  final DateTime createdAt;

  @override
  List<Object?> get props => [type, summary, authorName, createdAt];
}
