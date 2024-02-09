import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformWrapper {
  static var _instance = PlatformWrapper._();

  static PlatformWrapper get get => _instance;

  @visibleForTesting
  static void set(PlatformWrapper manager) => _instance = manager;

  PlatformWrapper._();

  bool get isAndroid => Platform.isAndroid;

  bool get isDebug => kDebugMode;
}
