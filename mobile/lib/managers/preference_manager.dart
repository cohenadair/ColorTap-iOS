import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/difficulty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static var _instance = PreferenceManager._();

  static PreferenceManager get get => _instance;

  @visibleForTesting
  static void set(PreferenceManager manager) => _instance = manager;

  @visibleForTesting
  static void suicide() => _instance = PreferenceManager._();

  PreferenceManager._();

  static const _defaultLives = 10;
  static const _keyLives = "lives";
  static const _keyDifficulty = "difficulty";
  static const _keyColorIndex = "color_index";

  late final SharedPreferences _prefs;

  final _controller = StreamController.broadcast();

  Stream get stream => _controller.stream;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get lives => _prefs.getInt(_keyLives) ?? _defaultLives;

  set lives(int value) => _setInt(_keyLives, value);

  void clearLives() => _remove(_keyLives);

  Difficulty get difficulty => Difficulty
      .values[_prefs.getInt(_keyDifficulty) ?? Difficulty.normal.index];

  set difficulty(Difficulty value) => _setInt(_keyDifficulty, value.index);

  int? get colorIndex => _prefs.getInt(_keyColorIndex);

  set colorIndex(int? value) {
    if (value == null) {
      _remove(_keyColorIndex);
    } else {
      _setInt(_keyColorIndex, value);
    }
  }

  void updateCurrentHighScore(int score) {
    if (score > (currentHighScore ?? 0)) {
      _setInt(difficulty.highScoreKey, score);
    }
  }

  int? get currentHighScore => _prefs.getInt(difficulty.highScoreKey);

  void _setInt(String key, int value) {
    _prefs.setInt(key, value);
    _notify();
  }

  void _remove(String key) {
    _prefs.remove(key);
    _notify();
  }

  void _notify() => _controller.add(null);
}
