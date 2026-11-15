import 'dart:async';
import 'dart:ui' show VoidCallback;

import '../constants/app_constants.dart';

/// Runs the last action only after calls stop for [delay], e.g. search-as-you-type.
class Debouncer {
  Debouncer({this.delay = AppConstants.searchDebounce});

  final Duration delay;
  Timer? _timer;

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
