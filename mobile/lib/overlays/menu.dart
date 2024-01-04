import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';

import '../utils/colors.dart';

class Menu extends StatelessWidget {
  static const _titleSize = 50.0;
  static const _scoreSize = 100.0;

  final ColorTapGame game;
  final String title;
  final String playText;
  final Color color;
  final bool hideScore;

  const Menu.main({
    required this.game,
    super.key,
  })  : title = "Main Menu",
        playText = "Play",
        color = colorGame,
        hideScore = true;

  const Menu.gameOver({
    required this.game,
    super.key,
  })  : title = "Game Over",
        playText = "Play Again",
        color = Colors.red,
        hideScore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(),
            _buildScore(),
            _buildPlayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: _titleSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildScore() {
    if (hideScore) {
      return Container();
    }

    return Text(
      game.world.score.toString(),
      style: const TextStyle(
        fontSize: _scoreSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildPlayButton() {
    return FilledButton(
      child: Text(playText),
      onPressed: () => game.world.play(),
    );
  }
}
