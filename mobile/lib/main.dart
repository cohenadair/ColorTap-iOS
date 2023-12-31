import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/overlay_utils.dart';

import 'color_tap_game.dart';
import 'color_tap_world.dart';

void main() {
  final myGame = ColorTapGame(world: ColorTapWorld());
  runApp(GameWidget(
    game: myGame,
    overlayBuilderMap: const {
      overlayMainMenuId: buildMainMenu,
      overlayGameOverId: buildGameOver,
    },
  ));
}
