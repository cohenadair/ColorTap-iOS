import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mobile/tapd_game.dart';

import 'utils/overlay_utils.dart';

class TapdGameWidget extends StatelessWidget {
  final TapdGame game;

  const TapdGameWidget(this.game);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, orientation) {
        game.world.orientation = orientation;
        return GameWidget(
          game: game,
          overlayBuilderMap: const {
            overlayIdMainMenu: buildMainMenu,
            overlayIdGameOver: buildGameOver,
            overlayIdScoreboard: buildScoreboard,
            overlayIdInstructions: buildInstructions,
          },
        );
      },
    );
  }
}
