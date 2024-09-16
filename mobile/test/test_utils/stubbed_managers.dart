import 'package:mobile/managers/audio_manager.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/properties_manager.dart';
import 'package:mobile/managers/purchases_manager.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mobile/wrappers/device_info_wrapper.dart';
import 'package:mobile/wrappers/fgbg_wrapper.dart';
import 'package:mobile/wrappers/flame_audio_wrapper.dart';
import 'package:mobile/wrappers/http_wrapper.dart';
import 'package:mobile/wrappers/connection_wrapper.dart';
import 'package:mobile/wrappers/package_info_wrapper.dart';
import 'package:mobile/wrappers/platform_wrapper.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:mobile/wrappers/rewarded_ad_wrapper.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

class StubbedManagers {
  late final MockAudioManager audioManager;
  late final MockLivesManager livesManager;
  late final MockPreferenceManager preferenceManager;
  late final MockPropertiesManager propertiesManager;
  late final MockPurchasesManager purchasesManager;
  late final MockTimeManager timeManager;

  late final MockDeviceInfoWrapper deviceInfoWrapper;
  late final MockFgbgWrapper fgbgWrapper;
  late final MockFlameAudioWrapper flameAudioWrapper;
  late final MockHttpWrapper httpWrapper;
  late final MockConnectionWrapper connectionWrapper;
  late final MockPackageInfoWrapper packageInfoWrapper;
  late final MockPlatformWrapper platformWrapper;
  late final MockPurchasesWrapper purchasesWrapper;
  late final MockRewardedAdWrapper rewardedAdWrapper;
  late final MockUrlLauncherWrapper urlLauncherWrapper;

  StubbedManagers() {
    audioManager = MockAudioManager();
    when(audioManager.onButtonPressed(any)).thenAnswer(
        (invocation) => invocation.positionalArguments.first ?? () {});
    AudioManager.set(audioManager);

    livesManager = MockLivesManager();
    when(livesManager.stream).thenAnswer((_) => const Stream.empty());
    LivesManager.set(livesManager);

    preferenceManager = MockPreferenceManager();
    when(preferenceManager.init()).thenAnswer((_) => Future.value());
    when(preferenceManager.stream).thenAnswer((_) => const Stream.empty());
    PreferenceManager.set(preferenceManager);

    propertiesManager = MockPropertiesManager();
    when(propertiesManager.init()).thenAnswer((_) => Future.value());
    PropertiesManager.set(propertiesManager);

    purchasesManager = MockPurchasesManager();
    when(purchasesManager.init()).thenAnswer((_) => Future.value());
    PurchasesManager.set(purchasesManager);

    timeManager = MockTimeManager();
    when(timeManager.millisSinceEpoch)
        .thenReturn(DateTime.now().millisecondsSinceEpoch);
    TimeManager.set(timeManager);

    fgbgWrapper = MockFgbgWrapper();
    when(fgbgWrapper.stream).thenAnswer((_) => const Stream.empty());
    FgbgWrapper.set(fgbgWrapper);

    flameAudioWrapper = MockFlameAudioWrapper();
    FlameAudioWrapper.set(flameAudioWrapper);

    deviceInfoWrapper = MockDeviceInfoWrapper();
    DeviceInfoWrapper.set(deviceInfoWrapper);

    httpWrapper = MockHttpWrapper();
    HttpWrapper.set(httpWrapper);

    connectionWrapper = MockConnectionWrapper();
    ConnectionWrapper.set(connectionWrapper);

    packageInfoWrapper = MockPackageInfoWrapper();
    PackageInfoWrapper.set(packageInfoWrapper);

    platformWrapper = MockPlatformWrapper();
    PlatformWrapper.set(platformWrapper);

    purchasesWrapper = MockPurchasesWrapper();
    PurchasesWrapper.set(purchasesWrapper);

    urlLauncherWrapper = MockUrlLauncherWrapper();
    UrlLauncherWrapper.set(urlLauncherWrapper);

    rewardedAdWrapper = MockRewardedAdWrapper();
    RewardedAdWrapper.set(rewardedAdWrapper);
  }
}
