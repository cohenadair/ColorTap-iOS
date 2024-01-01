import 'package:flutter/foundation.dart';

class TimeManager {
  static var _instance = TimeManager._();

  static TimeManager get get => _instance;

  TimeManager._();

  @visibleForTesting
  void set(TimeManager timeManager) => _instance = timeManager;

  int get millisSinceEpoch => DateTime.now().millisecondsSinceEpoch;
}
