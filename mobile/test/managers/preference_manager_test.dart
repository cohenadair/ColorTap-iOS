import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> stubValues(Map<String, Object> values) {
    SharedPreferences.setMockInitialValues(values);
    PreferenceManager.suicide();
    return PreferenceManager.get.init();
  }

  test("lives returns saved value", () async {
    await stubValues({"lives": 1});
    expect(PreferenceManager.get.lives, 1);
  });

  test("lives default value", () async {
    await stubValues({});
    expect(PreferenceManager.get.lives, 10);
  });

  test("clearLives", () async {
    await stubValues({"lives": 1});
    PreferenceManager.get.clearLives();
    expect(PreferenceManager.get.lives, 10);
  });

  test("Set lives", () async {
    await stubValues({"lives": 1});
    PreferenceManager.get.lives = 15;
    expect(PreferenceManager.get.lives, 15);
  });

  test("difficulty returns saved value", () async {
    await stubValues({"difficulty": Difficulty.hard.index});
    expect(PreferenceManager.get.difficulty, Difficulty.hard);
  });

  test("difficulty default value", () async {
    await stubValues({});
    expect(PreferenceManager.get.difficulty, Difficulty.normal);
  });

  test("difficulty is set", () async {
    await stubValues({});
    PreferenceManager.get.difficulty = Difficulty.expert;
    expect(PreferenceManager.get.difficulty, Difficulty.expert);
  });

  test("colorIndex returns saved value", () async {
    await stubValues({"color_index": 1});
    expect(PreferenceManager.get.colorIndex, 1);
  });

  test("colorIndex is set", () async {
    await stubValues({});

    PreferenceManager.get.colorIndex = 1;
    expect(PreferenceManager.get.colorIndex, 1);

    PreferenceManager.get.colorIndex = null;
    expect(PreferenceManager.get.colorIndex, null);
  });

  test("High score is set from nothing", () async {
    await stubValues({"difficulty": 1});
    expect(PreferenceManager.get.currentHighScore, isNull);

    PreferenceManager.get.updateCurrentHighScore(50);
    expect(PreferenceManager.get.currentHighScore, 50);
  });

  test("High score overrides old value", () async {
    await stubValues({
      "difficulty": 1,
      Difficulty.easy.highScoreKey: 50,
    });
    expect(PreferenceManager.get.currentHighScore, 50);

    PreferenceManager.get.updateCurrentHighScore(75);
    expect(PreferenceManager.get.currentHighScore, 75);
  });

  test("Setting high score that is too low", () async {
    await stubValues({
      "difficulty": 1,
      Difficulty.easy.highScoreKey: 50,
    });
    expect(PreferenceManager.get.currentHighScore, 50);

    PreferenceManager.get.updateCurrentHighScore(40);
    expect(PreferenceManager.get.currentHighScore, 50);
  });
}
