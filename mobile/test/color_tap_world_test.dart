import 'dart:async';
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
import 'package:mobile/overlays/instructions.dart';
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
    when(managers.preferenceManager.isFpsOn).thenReturn(false);
    when(managers.preferenceManager.didOnboard).thenReturn(true);

    when(managers.statsManager.currentHighScore).thenReturn(0);
    when(managers.statsManager.currentGamesPlayed).thenReturn(0);
    when(managers.statsManager.updateCurrentHighScore(any)).thenReturn(false);

    world = ColorTapWorld();
    game = ColorTapGame(world: world);
  });

  testWidgets("onLoad", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    expect(game.overlays.activeOverlays.contains(overlayIdMainMenu), true);
    expect(game.overlays.activeOverlays.contains(overlayIdScoreboard), true);
    expect(world.children.whereType<FpsTextComponent>().length, 0);
    expect(world.children.whereType<TargetBoard>().length, 2);

    verify(managers.audioManager.playMenuBackground()).called(1);
  });

  testWidgets("FPS component is shown", (tester) async {
    when(managers.preferenceManager.isFpsOn).thenReturn(true);

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    expect(world.children.whereType<FpsTextComponent>().length, 1);
  });

  testWidgets("FPS component is added/removed on preference change",
      (tester) async {
    var controller = StreamController<String>.broadcast();
    when(managers.preferenceManager.stream)
        .thenAnswer((_) => controller.stream);
    when(managers.preferenceManager.isFpsOn).thenReturn(true);

    // Verify FPS is already shown.
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();
    expect(world.children.whereType<FpsTextComponent>().length, 1);

    // Turn FPS off.
    when(managers.preferenceManager.isFpsOn).thenReturn(false);
    controller.add("");
    await tester.pump();
    expect(world.children.whereType<FpsTextComponent>().length, 0);

    // Turn FPS back on.
    when(managers.preferenceManager.isFpsOn).thenReturn(true);
    controller.add("");
    await tester.pump();
    expect(world.children.whereType<FpsTextComponent>().length, 1);
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
    verify(managers.audioManager.playCorrectHit()).called(1);
    verifyNever(managers.audioManager.playIncorrectHit());
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
    verify(managers.audioManager.playSwitchTarget()).called(1);
    verify(managers.audioManager.playCorrectHit()).called(9);
    verifyNever(managers.audioManager.playIncorrectHit());
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
    verify(managers.audioManager.playCorrectHit()).called(10);
    verifyNever(managers.audioManager.playIncorrectHit());
    verifyNever(managers.audioManager.playSwitchTarget());
  });

  testWidgets("Incorrect hit ends game", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    // Reset counter.
    verify(managers.audioManager.playMenuBackground()).called(1);

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
    verify(managers.audioManager.playMenuBackground()).called(1);
    verify(managers.statsManager.updateCurrentHighScore(any)).called(1);
    verify(managers.statsManager.incCurrentGamesPlayed()).called(1);
    verifyNever(managers.audioManager.playCorrectHit());

    await tester.pump();
    expect(find.text("Game Over"), findsOneWidget);
  });

  testWidgets("Incorrect hit doesn't lose life for kids mode", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.kids);

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    // Reset counter.
    verify(managers.audioManager.playMenuBackground()).called(1);

    world.handleTargetHit(isCorrect: false);
    verifyNever(managers.livesManager.loseLife());
    verify(managers.audioManager.playMenuBackground()).called(1);
    verifyNever(managers.audioManager.playCorrectHit());
    verify(managers.statsManager.updateCurrentHighScore(any)).called(1);
    verify(managers.statsManager.incCurrentGamesPlayed()).called(1);
  });

  testWidgets("Target missed ends game", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();
    await tester.pump(); // Second pump ensures children are loaded.

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

    verify(managers.audioManager.playIncorrectHit()).called(1);
    verifyNever(managers.audioManager.playCorrectHit());
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

    verify(managers.audioManager.playGameBackground()).called(1);
  });

  testWidgets("Pausing/resuming stops/plays music", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();
    verify(managers.audioManager.pauseMusic()).called(1); // From onLoad.

    world.scrollingPaused = true;
    verify(managers.audioManager.pauseMusic()).called(1);
    verifyNever(managers.audioManager.resumeMusic());

    world.scrollingPaused = false;
    verify(managers.audioManager.resumeMusic()).called(1);
    verifyNever(managers.audioManager.pauseMusic());
  });

  testWidgets("Hiding instructions updates preferences", (tester) async {
    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    world.hideInstructions();
    verify(managers.preferenceManager.didOnboard = true).called(1);
  });

  testWidgets("Show instructions exits early if already onboarded",
      (tester) async {
    when(managers.preferenceManager.didOnboard).thenReturn(true);

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    world.play();
    await tester.pump();

    expect(game.overlays.activeOverlays.length, 1); // Scoreboard.
  });

  testWidgets("Instructions are shown", (tester) async {
    when(managers.preferenceManager.didOnboard).thenReturn(false);

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    world.play();

    // Delay that shows the instructions.
    await tester.pump(const Duration(milliseconds: 2000));

    // Fade in duration.
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(Instructions), findsOneWidget);
  });
}
