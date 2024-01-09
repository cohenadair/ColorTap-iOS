import 'package:flutter/material.dart';
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

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get lives => _prefs.getInt(_keyLives) ?? _defaultLives;

  set lives(int value) => _prefs.setInt(_keyLives, value);

  void clearLives() => _prefs.remove(_keyLives);
}
