import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/stats_manager.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = StubbedManagers();

    when(managers.preferenceManager.difficultyStats).thenReturn({});
    when(managers.preferenceManager.difficultyStats = any).thenAnswer((_) {});
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);

    StatsManager.suicide();
    await StatsManager.get.init();
  });

  test("Stats default to empty values", () {
    when(managers.preferenceManager.difficultyStats).thenReturn({});

    var stats = StatsManager.get.currentDifficultyStats;
    expect(stats.difficultyIndex, Difficulty.normal.index);
    expect(stats.highScore, 0);
    expect(stats.gamesPlayed, 0);
  });

  test("incCurrentGamesPlayed", () {
    expect(StatsManager.get.currentGamesPlayed, 0);
    StatsManager.get.incCurrentGamesPlayed();
    expect(StatsManager.get.currentGamesPlayed, 1);
  });

  test("updateCurrentHighScore", () {
    expect(StatsManager.get.currentHighScore, 0);
    StatsManager.get.updateCurrentHighScore(50);
    expect(StatsManager.get.currentHighScore, 50);
  });
}
