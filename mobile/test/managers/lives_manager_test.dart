import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockPreferenceManager preferenceManager;

  setUp(() {
    preferenceManager = MockPreferenceManager();
    when(preferenceManager.clearLives()).thenAnswer((_) {});
    PreferenceManager.set(preferenceManager);

    LivesManager.suicide();
  });

  test("lives", () {
    when(preferenceManager.lives).thenReturn(3);
    expect(LivesManager.get.lives, 3);
  });

  test("canPlay", () {
    when(preferenceManager.lives).thenReturn(3);
    expect(LivesManager.get.canPlay, true);

    when(preferenceManager.lives).thenReturn(0);
    expect(LivesManager.get.canPlay, false);
  });

  test("loseLife", () {
    LivesManager.get.stream
        .listen(expectAsync1((value) => expect(value, null)));

    when(preferenceManager.lives).thenReturn(3);
    LivesManager.get.loseLife();

    verify(preferenceManager.lives = 2).called(1);
  });

  test("reset", () {
    LivesManager.get.stream
        .listen(expectAsync1((value) => expect(value, null)));
    LivesManager.get.reset();
    verify(preferenceManager.clearLives()).called(1);
  });
}
