import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/components/target.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mobile/target_color.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

main() {
  late MockTargetBoard board;
  late MockColorTapGame game;
  late MockColorTapWorld world;
  late MockTimeManager timeManager;

  setUp(() {
    board = MockTargetBoard();
    world = MockColorTapWorld();

    game = MockColorTapGame();
    when(game.world).thenReturn(world);
    when(game.size).thenReturn(Vector2(400, 1000));
    when(game.hasLayout).thenReturn(true);

    timeManager = MockTimeManager();
    when(timeManager.millisSinceEpoch).thenReturn(0);
    TimeManager.set(timeManager);
  });

  Target buildTarget() {
    var target = Target(Vector2(0, 0), 50, board);
    target.world = world;
    target.game = game;
    return target;
  }

  void stubDifferentWorldColor(Target target) {
    when(world.color).thenAnswer((_) {
      var color = TargetColor.random();
      while (color == target.color) {
        color = TargetColor.random();
      }
      return color;
    });
  }

  test("onLoad", () {
    var target = buildTarget();
    target.onLoad();
    expect(target.paint.color == BasicPalette.white.color, isFalse);
  });

  test("onTapDown is a no-op when paused", () {
    when(world.scrollingPaused).thenReturn(true);

    var target = buildTarget();
    target.onTapDown(MockTapDownEvent());
    verifyNever(world.color);
  });

  test("onTapDown is a no-op if already hit", () {
    var target = buildTarget();
    when(world.scrollingPaused).thenReturn(false);
    when(world.color).thenReturn(target.color);
    when(world.handleTargetHit(isCorrect: anyNamed("isCorrect")))
        .thenAnswer((_) {});

    // Initial hit.
    target.onTapDown(MockTapDownEvent());
    verify(world.color).called(1);

    // Next hit.
    target.onTapDown(MockTapDownEvent());
    verifyNever(world.color);
  });

  test("Correct hit", () {
    var target = buildTarget();
    when(world.scrollingPaused).thenReturn(false);
    when(world.color).thenReturn(target.color);
    when(world.handleTargetHit(isCorrect: anyNamed("isCorrect")))
        .thenAnswer((_) {});

    target.onTapDown(MockTapDownEvent());
    var result =
        verify(world.handleTargetHit(isCorrect: captureAnyNamed("isCorrect")));
    result.called(1);
    expect(result.captured.first, true);
  });

  test("Incorrect hit", () {
    var target = buildTarget();
    stubDifferentWorldColor(target);
    when(world.scrollingPaused).thenReturn(false);
    when(world.handleTargetHit(isCorrect: anyNamed("isCorrect")))
        .thenAnswer((_) {});
    when(board.priority = any).thenAnswer((_) {});
    when(world.scrollingPaused = any).thenAnswer((_) {});

    // Verify updated state.
    target.onTapDown(MockTapDownEvent());
    expect(target.priority, 1);

    var result = verify(board.priority = captureAny);
    result.called(1);
    expect(result.captured.first, 1);

    result = verify(world.scrollingPaused = captureAny);
    result.called(1);
    expect(result.captured.first, true);

    // Trigger pulse animation completion and verify state is reset.
    expect(target.children.last is ScaleEffect, isTrue);
    (target.children.last as ScaleEffect).onComplete?.call();

    expect(target.priority, 0);

    result = verify(board.priority = captureAny);
    result.called(1);
    expect(result.captured.first, 0);

    result =
        verify(world.handleTargetHit(isCorrect: captureAnyNamed("isCorrect")));
    result.called(1);
    expect(result.captured.first, false);
  });

  test("update is a no-op if passed the bottom of the screen", () {
    when(world.gracePeriod).thenReturn(0);

    var target = buildTarget();
    target.position.y = game.size.y + target.radius + 1;

    // Initial update to set _isPassedBottom to true.
    target.update(0);
    verify(timeManager.millisSinceEpoch).called(1);

    // Next update that exits early.
    target.update(0);
    verifyNever(timeManager.millisSinceEpoch);
  });

  test("update is a no-op when still on the screen", () {
    buildTarget().update(0);
    verifyNever(timeManager.millisSinceEpoch);
  });

  test("update is a no-op during the grace period", () {
    when(world.gracePeriod).thenReturn(0);

    var target = buildTarget();
    target.position.y = game.size.y + target.radius + 1;
    target.update(0);
    verify(timeManager.millisSinceEpoch).called(1);
    verifyNever(world.color);
  });

  test("update is a no-op if color doesn't match", () {
    var target = buildTarget();
    target.position.y = game.size.y + target.radius + 1;

    stubDifferentWorldColor(target);
    when(world.gracePeriod).thenReturn(null);

    target.update(0);
    verify(world.color).called(1);
    verifyNever(world.scrollingPaused);
    verifyNever(world.handleTargetMissed(any, any));
  });

  test("update is a no-op if already hit", () {
    var target = buildTarget();
    target.position.y = game.size.y + target.radius + 1;

    when(world.color).thenReturn(target.color);
    when(world.gracePeriod).thenReturn(null);
    when(world.scrollingPaused).thenReturn(false);

    // Mark target as hit.
    target.onTapDown(MockTapDownEvent());
    var result =
        verify(world.handleTargetHit(isCorrect: captureAnyNamed("isCorrect")));
    result.called(1);
    expect(result.captured.first, true);
    verify(world.scrollingPaused).called(1);
    verify(world.color).called(1);

    // Verify early exit.
    target.update(0);
    verify(world.color).called(1);
    verifyNever(world.scrollingPaused);
    verifyNever(world.handleTargetMissed(any, any));
  });

  test("update is a no-op if scrolling is paused", () {
    var target = buildTarget();
    target.position.y = game.size.y + target.radius + 1;

    when(world.color).thenReturn(target.color);
    when(world.gracePeriod).thenReturn(null);
    when(world.scrollingPaused).thenReturn(true);

    // Verify early exit.
    target.update(0);
    verify(world.scrollingPaused).called(1);
    verifyNever(world.handleTargetMissed(any, any));
  });

  test("update handles target missed", () {
    var target = buildTarget();
    target.position.y = game.size.y + target.radius + 1;

    when(world.color).thenReturn(target.color);
    when(world.gracePeriod).thenReturn(null);
    when(world.scrollingPaused).thenReturn(false);

    // Verify early exit.
    target.update(0);
    verify(world.handleTargetMissed(any, any)).called(1);
  });

  test("reset", () {
    var target = buildTarget();

    when(world.color).thenReturn(target.color);
    when(world.scrollingPaused).thenReturn(false);

    // Mark target as hit.
    target.onTapDown(MockTapDownEvent());
    var result =
        verify(world.handleTargetHit(isCorrect: captureAnyNamed("isCorrect")));
    result.called(1);
    expect(result.captured.first, true);

    target.reset();
    expect(target.children.last is ScaleEffect, isTrue);
    expect((target.children.last as ScaleEffect).controller.duration, 0.0);
    // Can't verify scale here because it is private.
  });

  test("pulse", () {
    when(world.scrollingPaused = any).thenAnswer((_) {});
    var target = buildTarget();
    target.pulse();
    verify(world.scrollingPaused = any).called(1);
  });
}
