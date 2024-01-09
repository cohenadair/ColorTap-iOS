import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/managers/preference_manager.dart';

class LivesManager {
  static var _instance = LivesManager._();

  static LivesManager get get => _instance;

  @visibleForTesting
  static void set(LivesManager manager) => _instance = manager;

  @visibleForTesting
  static void suicide() => _instance = LivesManager._();

  LivesManager._();

  final _controller = StreamController.broadcast();

  Stream get stream => _controller.stream;

  int get lives => PreferenceManager.get.lives;

  bool get canPlay => lives > 0;

  void loseLife() {
    PreferenceManager.get.lives = lives - 1;
    _controller.add(null);
  }

  void reset() {
    PreferenceManager.get.clearLives();
    _controller.add(null);
  }
}
