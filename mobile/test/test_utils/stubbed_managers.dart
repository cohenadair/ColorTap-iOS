import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

class StubbedManagers {
  late final MockLivesManager livesManager;
  late final MockPreferenceManager preferenceManager;
  late final MockTimeManager timeManager;

  late final MockPurchasesWrapper purchasesWrapper;
  late final MockUrlLauncherWrapper urlLauncherWrapper;

  StubbedManagers() {
    livesManager = MockLivesManager();
    when(livesManager.stream).thenAnswer((_) => const Stream.empty());
    LivesManager.set(livesManager);

    preferenceManager = MockPreferenceManager();
    when(preferenceManager.init()).thenAnswer((_) => Future.value());
    when(preferenceManager.stream).thenAnswer((_) => const Stream.empty());
    PreferenceManager.set(preferenceManager);

    timeManager = MockTimeManager();
    when(timeManager.millisSinceEpoch)
        .thenReturn(DateTime.now().millisecondsSinceEpoch);
    TimeManager.set(timeManager);

    purchasesWrapper = MockPurchasesWrapper();
    PurchasesWrapper.set(purchasesWrapper);

    urlLauncherWrapper = MockUrlLauncherWrapper();
    UrlLauncherWrapper.set(urlLauncherWrapper);
  }
}
