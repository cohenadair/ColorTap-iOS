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

  static const rewardedAdAmount = 10;
  static const adErrorReward = 5;

  final _controller = StreamController.broadcast();

  Stream get stream => _controller.stream;

  int get lives => PreferenceManager.get.lives;

  bool get canPlay => lives > 0;

  void incLives(int by) {
    PreferenceManager.get.lives = lives + by;
    _notify();
  }

  void loseLife() => incLives(-1);

  void reset() {
    PreferenceManager.get.clearLives();
    _notify();
  }

  void rewardWatchedAd() => incLives(rewardedAdAmount);

  void rewardAdError() => incLives(adErrorReward);

  void _notify() => _controller.add(null);
}
