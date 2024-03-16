import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();
    when(managers.urlLauncherWrapper.launch(any))
        .thenAnswer((_) => Future.value(true));

    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    when(managers.preferenceManager.colorIndex).thenReturn(null);
  });

  testWidgets("Privacy link opens privacy policy", (tester) async {
    await pumpContext(tester, (_) => SettingsPage());
    await tapAndSettle(tester, find.text("Privacy Policy"));

    var result = verify(managers.urlLauncherWrapper.launch(captureAny));
    result.called(1);
    expect((result.captured.first as String).contains("privacy.html"), isTrue);
  });

  testWidgets("Difficulty selection", (tester) async {
    await pumpContext(tester, (_) => SettingsPage());

    // Verify all options are available.
    await tapAndSettle(tester, find.text("Normal"));
    expect(find.text("Kids"), findsOneWidget);
    expect(find.text("Easy"), findsOneWidget);
    expect(find.text("Normal"), findsNWidgets(2));
    expect(find.text("Hard"), findsOneWidget);
    expect(find.text("Expert"), findsOneWidget);

    // Select each difficulty, verifying they are saved.

    // Kids.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.kids);
    await tapAndSettle(tester, find.text("Kids"));
    var result = verify(managers.preferenceManager.difficulty = captureAny);
    result.called(1);
    expect(result.captured.first as Difficulty, Difficulty.kids);
    verifyNever(managers.preferenceManager.colorIndex = any);

    // Easy.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.easy);
    await tapAndSettle(tester, find.text("Normal"));
    await tapAndSettle(tester, find.text("Easy"));
    result = verify(managers.preferenceManager.difficulty = captureAny);
    result.called(1);
    expect(result.captured.first as Difficulty, Difficulty.easy);
    verify(managers.preferenceManager.colorIndex = any).called(1);

    // Normal.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    await tapAndSettle(tester, find.text("Normal").first);
    await tapAndSettle(tester, find.text("Normal").last);
    result = verify(managers.preferenceManager.difficulty = captureAny);
    result.called(1);
    expect(result.captured.first as Difficulty, Difficulty.normal);
    verify(managers.preferenceManager.colorIndex = any).called(1);

    // Hard.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    await tapAndSettle(tester, find.text("Normal").first);
    await tapAndSettle(tester, find.text("Hard").last);
    result = verify(managers.preferenceManager.difficulty = captureAny);
    result.called(1);
    expect(result.captured.first as Difficulty, Difficulty.hard);
    verify(managers.preferenceManager.colorIndex = any).called(1);

    // Expert.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.expert);
    await tapAndSettle(tester, find.text("Normal").first);
    await tapAndSettle(tester, find.text("Expert").last);
    result = verify(managers.preferenceManager.difficulty = captureAny);
    result.called(1);
    expect(result.captured.first as Difficulty, Difficulty.expert);
    verify(managers.preferenceManager.colorIndex = any).called(1);
  });

  testWidgets("Color selection info dialog is shown", (tester) async {
    await pumpContext(tester, (_) => SettingsPage());
    await tapAndSettle(tester, find.byIcon(Icons.info_outline));
    expect(find.text("Colour"), findsNWidgets(2)); // Settings + dialog

    // Clear dialog.
    await tapAndSettle(tester, find.text("Ok"));
    expect(find.text("Colour"), findsOneWidget); // Settings
  });
}
