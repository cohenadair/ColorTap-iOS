import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';

import 'utils/overlay_utils.dart';

class ColorTapGameWidget extends StatelessWidget {
  final ColorTapGame game;

  const ColorTapGameWidget(this.game);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: const {
        overlayIdMainMenu: buildMainMenu,
        overlayIdGameOver: buildGameOver,
        overlayIdScoreboard: buildScoreboard,
      },
    );
  }
}
