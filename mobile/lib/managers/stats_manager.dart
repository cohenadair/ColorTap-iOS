import 'package:flutter/foundation.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';

class StatsManager {
  static var _instance = StatsManager._();

  static StatsManager get get => _instance;

  @visibleForTesting
  static void set(StatsManager manager) => _instance = manager;

  @visibleForTesting
  static void suicide() => _instance = StatsManager._();

  StatsManager._();

  late final Map<int, DifficultyStats> _difficulties;

  Future<void> init() async {
    _difficulties = PreferenceManager.get.difficultyStats;
  }

  DifficultyStats get currentDifficultyStats =>
      _difficulties[_currentDifficultyIndex] ??
      DifficultyStats(difficultyIndex: _currentDifficultyIndex);

  int get currentHighScore => currentDifficultyStats.highScore;

  int get currentGamesPlayed => currentDifficultyStats.gamesPlayed;

  void incCurrentGamesPlayed() {
    _difficulties[_currentDifficultyIndex] =
        currentDifficultyStats.withIncedGamesPlayed();
    PreferenceManager.get.difficultyStats = _difficulties;
  }

  void updateCurrentHighScore(int newHighScore) {
    _difficulties[_currentDifficultyIndex] =
        currentDifficultyStats.withHighScore(newHighScore);
    PreferenceManager.get.difficultyStats = _difficulties;
  }

  int get _currentDifficultyIndex => PreferenceManager.get.difficulty.index;
}
