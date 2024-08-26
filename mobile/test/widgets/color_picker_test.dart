import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/target_color.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/widgets/color_picker.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/test_utils.dart';

void main() {
  late MockPreferenceManager preferenceManager;

  setUp(() {
    preferenceManager = MockPreferenceManager();
    PreferenceManager.set(preferenceManager);

    when(preferenceManager.stream).thenAnswer((_) => const Stream.empty());
    when(preferenceManager.difficulty).thenReturn(Difficulty.kids);
    when(preferenceManager.colorIndex).thenReturn(null);
  });

  Finder findCircles() {
    return find.byWidgetPredicate((widget) =>
        widget is Container &&
        (widget.decoration as BoxDecoration).shape == BoxShape.circle);
  }

  testWidgets("Picker is disabled", (tester) async {
    when(preferenceManager.difficulty).thenReturn(Difficulty.normal);
    await pumpContext(tester, (_) => ColorPicker());

    expect(
      tester.firstWidget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      opacityDisabled,
    );
  });

  testWidgets("Picker is enabled", (tester) async {
    when(preferenceManager.difficulty).thenReturn(Difficulty.kids);
    await pumpContext(tester, (_) => ColorPicker());

    expect(
      tester.firstWidget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1.0,
    );
  });

  testWidgets("Picker shows selected color", (tester) async {
    when(preferenceManager.colorIndex).thenReturn(2); // Yellow.
    await pumpContext(tester, (_) => ColorPicker());

    var opacityWidgets = tester
        .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
        .toList();
    expect(opacityWidgets.length, 5);
    expect(opacityWidgets[2].opacity, 1.0); // Check icon for "orange" .
  });

  testWidgets("Picker shows no selected color when preferences is null",
      (tester) async {
    when(preferenceManager.colorIndex).thenReturn(null);
    await pumpContext(tester, (_) => ColorPicker());

    var opacityWidgets = tester
        .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
        .toList();
    expect(opacityWidgets.length, 5);

    // No check icons are visible.
    for (var widget in opacityWidgets.sublist(1)) {
      expect(widget.opacity, 0.0);
    }
  });

  testWidgets("All expected colors are shown", (tester) async {
    await pumpContext(tester, (_) => ColorPicker());
    expect(findCircles(), findsNWidgets(TargetColor.kids().length));
  });

  testWidgets("Picking a color updates preferences", (tester) async {
    when(preferenceManager.colorIndex).thenReturn(null);
    await pumpContext(tester, (_) => ColorPicker());

    // Select.
    await tapAndSettle(tester, findCircles().first);
    var result = verify(preferenceManager.colorIndex = captureAny);
    result.called(1);
    expect(result.captured.first, 0);
  });

  testWidgets("Picking a color sets preferences to null", (tester) async {
    when(preferenceManager.colorIndex).thenReturn(0);
    await pumpContext(tester, (_) => ColorPicker());

    // Deselect.
    await tapAndSettle(tester, findCircles().first);
    var result = verify(preferenceManager.colorIndex = captureAny);
    result.called(1);
    expect(result.captured.first, isNull);
  });

  testWidgets("Picker updates when preferences updates", (tester) async {
    var controller = StreamController.broadcast();
    when(preferenceManager.stream).thenAnswer((_) => controller.stream);

    await pumpContext(tester, (_) => ColorPicker());

    // Verify enabled.
    expect(
      tester.firstWidget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1.0,
    );

    when(preferenceManager.difficulty).thenReturn(Difficulty.normal);
    controller.add(null);
    await tester.pump(const Duration(milliseconds: 500));

    // Verify disabled.
    expect(
      tester.firstWidget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      opacityDisabled,
    );
  });
}
