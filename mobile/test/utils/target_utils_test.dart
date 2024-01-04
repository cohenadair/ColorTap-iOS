import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/utils/target_utils.dart';

void main() {
  test("targetScrollBackDistance returns the correct distance", () {
    expect(targetScrollBackDistance(1000), 500);
  });

  test("targetDiameterForRect returns the correct diameter", () {
    expect(targetDiameterForRect(const Rect.fromLTRB(0, 0, 100, 100)), 21);
  });

  test("targetRadiusForSize returns the correct radius", () {
    expect(targetRadiusForSize(Vector2(100, 100)), 10.5);
  });

  test("targetBoardSize returns the correct size", () {
    expect(targetBoardSize(Vector2(100, 1000)), Vector2(100, 1750));
  });
}
