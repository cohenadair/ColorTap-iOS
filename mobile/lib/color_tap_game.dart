import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mobile/color_tap_world.dart';

import 'utils/colors.dart';

class ColorTapGame extends FlameGame<ColorTapWorld> {
  ColorTapGame({
    super.world,
  });

  @override
  Color backgroundColor() => colorGame;

  @override
  void onLoad() {
    // Set origin (0, 0) to top left of screen.
    camera.viewport.position = Vector2(
      -camera.viewport.size.x / 2,
      -camera.viewport.size.y / 2,
    );
  }
}
