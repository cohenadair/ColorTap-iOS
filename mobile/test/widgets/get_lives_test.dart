import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/widgets/animated_visibility.dart';
import 'package:mobile/widgets/get_lives.dart';
import 'package:mobile/widgets/loading.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();

    when(managers.platformWrapper.isDebug).thenReturn(true);
    when(managers.platformWrapper.isAndroid).thenReturn(true);
  });

  Loading loadingAt(WidgetTester tester, int index) {
    return tester.widgetList(find.byType(Loading)).toList()[index] as Loading;
  }

  AnimatedVisibility animatedVisibilityAt(WidgetTester tester, int index) {
    return tester.widgetList(find.byType(AnimatedVisibility)).toList()[index]
        as AnimatedVisibility;
  }

  void stubForAdsTap() {
    when(managers.connectionWrapper.hasInternetAddress)
        .thenAnswer((_) => Future.value(true));
    when(managers.rewardedAdWrapper.load(
      adUnitId: anyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    )).thenAnswer((realInvocation) => Future.value());
  }

  Future<void> pumpDefaultGetLives(WidgetTester tester) async {
    stubPurchasesOfferings(managers);
    await pumpContext(tester, (_) => const Scaffold(body: GetLives("Test")));
    await tester.pump(); // Extra pump to complete the future.
  }

  testWidgets("Offerings are loaded on startup", (tester) async {
    var offerings = stubPurchasesOfferings(managers);
    when(managers.purchasesWrapper.getOfferings()).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 10),
        () => offerings,
      ),
    );
    await pumpContext(tester, (_) => const Scaffold(body: GetLives("Test")));

    // Verify loading state.
    expect(loadingAt(tester, 0).isVisible, isTrue);
    expect(animatedVisibilityAt(tester, 0).isVisible, isFalse);
    expect(find.text("0"), findsNWidgets(3));

    // Exhaust fetch future.
    await tester.pump(const Duration(milliseconds: 50));

    // Verify loaded state.
    expect(loadingAt(tester, 0).isVisible, isFalse);
    expect(animatedVisibilityAt(tester, 0).isVisible, isTrue);
    expect(find.text("0"), findsNothing);
    expect(find.text("15"), findsOneWidget);
    expect(find.text("75"), findsOneWidget);
    expect(find.text("500"), findsOneWidget);
  });

  testWidgets("Offerings are loaded with metadata", (tester) async {
    var offerings = stubPurchasesOfferings(managers, {
      "adReward": 50,
      "livesOneReward": 80,
      "livesTwoReward": 500,
      "livesThreeReward": 1000,
    });
    when(managers.purchasesWrapper.getOfferings())
        .thenAnswer((_) => Future.value(offerings));
    await pumpContext(tester, (_) => const Scaffold(body: GetLives("Test")));
    await tester.pump();

    // Verify loaded state.
    expect(loadingAt(tester, 0).isVisible, isFalse);
    expect(animatedVisibilityAt(tester, 0).isVisible, isTrue);
    expect(find.text("0"), findsNothing);
    expect(
      find.text("Watching a short ad will earn you 50 lives."),
      findsOneWidget,
    );
    expect(find.text("80"), findsOneWidget);
    expect(find.text("500"), findsOneWidget);
    expect(find.text("1000"), findsOneWidget);
  });

  testWidgets("Offering doesn't have required package", (tester) async {
    var offerings = buildPurchasesOfferings([
      buildPurchasesPackage(id: "lives-1", price: "0.99"),
      buildPurchasesPackage(id: "lives-2", price: "2.99"),
      // One ID that doesn't match an tier.
      buildPurchasesPackage(id: "lives-4", price: "9.99"),
    ]);
    when(managers.purchasesWrapper.getOfferings())
        .thenAnswer((_) => Future.value(offerings));
    await pumpContext(tester, (_) => const Scaffold(body: GetLives("Test")));
    await tester.pump(); // Extra pump to complete the future.

    expect(find.text("15"), findsOneWidget);
    expect(find.text("75"), findsOneWidget);
    expect(find.text("500"), findsNothing);
    expect(find.text("lives for"), findsNWidgets(2));
  });

  testWidgets("Purchase shows loading widget for purchased product only",
      (tester) async {
    when(managers.purchasesManager.purchase(any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 10), () => null));

    await pumpDefaultGetLives(tester);

    // Make a purchase.
    await tester.tap(find.text("15"));
    await tester.pump();

    expect(loadingAt(tester, 1).isVisible, isTrue);
    expect(animatedVisibilityAt(tester, 1).isVisible, isFalse);
    verify(managers.purchasesManager.purchase(any)).called(1);

    // Try to make other purchases while one is in progress. Tests that
    // multiple purchases can't be made at once.
    await tester.tap(find.text("75"));
    await tester.pump();
    expect(loadingAt(tester, 2).isVisible, isFalse);
    expect(animatedVisibilityAt(tester, 2).isVisible, isTrue);
    verifyNever(managers.purchasesManager.purchase(any));

    await tester.tap(find.text("500"));
    await tester.pump();
    expect(loadingAt(tester, 3).isVisible, isFalse);
    expect(animatedVisibilityAt(tester, 3).isVisible, isTrue);
    verifyNever(managers.purchasesManager.purchase(any));

    // Exhaust timers.
    await tester.pump(const Duration(milliseconds: 10));
  });

  testWidgets("Purchase is successful", (tester) async {
    var customerInfo = MockCustomerInfo();
    when(managers.purchasesManager.purchase(any))
        .thenAnswer((_) => Future.value(customerInfo));

    await pumpDefaultGetLives(tester);

    // Make a purchase.
    await tester.tap(find.text("15"));
    await tester.pump();

    expect(loadingAt(tester, 1).isVisible, isFalse);
    expect(animatedVisibilityAt(tester, 1).isVisible, isTrue);
    verify(managers.purchasesManager.purchase(any)).called(1);
  });

  testWidgets("Ad loading icon is shown", (tester) async {
    stubForAdsTap();

    await pumpDefaultGetLives(tester);

    expect(find.byType(Loading), findsNWidgets(4));

    await tester.tap(find.text("Watch Short Ad"));
    await tester.pump();

    expect(find.byType(Loading), findsNWidgets(5));
    verify(managers.connectionWrapper.hasInternetAddress).called(1);
    verify(managers.rewardedAdWrapper.load(
      adUnitId: anyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    )).called(1);
  });

  testWidgets("Ad loading icon is hidden", (tester) async {
    await pumpDefaultGetLives(tester);
    expect(
      find.descendant(
        of: find.widgetWithText(FilledButton, "Watch Short Ad"),
        matching: find.byType(Loading),
      ),
      findsNothing,
    );
  });

  testWidgets("Tapping ad button is a no-op if already loading",
      (tester) async {
    when(managers.connectionWrapper.hasInternetAddress)
        .thenAnswer((_) => Future.value(true));
    when(managers.rewardedAdWrapper.load(
      adUnitId: anyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    )).thenAnswer(
        (realInvocation) => Future.delayed(const Duration(milliseconds: 10)));

    await pumpDefaultGetLives(tester);

    await tester.tap(find.text("Watch Short Ad"));
    await tester.pump();

    expect(find.byType(Loading), findsNWidgets(5));
    verify(managers.connectionWrapper.hasInternetAddress).called(1);

    // Tap again while already loading.
    await tester.tap(find.text("Watch Short Ad"));
    await tester.pump();
    verifyNever(managers.connectionWrapper.hasInternetAddress);

    // Exhaust timers.
    await tester.pump(const Duration(milliseconds: 10));
  });

  testWidgets("Error is shown if there's no network", (tester) async {
    when(managers.connectionWrapper.hasInternetAddress)
        .thenAnswer((_) => Future.value(false));

    await pumpDefaultGetLives(tester);

    await tester.tap(find.text("Watch Short Ad"));
    await tester.pump();

    expect(
      find.text(
          "No internet connection. Please check your connection and try again."),
      findsOneWidget,
    );
    verifyNever(managers.rewardedAdWrapper.load(
      adUnitId: anyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    ));
  });

  testWidgets("Lives increase after rewarded ad", (tester) async {
    stubForAdsTap();

    await pumpDefaultGetLives(tester);
    await tester.tap(find.text("Watch Short Ad"));
    await tester.pump();

    var result = verify(managers.rewardedAdWrapper.load(
      adUnitId: anyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: captureAnyNamed("rewardedAdLoadCallback"),
    ));
    result.called(1);

    var ad = MockRewardedAd();
    when(ad.show(onUserEarnedReward: anyNamed("onUserEarnedReward")))
        .thenAnswer((invocation) {
      (invocation.namedArguments[const Symbol("onUserEarnedReward")]
          as OnUserEarnedRewardCallback)(ad, RewardItem(0, ""));
      return Future.value();
    });
    var callback = result.captured.first as RewardedAdLoadCallback;
    callback.onAdLoaded(ad);

    await tester.pump();
    expect(find.byType(Loading), findsNWidgets(4));
    verify(managers.livesManager.rewardWatchedAd(10)).called(1);
    verifyNever(managers.livesManager.rewardAdError());
  });

  testWidgets("Lives increase after a failed ad", (tester) async {
    stubForAdsTap();

    await pumpDefaultGetLives(tester);
    await tester.tap(find.text("Watch Short Ad"));
    await tester.pump();

    var result = verify(managers.rewardedAdWrapper.load(
      adUnitId: anyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: captureAnyNamed("rewardedAdLoadCallback"),
    ));
    result.called(1);

    var callback = result.captured.first as RewardedAdLoadCallback;
    callback.onAdFailedToLoad(LoadAdError(0, "", "", null));

    await tester.pump();
    expect(find.byType(Loading), findsNWidgets(4));
    verifyNever(managers.livesManager.rewardWatchedAd(null));

    // Dismiss error dialog.
    await tester.tap(find.text("Ok"));
    await tester.pump();
    verify(managers.livesManager.rewardAdError()).called(1);
  });

  testWidgets("Test Android ad unit IDs are used for debug builds",
      (tester) async {
    stubForAdsTap();
    when(managers.platformWrapper.isDebug).thenReturn(true);
    when(managers.platformWrapper.isAndroid).thenReturn(true);

    await pumpDefaultGetLives(tester);
    await tester.tap(find.text("Watch Short Ad"));

    var result = verify(managers.rewardedAdWrapper.load(
      adUnitId: captureAnyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    ));
    result.called(1);

    var id = result.captured.first as String;
    expect(id, "ca-app-pub-3940256099942544/5224354917");
  });

  testWidgets("Test iOS ad unit IDs are used for debug builds", (tester) async {
    stubForAdsTap();
    when(managers.platformWrapper.isDebug).thenReturn(true);
    when(managers.platformWrapper.isAndroid).thenReturn(false);

    await pumpDefaultGetLives(tester);
    await tester.tap(find.text("Watch Short Ad"));

    var result = verify(managers.rewardedAdWrapper.load(
      adUnitId: captureAnyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    ));
    result.called(1);

    var id = result.captured.first as String;
    expect(id, "ca-app-pub-3940256099942544/1712485313");
  });

  testWidgets("Valid Android ad unit IDs are used for non-debug builds",
      (tester) async {
    stubForAdsTap();
    when(managers.platformWrapper.isDebug).thenReturn(false);
    when(managers.platformWrapper.isAndroid).thenReturn(true);
    when(managers.propertiesManager.adUnitIdAndroid).thenReturn("Android");

    await pumpDefaultGetLives(tester);
    await tester.tap(find.text("Watch Short Ad"));

    var result = verify(managers.rewardedAdWrapper.load(
      adUnitId: captureAnyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    ));
    result.called(1);

    expect(result.captured.first as String, "Android");
    verify(managers.propertiesManager.adUnitIdAndroid).called(1);
    verifyNever(managers.propertiesManager.adUnitIdApple);
  });

  testWidgets("Valid iOS ad unit IDs are used for non-debug builds",
      (tester) async {
    stubForAdsTap();
    when(managers.platformWrapper.isDebug).thenReturn(false);
    when(managers.platformWrapper.isAndroid).thenReturn(false);
    when(managers.propertiesManager.adUnitIdApple).thenReturn("iOS");

    await pumpDefaultGetLives(tester);
    await tester.tap(find.text("Watch Short Ad"));

    var result = verify(managers.rewardedAdWrapper.load(
      adUnitId: captureAnyNamed("adUnitId"),
      request: anyNamed("request"),
      rewardedAdLoadCallback: anyNamed("rewardedAdLoadCallback"),
    ));
    result.called(1);

    expect(result.captured.first as String, "iOS");
    verify(managers.propertiesManager.adUnitIdApple).called(1);
    verifyNever(managers.propertiesManager.adUnitIdAndroid);
  });
}
