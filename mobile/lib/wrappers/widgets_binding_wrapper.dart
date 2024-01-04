import 'dart:ui';

import 'package:flutter/material.dart';

class WidgetsBindingWrapper {
  static var _instance = WidgetsBindingWrapper._();

  static WidgetsBindingWrapper get get => _instance;

  @visibleForTesting
  static void set(WidgetsBindingWrapper wrapper) => _instance = wrapper;

  WidgetsBindingWrapper._();

  FlutterView? get implicitView =>
      WidgetsBinding.instance.platformDispatcher.implicitView;
}
