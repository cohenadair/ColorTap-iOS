import 'package:flutter/material.dart';

import 'color_tap_game.dart';
import 'color_tap_game_widget.dart';
import 'color_tap_world.dart';

void main() {
  final myGame = ColorTapGame(world: ColorTapWorld());
  runApp(ColorTapGameWidget(myGame));
}
