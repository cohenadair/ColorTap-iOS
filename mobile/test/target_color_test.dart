import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/target_color.dart';

void main() {
  test("random excludes input", () {
    // Not a perfect test, but changes of 1000 random colors not producing the
    // same as the previous is very low in a collection of 8 colors.
    var exclude = TargetColor.random();
    for (var i = 0; i < 1000; i++) {
      var color = TargetColor.random(exclude: exclude);
      expect(color, isNot(exclude));
    }
  });
}
