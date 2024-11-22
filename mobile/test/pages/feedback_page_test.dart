import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mobile/pages/feedback_page.dart';
import 'package:mobile/widgets/loading.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();

    when(managers.preferenceManager.userName).thenReturn("Cohen");
    when(managers.preferenceManager.userEmail).thenReturn("test@test.com");
    when(managers.preferenceManager.userName = any).thenAnswer((_) {});
    when(managers.preferenceManager.userEmail = any).thenAnswer((_) {});

    when(managers.platformWrapper.isIOS).thenReturn(true);
    when(managers.platformWrapper.isAndroid).thenReturn(false);

    when(managers.propertiesManager.supportEmail)
        .thenReturn("support@test.com");
    when(managers.propertiesManager.clientSenderEmail)
        .thenReturn("sender@test.com");
    when(managers.propertiesManager.feedbackTemplate).thenReturn("""
      App version: %s
      OS version: %s
      Device: %s
      Device ID: %s
      RevenueCat ID: %s

      Name: %s
      Email: %s
      Message: %s
    """);
    when(managers.propertiesManager.sendGridApiKey).thenReturn("API KEY");

    when(managers.connectionWrapper.hasInternetAddress)
        .thenAnswer((_) => Future.value(true));

    when(managers.packageInfoWrapper.fromPlatform()).thenAnswer(
      (_) => Future.value(PackageInfo(
        appName: "Test App",
        packageName: "app.test.com",
        version: "1",
        buildNumber: "1000",
      )),
    );

    when(managers.purchasesManager.userId())
        .thenAnswer((_) => Future.value("TestUserID"));

    when(managers.httpWrapper.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 50),
        () => Response("", HttpStatus.accepted),
      ),
    );
  });

  testWidgets("Text fields are initially empty", (tester) async {
    when(managers.preferenceManager.userName).thenReturn(null);
    when(managers.preferenceManager.userEmail).thenReturn(null);

    await pumpContext(tester, (_) => const FeedbackPage());

    expect(
      findFirstWithText<TextFormField>(tester, "Name").controller?.text,
      "",
    );
    expect(
      findFirstWithText<TextField>(tester, "Name").autofocus,
      isTrue,
    );
    expect(
      findFirstWithText<TextFormField>(tester, "Email").controller?.text,
      "",
    );
    expect(
      findFirstWithText<TextField>(tester, "Message").autofocus,
      isFalse,
    );
  });

  testWidgets("Text fields are initially set from preferences", (tester) async {
    when(managers.preferenceManager.userName).thenReturn("User Name");
    when(managers.preferenceManager.userEmail).thenReturn("useremail@test.com");

    await pumpContext(tester, (_) => const FeedbackPage());

    expect(
      findFirstWithText<TextFormField>(tester, "Name").controller?.text,
      "User Name",
    );
    expect(
      findFirstWithText<TextFormField>(tester, "Email").controller?.text,
      "useremail@test.com",
    );
    expect(
      findFirstWithText<TextField>(tester, "Message").autofocus,
      isTrue,
    );
  });

  testWidgets("Email field is validated", (tester) async {
    when(managers.preferenceManager.userName).thenReturn(null);
    when(managers.preferenceManager.userEmail).thenReturn(null);

    await pumpContext(tester, (_) => const FeedbackPage());

    // Email and message fields are both required.
    expect(find.text("Required"), findsNWidgets(2));

    await enterTextFieldAndSettle(tester, "Email", "not-a-real-email");
    expect(find.text("Invalid email format"), findsOneWidget);

    await enterTextFieldAndSettle(tester, "Email", "not-a-real-email@test.com");
    expect(find.text("Invalid email format"), findsNothing);
    expect(find.text("Required"), findsOneWidget);
  });

  testWidgets("Send button is shown when not sending", (tester) async {
    await pumpContext(tester, (_) => const FeedbackPage());
    expect(find.byIcon(Icons.send), findsOneWidget);
  });

  testWidgets("Send button shows validation error SnackBar", (tester) async {
    await pumpContext(tester, (_) => const FeedbackPage());
    await tapAndSettle(tester, find.byIcon(Icons.send));
    expect(
      find.text("Please fix all form errors before sending your feedback."),
      findsOneWidget,
    );
  });

  testWidgets("No network shows connection error SnackBar", (tester) async {
    when(managers.connectionWrapper.hasInternetAddress)
        .thenAnswer((_) => Future.value(false));

    await pumpContext(tester, (_) => const FeedbackPage());
    await enterTextFieldAndSettle(tester, "Message", "Test");
    await tapAndSettle(tester, find.byIcon(Icons.send));

    expect(
      find.text(
          "No internet connection. Please check your connection and try again."),
      findsOneWidget,
    );
  });

  testWidgets("iOS data is valid", (tester) async {
    when(managers.platformWrapper.isIOS).thenReturn(true);
    when(managers.deviceInfoWrapper.iosInfo).thenAnswer(
      (_) => Future.value(
        IosDeviceInfo.fromMap({
          "name": "iOS System",
          "systemName": "iOS System",
          "systemVersion": "1234",
          "model": "iPhone",
          "localizedModel": "iPhone",
          "utsname": {
            "sysname": "System Name",
            "nodename": "Node Name",
            "release": "Release",
            "version": "Version",
            "machine": "iPhone Name",
          },
          "identifierForVendor": "Vendor ID",
          "isPhysicalDevice": false,
        }),
      ),
    );

    await pumpContext(tester, (_) => const FeedbackPage());
    await enterTextFieldAndSettle(tester, "Message", "Test");
    await tapAndSettle(tester, find.byIcon(Icons.send));

    var result = verify(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: captureAnyNamed("body"),
      ),
    );
    result.called(1);

    String content = result.captured.first;
    expect(content.contains("iOS System"), isTrue);
    expect(content.contains("1234"), isTrue);
    expect(content.contains("iPhone Name"), isTrue);
    expect(content.contains("Vendor ID"), isTrue);
  });

  testWidgets("Android data is valid", (tester) async {
    when(managers.platformWrapper.isIOS).thenReturn(false);
    when(managers.platformWrapper.isAndroid).thenReturn(true);

    var buildVersion = MockAndroidBuildVersion();
    when(buildVersion.sdkInt).thenReturn(33);

    var deviceInfo = MockAndroidDeviceInfo();
    when(deviceInfo.version).thenReturn(buildVersion);
    when(deviceInfo.model).thenReturn("Pixel XL");
    when(deviceInfo.id).thenReturn("ABCD1234");

    when(managers.deviceInfoWrapper.androidInfo)
        .thenAnswer((_) => Future.value(deviceInfo));

    await pumpContext(tester, (_) => const FeedbackPage());
    await enterTextFieldAndSettle(tester, "Message", "Test");
    await tapAndSettle(tester, find.byIcon(Icons.send));

    var result = verify(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: captureAnyNamed("body"),
      ),
    );
    result.called(1);

    String content = result.captured.first;
    expect(content.contains("ABCD1234"), isTrue);
    expect(content.contains("Pixel XL"), isTrue);
    expect(content.contains("Android (33)"), isTrue);
  });

  testWidgets("HTTP error shows error text", (tester) async {
    when(managers.httpWrapper.post(
      any,
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) => Future.value(Response("", HttpStatus.badGateway)));

    when(managers.platformWrapper.isIOS).thenReturn(true);
    when(managers.deviceInfoWrapper.iosInfo).thenAnswer(
      (_) => Future.value(
        IosDeviceInfo.fromMap({
          "name": "iOS System",
          "systemName": "iOS System",
          "systemVersion": "1234",
          "model": "iPhone",
          "localizedModel": "iPhone",
          "utsname": {
            "sysname": "System Name",
            "nodename": "Node Name",
            "release": "Release",
            "version": "Version",
            "machine": "iPhone Name",
          },
          "identifierForVendor": "Vendor ID",
          "isPhysicalDevice": false,
        }),
      ),
    );

    await pumpContext(tester, (_) => const FeedbackPage());
    await enterTextFieldAndSettle(tester, "Message", "Test");
    await tapAndSettle(tester, find.byIcon(Icons.send));

    expect(
      find.text(
          "Error sending feedback. Please try again later, or email support@test.com directly."),
      findsOneWidget,
    );
  });

  testWidgets("Successful send", (tester) async {
    when(managers.preferenceManager.userName).thenReturn("User Name");
    when(managers.preferenceManager.userEmail).thenReturn("useremail@test.com");
    when(managers.connectionWrapper.hasInternetAddress)
        .thenAnswer((_) => Future.value(true));
    when(managers.platformWrapper.isIOS).thenReturn(true);
    when(managers.packageInfoWrapper.fromPlatform()).thenAnswer(
      (_) => Future.value(PackageInfo(
        appName: "Test App",
        packageName: "app.test.com",
        version: "1",
        buildNumber: "1000",
      )),
    );
    when(managers.deviceInfoWrapper.iosInfo).thenAnswer(
      (_) => Future.value(
        IosDeviceInfo.fromMap({
          "name": "iOS System",
          "systemName": "iOS System",
          "systemVersion": "1234",
          "model": "iPhone",
          "localizedModel": "iPhone",
          "utsname": {
            "sysname": "System Name",
            "nodename": "Node Name",
            "release": "Release",
            "version": "Version",
            "machine": "iPhone Name",
          },
          "identifierForVendor": "Vendor ID",
          "isPhysicalDevice": false,
        }),
      ),
    );

    await pumpContext(tester, (_) => const FeedbackPage());
    await enterTextFieldAndSettle(tester, "Message", "Test");

    // Send the message and verify loading indicator.
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    expect(find.byType(Loading), findsOneWidget);
    expect(find.byIcon(Icons.send), findsNothing);

    // Finish sending, verify ending state.
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(find.byType(Loading), findsNothing);
    expect(find.byIcon(Icons.send), findsOneWidget);
    verify(managers.preferenceManager.userName = "User Name").called(1);
    verify(managers.preferenceManager.userEmail = "useremail@test.com")
        .called(1);

    expect(
      find.text(
          "Message successfully sent. Please allow 1-2 business days for a reply."),
      findsOneWidget,
    );
    await tapAndSettle(tester, find.text("Ok"));
    expect(find.byType(FeedbackPage), findsNothing);
  });
}
