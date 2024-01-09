import 'package:flutter_test/flutter_test.dart';
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
}
