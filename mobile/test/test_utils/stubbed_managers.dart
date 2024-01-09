import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

class StubbedManagers {
  late final LivesManager livesManager;
  late final PreferenceManager preferenceManager;
  late final TimeManager timeManager;

  StubbedManagers() {
    livesManager = MockLivesManager();
    when(livesManager.stream).thenAnswer((_) => const Stream.empty());
    LivesManager.set(livesManager);

    preferenceManager = MockPreferenceManager();
    when(preferenceManager.init()).thenAnswer((_) => Future.value());
    PreferenceManager.set(preferenceManager);

    timeManager = MockTimeManager();
    when(timeManager.millisSinceEpoch)
        .thenReturn(DateTime.now().millisecondsSinceEpoch);
    TimeManager.set(timeManager);
  }
}
