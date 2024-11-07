import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../log.dart';

const _log = Log("FlameUtils");

Future<void> resetOrientations() async {
  // Restrict orientation to portrait for devices with a small width. A width
  // of 740 is less than the smallest iPad, and most Android tablets.
  var display = PlatformDispatcher.instance.views.first.display;
  if (display.size.shortestSide / display.devicePixelRatio < 740) {
    await Flame.device.setPortrait();
    _log.d("Orientations reset portrait");
  } else {
    await Flame.device.setOrientations(DeviceOrientation.values);
    _log.d("Orientations reset to all");
  }
}

Future<void> lockOrientation(Orientation? orientation) async {
  if (orientation == null) {
    return;
  }

  if (orientation == Orientation.portrait) {
    _log.d("Orientations locked to portrait");
    return Flame.device.setPortrait();
  } else {
    _log.d("Orientations locked to landscape");
    return Flame.device.setLandscape();
  }
}
