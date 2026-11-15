import 'package:intl/intl.dart';

abstract final class DateFormatter {
  /// Chat-list style timestamp:
  /// today → `10:30`, yesterday → [yesterday], this week → `Mon`,
  /// older → `16/11/2026` (all in [locale]).
  static String chatTime(
    DateTime time, {
    required String locale,
    required String yesterday,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final day = DateTime(time.year, time.month, time.day);
    final daysAgo = today.difference(day).inDays;

    if (daysAgo <= 0) return DateFormat.Hm(locale).format(time);
    if (daysAgo == 1) return yesterday;
    if (daysAgo < 7) return DateFormat.E(locale).format(time);
    return DateFormat.yMd(locale).format(time);
  }
}
