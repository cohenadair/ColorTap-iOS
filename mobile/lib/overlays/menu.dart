import 'package:flutter/material.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/widgets/remaining_lives.dart';

import '../utils/colors.dart';

class Menu extends StatefulWidget {
  final ColorTapGame game;
  final String title;
  final String playText;
  final bool hideScore;

  const Menu.main({
    required this.game,
  })  : title = "Color Tap Coordination",
        playText = "Play",
        hideScore = true;

  const Menu.gameOver({
    required this.game,
  })  : title = "Game Over",
        playText = "Play Again",
        hideScore = false;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  static const _titleSize = 50.0;
  static const _scoreSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorGame,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildTitle(),
            _buildLives(),
            _buildScore(),
            const Spacer(),
            _buildPlayButton(),
            _buildAddLivesButton(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: _titleSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildLives() {
    return const RemainingLives();
  }

  Widget _buildScore() {
    if (widget.hideScore) {
      return Container();
    }

    return Text(
      widget.game.world.score.toString(),
      style: const TextStyle(
        fontSize: _scoreSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildPlayButton() {
    return FilledButton(
      onPressed:
          LivesManager.get.canPlay ? () => widget.game.world.play() : null,
      child: Text(widget.playText),
    );
  }

  Widget _buildAddLivesButton() {
    return FilledButton(
      onPressed: () {
        LivesManager.get.reset();
        setState(() {});
      },
      child: const Text("Replenish Lives"),
    );
  }
}
