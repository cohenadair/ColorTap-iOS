import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_game_widget.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/components/scoreboard.dart';
import 'package:mobile/components/target.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/effects/target_board_rewind_effect.dart';
import 'package:mobile/utils/overlay_utils.dart';

void main() {
  late ColorTapGame game;
  late ColorTapWorld world;

  setUp(() {
    world = ColorTapWorld();
    game = ColorTapGame(world: world);
  });

  testWidgets("onLoad", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    expect(game.overlays.activeOverlays.contains(overlayMainMenuId), true);
    expect(world.children.whereType<FpsTextComponent>().length, 1);
    expect(world.children.whereType<Scoreboard>().length, 1);
    expect(world.children.whereType<TargetBoard>().length, 2);
  });

  testWidgets("Correct hit without color change", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    var startSpeed = world.speed;
    var startScore = world.score;
    var startColor = world.color;
    var notified = false;
    game.componentsNotifier<ColorTapWorld>().addListener(() => notified = true);
    world.handleTargetHit(isCorrect: true);

    expect(world.speed > startSpeed, true);
    expect(world.score > startScore, true);
    expect(world.color == startColor, true);
    expect(notified, true);
  });

  testWidgets("Correct hit with color change", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    var startColor = world.color;
    for (var i = 1; i <= 10; i++) {
      world.handleTargetHit(isCorrect: true);
    }
    expect(world.color != startColor, true);
    expect(world.gracePeriod, isNotNull);

    // Time out grace period.
    await tester.pump(const Duration(milliseconds: 2000));
    expect(world.gracePeriod, isNull);
  });

  testWidgets("Incorrect hit ends game", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    var startSpeed = world.speed;
    var startScore = world.score;
    var startColor = world.color;
    var notified = false;
    game.componentsNotifier<ColorTapWorld>().addListener(() => notified = true);
    world.handleTargetHit(isCorrect: false);

    expect(world.speed == startSpeed, true);
    expect(world.score == startScore, true);
    expect(world.color == startColor, true);
    expect(game.overlays.activeOverlays.contains(overlayGameOverId), true);
    expect(notified, true);

    await tester.pump();
    expect(find.text("Game Over"), findsOneWidget);
  });

  testWidgets("Target missed ends game", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    var board = world.children.whereType<TargetBoard>().first;
    var target = board.children.whereType<Target>().first;
    world.handleTargetMissed(target, board);
    await tester.pump();

    expect(world.scrollingPaused, true);
    expect(board.children.whereType<TargetBoardRewindEffect>().length, 1);
    expect(
      (game.findByKey(board.otherBoardKey) as TargetBoard)
          .children
          .whereType<TargetBoardRewindEffect>()
          .length,
      1,
    );

    // Verify target's "pulse" is invoked.
    await tester.pump(const Duration(milliseconds: 300));
    expect(board.priority, 1);
  });

  testWidgets("Play starts the game", (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(600, 1000);

    var startColor = world.color;
    var notified = false;
    game.componentsNotifier<ColorTapWorld>().addListener(() => notified = true);

    await tester.pumpWidget(ColorTapGameWidget(game));
    world.play();

    expect(world.children.whereType<TargetBoard>().first.position.y, -3500);
    expect(world.children.whereType<TargetBoard>().last.position.y, -1750);
    expect(world.speed, 3.5);
    expect(world.color != startColor, true);
    expect(world.score, 0);
    expect(world.gracePeriod, isNull);
    expect(world.scrollingPaused, false);
    expect(notified, true);
    expect(game.overlays.activeOverlays.isEmpty, true);
  });
}
