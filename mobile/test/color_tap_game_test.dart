import 'package:flame/game.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_game_widget.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mockito/mockito.dart';

import 'test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();
    when(managers.livesManager.lives).thenReturn(3);
    when(managers.livesManager.canPlay).thenReturn(true);
  });

  testWidgets("onLoad", (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(600, 1000);

    final game = ColorTapGame(world: ColorTapWorld());

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();
    expect(game.camera.viewport.position, Vector2(-300, -500));
  });
}
