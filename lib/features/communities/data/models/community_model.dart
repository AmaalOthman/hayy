import '../../../posts/domain/entities/post_type.dart';
import '../../domain/entities/community.dart';

/// One item of `GET /communities` or `GET /me/communities` (`{"items": [...]}`):
/// ```json
/// {"id": "...", "areaId": "...", "areaName": "Dubai Marina",
///  "transaction": "rental", "use": "residential", "memberCount": 240,
///  "isSubscribed": true, "isMuted": false, "unreadCount": 3,
///  "lastPost": {"type": "listing", "summary": "...", "authorName": "Ahmed",
///               "createdAt": "2026-11-16T10:30:00Z"}}
/// ```
abstract final class CommunityModel {
  static Community fromJson(Map<String, dynamic> json) => Community(
        id: json['id'].toString(),
        areaId: json['areaId'].toString(),
        areaName: json['areaName'] as String,
        transaction: TransactionType.fromJson(json['transaction'] as String?),
        use: PropertyUse.fromJson(json['use'] as String?),
        memberCount: json['memberCount'] as int? ?? 0,
        isSubscribed: json['isSubscribed'] as bool? ?? false,
        isMuted: json['isMuted'] as bool? ?? false,
        unreadCount: json['unreadCount'] as int? ?? 0,
        lastPost: _lastPost(json['lastPost']),
      );

  static List<Community> listFromJson(Map<String, dynamic> json) =>
      (json['items'] as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();

  static LastPostPreview? _lastPost(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final type = PostType.fromJson(json['type'] as String?);
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    if (type == null || createdAt == null) return null;
    return LastPostPreview(
      type: type,
      summary: json['summary'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      createdAt: createdAt.toLocal(),
    );
  }
}
