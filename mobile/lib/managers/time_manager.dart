import 'package:flutter/foundation.dart';

class TimeManager {
  static var _instance = TimeManager._();

  static TimeManager get get => _instance;

  @visibleForTesting
  static void set(TimeManager manager) => _instance = manager;

  @visibleForTesting
  static void suicide() => _instance = TimeManager._();

  TimeManager._();

  int get millisSinceEpoch => DateTime.now().millisecondsSinceEpoch;
}
