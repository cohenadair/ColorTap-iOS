import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_game_widget.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/components/target.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/effects/target_board_rewind_effect.dart';
import 'package:mobile/utils/overlay_utils.dart';
import 'package:mockito/mockito.dart';

import 'test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  late ColorTapGame game;
  late ColorTapWorld world;

  setUp(() {
    managers = StubbedManagers();
    when(managers.livesManager.loseLife()).thenAnswer((_) {});
    when(managers.livesManager.lives).thenReturn(3);
    when(managers.livesManager.canPlay).thenReturn(true);

    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    when(managers.preferenceManager.colorIndex).thenReturn(null);

    world = ColorTapWorld();
    game = ColorTapGame(world: world);
  });

  testWidgets("onLoad", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    expect(game.overlays.activeOverlays.contains(overlayIdMainMenu), true);
    expect(game.overlays.activeOverlays.contains(overlayIdScoreboard), true);
    expect(world.children.whereType<FpsTextComponent>().length, 1);
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

  testWidgets("Correct hit with Kids color set", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.kids);
    when(managers.preferenceManager.colorIndex).thenReturn(1);

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    var startColor = world.color;
    for (var i = 1; i <= 10; i++) {
      world.handleTargetHit(isCorrect: true);
    }
    expect(world.color == startColor, true);
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
    expect(game.overlays.activeOverlays.contains(overlayIdGameOver), true);
    expect(notified, true);
    verify(managers.livesManager.loseLife()).called(1);

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

    var notified = false;
    game.componentsNotifier<ColorTapWorld>().addListener(() => notified = true);

    await tester.pumpWidget(ColorTapGameWidget(game));
    var startColor = world.color;

    world.play();

    expect(world.children.whereType<TargetBoard>().first.position.y, -3600);
    expect(world.children.whereType<TargetBoard>().last.position.y, -1800);
    expect(world.speed, 4.0);
    expect(world.color != startColor, true);
    expect(world.score, 0);
    expect(world.gracePeriod, isNull);
    expect(world.scrollingPaused, false);
    expect(notified, true);
    expect(game.overlays.activeOverlays.length, 1); // Scoreboard.
  });
}
