import 'package:flutter/foundation.dart';

class TimeManager {
  static var _instance = TimeManager._();

  static TimeManager get get => _instance;

  @visibleForTesting
  static void set(TimeManager timeManager) => _instance = timeManager;

  TimeManager._();

  int get millisSinceEpoch => DateTime.now().millisecondsSinceEpoch;
}
