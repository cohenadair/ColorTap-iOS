import 'package:mobile/managers/properties_manager.dart';
import 'package:mobile/managers/purchases_manager.dart';
import 'package:mobile/wrappers/platform_wrapper.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:mockito/mockito.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:test/test.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockPurchasesWrapper purchasesWrapper;
  late MockPlatformWrapper platformWrapper;
  late MockPropertiesManager propertiesManager;

  setUp(() {
    purchasesWrapper = MockPurchasesWrapper();
    when(purchasesWrapper.setLogLevel(any)).thenAnswer((_) => Future.value());
    when(purchasesWrapper.configure(any)).thenAnswer((_) => Future.value());
    PurchasesWrapper.set(purchasesWrapper);

    platformWrapper = MockPlatformWrapper();
    when(platformWrapper.isDebug).thenReturn(true);
    when(platformWrapper.isAndroid).thenReturn(true);
    PlatformWrapper.set(platformWrapper);

    propertiesManager = MockPropertiesManager();
    when(propertiesManager.revenueCatKeyAndroid).thenReturn("android");
    when(propertiesManager.revenueCatKeyApple).thenReturn("apple");
    PropertiesManager.set(propertiesManager);
  });

  test("init verbose log", () async {
    when(platformWrapper.isDebug).thenReturn(true);
    await PurchasesManager.get.init();

    var result = verify(purchasesWrapper.setLogLevel(captureAny));
    result.called(1);
    expect(result.captured.first, LogLevel.verbose);
  });

  test("init error log", () async {
    when(platformWrapper.isDebug).thenReturn(false);
    await PurchasesManager.get.init();

    var result = verify(purchasesWrapper.setLogLevel(captureAny));
    result.called(1);
    expect(result.captured.first, LogLevel.error);
  });

  test("init for Android", () async {
    when(platformWrapper.isAndroid).thenReturn(true);
    await PurchasesManager.get.init();

    var result = verify(purchasesWrapper.configure(captureAny));
    result.called(1);
    expect(result.captured.first.apiKey, "android");
  });

  test("init for iOS", () async {
    when(platformWrapper.isAndroid).thenReturn(false);
    await PurchasesManager.get.init();

    var result = verify(purchasesWrapper.configure(captureAny));
    result.called(1);
    expect(result.captured.first.apiKey, "apple");
  });

  test("purchase throws loggable error", () async {
    var exception = MockPlatformException();
    when(exception.code)
        .thenReturn(PurchasesErrorCode.configurationError.index.toString());
    when(exception.message).thenReturn("Test error");
    when(purchasesWrapper.purchasePackage(any)).thenThrow(exception);

    expect(await PurchasesManager.get.purchase(MockPackage()), isNull);
    verify(exception.message).called(1);
  });

  test("purchase throws purchaseCancelledError error", () async {
    var exception = MockPlatformException();
    when(exception.code)
        .thenReturn(PurchasesErrorCode.purchaseCancelledError.index.toString());
    when(purchasesWrapper.purchasePackage(any)).thenThrow(exception);

    expect(await PurchasesManager.get.purchase(MockPackage()), isNull);
    verifyNever(exception.message);
  });

  test("purchase throws storeProblemError error", () async {
    var exception = MockPlatformException();
    when(exception.code)
        .thenReturn(PurchasesErrorCode.storeProblemError.index.toString());
    when(purchasesWrapper.purchasePackage(any)).thenThrow(exception);

    expect(await PurchasesManager.get.purchase(MockPackage()), isNull);
    verifyNever(exception.message);
  });
}
