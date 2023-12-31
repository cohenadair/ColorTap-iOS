import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/utils/target_utils.dart';

class Scoreboard extends PositionComponent
    with HasGameRef, HasWorldReference<ColorTapWorld> {
  static const _borderWidth = 2.0;
  static const _fontSize = 40.0;

  final _score = TextComponent(
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
  );

  final _target = CircleComponent(
    paintLayers: [
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth
        ..color = Colors.white,
    ],
  );

  ComponentsNotifier<ColorTapWorld>? _worldNotifier;

  Scoreboard() : super(priority: 1);

  @override
  FutureOr<void> onLoad() {
    size = game.size;

    _score.text = "0";
    _worldNotifier = game.componentsNotifier<ColorTapWorld>()
      ..addListener(_onWorldUpdated);

    final radius = targetRadiusForSize(game.size);
    _target.radius = radius;
    _target.paintLayers.insert(0, world.color.paint);
    _target.position =
        Vector2(size.x / 2 - radius, safeAreaTopPadding() + paddingDefault);
    _target.add(AlignComponent(
      child: _score,
      alignment: Anchor.center,
    ));
    add(_target);

    return super.onLoad();
  }

  @override
  void onRemove() {
    super.onRemove();
    _worldNotifier?.removeListener(_onWorldUpdated);
  }

  void _onWorldUpdated() {
    _score.text = world.score.toString();
    _target.paintLayers.first = world.color.paint;
  }
}
