import 'dart:ui';

import 'package:flutter/foundation.dart';

class PlatformDispatcherWrapper {
  static var _instance = PlatformDispatcherWrapper._();

  static PlatformDispatcherWrapper get get => _instance;

  @visibleForTesting
  static void set(PlatformDispatcherWrapper manager) => _instance = manager;

  PlatformDispatcherWrapper._();

  Size get displaySize => PlatformDispatcher.instance.views.first.display.size;

  double get displayDevicePixelRatio =>
      PlatformDispatcher.instance.views.first.display.devicePixelRatio;
}
