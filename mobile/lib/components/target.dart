import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_world.dart';

import '../target_color.dart';
import 'target_board.dart';

class Target extends CircleComponent
    with
        HasGameRef<ColorTapGame>,
        HasWorldReference<ColorTapWorld>,
        TapCallbacks,
        Notifier,
        CollisionCallbacks {
  static const _scaleDownBy = 0.20;
  static const _scaleDownDuration = 0.15;
  static const _scaleUpBy = 1.5;
  static const _scaleUpDuration = 0.3;
  static const _scaleResetBy = 1 / _scaleDownBy;
  static const _scaleResetDuration = 0.0;

  final TargetBoard _board;
  final CircleHitbox _hitbox = CircleHitbox();

  var _wasHit = false;
  var _color = TargetColor.random();

  TargetColor get color => _color;

  Target(Vector2 position, double radius, TargetBoard board)
      : _board = board,
        super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() {
    paint = _color.paint;
    add(_hitbox);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (world.scrollingPaused || _wasHit) {
      return;
    }

    if (_color == world.color) {
      _handleCorrectHit();
      _wasHit = true;
    } else {
      _handleIncorrectHit();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // Allow targets to be missed during the grace period.
    if (world.gracePeriod != null &&
        DateTime.now().millisecondsSinceEpoch <= world.gracePeriod!) {
      return;
    }

    if (color == world.color && !_wasHit && !world.scrollingPaused) {
      world.handleTargetMissed(this, _board);
    }
  }

  void _handleCorrectHit() {
    add(ScaleEffect.by(
      Vector2.all(_scaleDownBy),
      EffectController(duration: _scaleDownDuration),
    ));

    world.handleTargetHit(isCorrect: true);
  }

  void _handleIncorrectHit() {
    // Pulse the target 3 times so the user knows what they did wrong.
    add(ScaleEffect.by(
      Vector2.all(_scaleUpBy),
      SequenceEffectController([
        LinearEffectController(_scaleUpDuration),
        ReverseLinearEffectController(_scaleUpDuration),
        LinearEffectController(_scaleUpDuration),
        ReverseLinearEffectController(_scaleUpDuration),
        LinearEffectController(_scaleUpDuration),
        ReverseLinearEffectController(_scaleUpDuration),
      ]),
      onComplete: () {
        priority = 0;
        _board.priority = 0;
        world.handleTargetHit(isCorrect: false);
      },
    ));
    priority = 1;
    _board.priority = 1;
    world.scrollingPaused = true;
  }

  void reset() {
    if (_wasHit) {
      add(ScaleEffect.by(
        Vector2.all(_scaleResetBy),
        EffectController(duration: _scaleResetDuration),
      ));
    }

    // Must be cleared before _wasHit is reset. Depending on timing,
    // onCollisionEnd may be called between when _wasHit is set and when
    // the collisions are cleared.
    activeCollisions.clear();
    _wasHit = false;
    _color = TargetColor.random();
    paint = _color.paint;
  }

  void pulse() => _handleIncorrectHit();
}
