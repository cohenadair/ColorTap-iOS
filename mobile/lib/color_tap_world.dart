import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:mobile/components/scoreboard.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/utils/overlay_utils.dart';

import 'components/target.dart';
import 'target_color.dart';

class ColorTapWorld extends World
    with HasGameRef, Notifier, HasCollisionDetection {
  static const _startSpeed = 3.0;
  static const _incSpeedFactor = 0.00005;
  static const _colorResetMod = 10;
  static const _targetMissedOffset = -300.0;
  static const _targetMissedDuration = 0.3;
  static const _gracePeriodMs = 2000;

  final _board1Key = ComponentKey.unique();
  final _board2Key = ComponentKey.unique();

  var speed = _startSpeed;
  var color = TargetColor.random();
  var score = 0;
  var scrollingPaused = true;

  /// If set, a "grace period" is active, where users are allowed to miss
  /// targets. This is to prevent immediate loss after a color change due
  /// to the new colour already being at the bottom of the screen.
  int? gracePeriod;

  @override
  void onLoad() {
    game.overlays.add(overlayMainMenuId);

    add(FpsTextComponent(
      priority: 1,
      position: Vector2(20, 80),
    ));

    add(Scoreboard());

    add(TargetBoard(
      verticalStartFactor: 2,
      otherBoardKey: _board2Key,
      key: _board1Key,
    ));
    add(TargetBoard(
      verticalStartFactor: 1,
      otherBoardKey: _board1Key,
      key: _board2Key,
    ));

    // Hitbox used to determine when targets are missed.
    add(PositionComponent(
      size: game.size,
      children: [
        RectangleHitbox(
          size: Vector2(game.size.x, 1.0),
          position: Vector2(0, game.size.y),
        ),
      ],
    ));
  }

  void handleTargetHit({required bool isCorrect}) {
    if (isCorrect) {
      // The amount of speed added after each touch is dependent on the screen
      // size to narrow the difficulty gap between different devices.
      speed += game.size.y * _incSpeedFactor;
      score++;

      if (score % _colorResetMod == 0) {
        // Ensure color always changes.
        color = TargetColor.random(exclude: color);
        gracePeriod = DateTime.now().millisecondsSinceEpoch + _gracePeriodMs;
      } else {
        gracePeriod = null;
      }
    } else {
      game.overlays.add(overlayGameOverId);
    }

    notifyListeners();
  }

  void handleTargetMissed(Target target, TargetBoard board) {
    scrollingPaused = true;

    board.add(_targetMissedEffect(target, () => target.pulse()));
    _targetBoard(board.otherBoardKey).add(_targetMissedEffect(target));
  }

  void play() {
    _targetBoard(_board1Key).reset();
    _targetBoard(_board2Key).reset();

    speed = _startSpeed;
    color = TargetColor.random();
    score = 0;
    scrollingPaused = false;
    gracePeriod = null;
    notifyListeners();

    game.overlays.removeAll([overlayMainMenuId, overlayGameOverId]);
  }

  MoveByEffect _targetMissedEffect(Target target, [VoidCallback? onComplete]) {
    return MoveByEffect(
      Vector2(0, _targetMissedOffset),
      EffectController(duration: _targetMissedDuration),
      onComplete: onComplete,
    );
  }

  TargetBoard _targetBoard(ComponentKey key) =>
      game.findByKey(key) as TargetBoard;
}
