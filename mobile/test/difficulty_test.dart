import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';

import 'test_utils/test_utils.dart';

void main() {
  testWidgets("targetsPerRow for smaller devices", (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(599, 1000);
    expect(Difficulty.easy.targetsPerRow, 3);
  });

  testWidgets("targetsPerRow for smaller, high density devices",
      (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(1797, 1000);
    expect(Difficulty.easy.targetsPerRow, 3);
  });

  testWidgets("targetsPerRow for larger devices", (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(600, 1000);
    expect(Difficulty.easy.targetsPerRow, 4);
  });

  testWidgets("targetsPerRow for larger, high density devices", (tester) async {
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(1800, 1000);
    expect(Difficulty.easy.targetsPerRow, 4);
  });

  testWidgets("displayName returns correct values", (tester) async {
    var context = await pumpContext(tester, (_) => Container());
    expect(Difficulty.kids.displayName(context), "Kids");
    expect(Difficulty.easy.displayName(context), "Easy");
    expect(Difficulty.normal.displayName(context), "Normal");
    expect(Difficulty.hard.displayName(context), "Hard");
    expect(Difficulty.expert.displayName(context), "Expert");
  });
}
