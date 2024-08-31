import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/properties_manager.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mobile/wrappers/device_info_wrapper.dart';
import 'package:mobile/wrappers/http_wrapper.dart';
import 'package:mobile/wrappers/internet_address_wrapper.dart';
import 'package:mobile/wrappers/package_info_wrapper.dart';
import 'package:mobile/wrappers/platform_wrapper.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:mobile/wrappers/rewarded_ad_wrapper.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

class StubbedManagers {
  late final MockLivesManager livesManager;
  late final MockPreferenceManager preferenceManager;
  late final MockPropertiesManager propertiesManager;
  late final MockTimeManager timeManager;

  late final MockDeviceInfoWrapper deviceInfoWrapper;
  late final MockHttpWrapper httpWrapper;
  late final MockInternetAddressWrapper internetAddressWrapper;
  late final MockPackageInfoWrapper packageInfoWrapper;
  late final MockPlatformWrapper platformWrapper;
  late final MockPurchasesWrapper purchasesWrapper;
  late final MockRewardedAdWrapper rewardedAdWrapper;
  late final MockUrlLauncherWrapper urlLauncherWrapper;

  StubbedManagers() {
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

    timeManager = MockTimeManager();
    when(timeManager.millisSinceEpoch)
        .thenReturn(DateTime.now().millisecondsSinceEpoch);
    TimeManager.set(timeManager);

    deviceInfoWrapper = MockDeviceInfoWrapper();
    DeviceInfoWrapper.set(deviceInfoWrapper);

    httpWrapper = MockHttpWrapper();
    HttpWrapper.set(httpWrapper);

    internetAddressWrapper = MockInternetAddressWrapper();
    InternetAddressWrapper.set(internetAddressWrapper);

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
