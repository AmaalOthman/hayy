import 'package:dio/dio.dart';

import '../../constants/api_endpoints.dart';

/// Communities part of the mock backend: a fixed catalogue of 104 Dubai
/// communities (26 areas × sale/rental × residential/commercial) plus each
/// broker's subscriptions and mutes, stored on the broker record.
abstract final class MockCommunities {
  static const List<String> _areas = [
    'Dubai Marina', 'Downtown Dubai', 'Business Bay', 'Jumeirah Lake Towers',
    'Jumeirah Village Circle', 'Palm Jumeirah', 'Dubai Hills Estate',
    'Arabian Ranches', 'DIFC', 'Al Barsha', 'JBR', 'Dubai Silicon Oasis',
    'Meydan', 'Deira', 'Dubai Creek Harbour', 'Al Furjan', 'Damac Hills',
    'Motor City', 'Sports City', 'International City', 'Jumeirah',
    'Mirdif', 'Al Quoz', 'Dubai South', 'Town Square', 'Emirates Hills',
  ];
  static const _buildings = [
    'Marina Gate', 'Burj Vista', 'Executive Towers', 'Bay Square',
    'Cluster D', 'Shoreline', 'Park Heights', 'Emaar South',
  ];
  static const _sizes = ['850 sq ft', '1,200 sq ft', '1,500 sq ft', '2,000 sq ft'];
  static const _floors = ['Floor 1–5', 'Floor 5–10', 'Floor 10–20', 'Floor 20+'];
  static const _authors = ['Ahmed', 'Mona', 'Omar', 'Sara', 'Khaled', 'Layla'];
  static const _types = ['listing', 'request', 'viewing'];

  static final List<Map<String, Object>> _catalogue = [
    for (final area in _areas)
      for (final transaction in ['sale', 'rental'])
        for (final use in ['residential', 'commercial'])
          {
            'id': '${_slug(area)}-$transaction-$use',
            'areaId': _slug(area),
            'areaName': area,
            'transaction': transaction,
            'use': use,
          },
  ];

  static final RegExp _memberRoute =
      RegExp(r'^/communities/([^/]+)/(subscription|mute)$');

  /// Handles community routes for a signed-in [broker]; null if not ours.
  static (int, Object?)? handle(RequestOptions o, Map<String, dynamic> broker) {
    final subs = List<String>.from(broker['subscriptions'] as List? ?? []);
    final muted = List<String>.from(broker['muted'] as List? ?? []);

    if (o.method == 'GET' && o.path == ApiEndpoints.subscribedCommunities) {
      final items = _catalogue
          .where((c) => subs.contains(c['id']))
          .map((c) => _toJson(c, subs, muted))
          .toList()
        ..sort((a, b) => _lastAt(b).compareTo(_lastAt(a)));
      return (200, {'items': items});
    }

    if (o.method == 'GET' && o.path == ApiEndpoints.communities) {
      final q = (o.queryParameters['q'] as String? ?? '').toLowerCase();
      final transaction = o.queryParameters['transaction'];
      final use = o.queryParameters['use'];
      final items = _catalogue
          .where((c) =>
              (c['areaName']! as String).toLowerCase().contains(q) &&
              (transaction == null || c['transaction'] == transaction) &&
              (use == null || c['use'] == use))
          .map((c) => _toJson(c, subs, muted))
          .toList();
      return (200, {'items': items});
    }

    final match = _memberRoute.firstMatch(o.path);
    if (match == null) return null;
    final id = match.group(1)!;
    if (!_catalogue.any((c) => c['id'] == id)) {
      return (404, {'message': 'Community not found', 'code': 'not_found'});
    }

    switch ((match.group(2), o.method)) {
      case ('subscription', 'PUT'):
        if (!subs.contains(id)) subs.add(id);
      case ('subscription', 'DELETE'):
        subs.remove(id);
        muted.remove(id);
      case ('mute', 'PUT'):
        final mute = (o.data as Map?)?['muted'] == true;
        muted.remove(id);
        if (mute) muted.add(id);
      default:
        return null;
    }
    broker['subscriptions'] = subs;
    broker['muted'] = muted;
    return (200, {'ok': true});
  }

  static Map<String, Object?> _toJson(
      Map<String, Object> c, List<String> subs, List<String> muted) {
    final id = c['id']! as String;
    final h = _hash(id);
    final subscribed = subs.contains(id);
    // Two communities in three have recent activity; only those can be unread.
    final active = h % 3 != 0;
    return {
      ...c,
      'memberCount': 40 + h % 260,
      'isSubscribed': subscribed,
      'isMuted': muted.contains(id),
      'unreadCount': subscribed && active ? h % 6 : 0,
      'lastPost': !active
          ? null
          : {
              'type': _types[h % 3],
              'summary': '${_buildings[h % _buildings.length]} · '
                  '${_sizes[(h ~/ 3) % _sizes.length]} · '
                  '${_floors[(h ~/ 7) % _floors.length]}',
              'authorName': _authors[(h ~/ 5) % _authors.length],
              'createdAt': DateTime.now()
                  .subtract(Duration(minutes: 5 + (h % 4000)))
                  .toUtc()
                  .toIso8601String(),
            },
    };
  }

  static String _lastAt(Map<String, Object?> json) =>
      (json['lastPost'] as Map?)?['createdAt'] as String? ?? '';

  static String _slug(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

  /// Stable across runs and platforms (String.hashCode is not).
  static int _hash(String s) =>
      s.codeUnits.fold(7, (h, c) => (h * 31 + c) & 0x7fffffff);
}
