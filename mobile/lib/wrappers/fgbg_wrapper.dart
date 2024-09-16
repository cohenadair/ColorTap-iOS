import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class FgbgWrapper {
  static var _instance = FgbgWrapper._();

  static FgbgWrapper get get => _instance;

  @visibleForTesting
  static void set(FgbgWrapper manager) => _instance = manager;

  FgbgWrapper._();

  Stream<FGBGType> get stream => FGBGEvents.instance.stream;
}
