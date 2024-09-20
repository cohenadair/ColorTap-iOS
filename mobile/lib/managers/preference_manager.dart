import 'dart:async';
import 'dart:convert';

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
  static const _keyUserName = "user_name";
  static const _keyUserEmail = "user_email";
  static const _keyMusicOn = "is_music_on";
  static const _keySoundOn = "is_sound_on";
  static const _keyFpsOn = "is_fps_on";
  static const _keyDifficultyStats = "difficulty_stats";

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

  set userName(String? value) => _setString(_keyUserName, value ?? "");

  String? get userName => _prefs.getString(_keyUserName);

  set userEmail(String? value) => _setString(_keyUserEmail, value ?? "");

  String? get userEmail => _prefs.getString(_keyUserEmail);

  bool get isSoundOn => _prefs.getBool(_keySoundOn) ?? true;

  set isSoundOn(bool value) => _setBool(_keySoundOn, value);

  bool get isMusicOn => _prefs.getBool(_keyMusicOn) ?? true;

  set isMusicOn(bool value) => _setBool(_keyMusicOn, value);

  bool get isFpsOn => _prefs.getBool(_keyFpsOn) ?? false;

  set isFpsOn(bool value) => _setBool(_keyFpsOn, value);

  Map<int, DifficultyStats> get difficultyStats =>
      _jsonMap(_keyDifficultyStats).map((key, value) =>
          MapEntry(int.parse(key), DifficultyStats.fromJson(value)));

  set difficultyStats(Map<int, DifficultyStats> value) => _setJsonMap(
      _keyDifficultyStats,
      value.map((key, stats) => MapEntry(key.toString(), stats.toJson())));

  void _setInt(String key, int value) {
    _prefs.setInt(key, value);
    _notify();
  }

  void _setString(String key, String value) {
    _prefs.setString(key, value);
    _notify();
  }

  void _setBool(String key, bool value) {
    _prefs.setBool(key, value);
    _notify();
  }

  void _setJsonMap(String key, Map<String, Map<String, dynamic>> json) {
    _prefs.setString(key, jsonEncode(json));
    _notify();
  }

  Map<String, Map<String, dynamic>> _jsonMap(String key) {
    return (jsonDecode(_prefs.getString(key) ?? "{}") as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
  }

  void _remove(String key) {
    _prefs.remove(key);
    _notify();
  }

  void _notify() => _controller.add(null);
}
