import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/widgets/get_lives.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;
  late MockColorTapGame game;
  late MockColorTapWorld world;

  setUp(() {
    managers = StubbedManagers();
    when(managers.livesManager.canPlay).thenReturn(true);
    when(managers.livesManager.lives).thenReturn(3);

    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    when(managers.preferenceManager.colorIndex).thenReturn(null);
    when(managers.preferenceManager.isMusicOn).thenReturn(false);
    when(managers.preferenceManager.isSoundOn).thenReturn(false);
    when(managers.preferenceManager.isFpsOn).thenReturn(false);

    when(managers.purchasesWrapper.getOfferings())
        .thenAnswer((_) => Future.value(MockOfferings()));

    when(managers.statsManager.currentHighScore).thenReturn(0);
    when(managers.statsManager.currentGamesPlayed).thenReturn(0);

    world = MockColorTapWorld();
    when(world.play()).thenAnswer((_) {});
    when(world.shouldShowNewHighScore).thenReturn(false);

    game = MockColorTapGame();
    when(game.world).thenReturn(world);
  });

  testWidgets("Score is hidden", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game));
    verifyNever(world.score);
  });

  testWidgets("Score is shown", (tester) async {
    when(world.score).thenReturn(77);
    await pumpContext(tester, (context) => Menu.gameOver(game));
    expect(find.text("77"), findsOneWidget);
    verify(world.score).called(1);
  });

  testWidgets("Play button starts the game", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game));
    await tapAndSettle(tester, find.text("Play"));
    verify(world.play()).called(1);
  });

  testWidgets("Play button is hidden if out of lives", (tester) async {
    when(managers.livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Play"), findsNothing);
  });

  testWidgets("Play button is enabled", (tester) async {
    when(managers.livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Play"), findsOneWidget);
  });

  testWidgets("GetLives is hidden when lives > 0", (tester) async {
    when(managers.livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.byType(GetLives), findsNothing);
  });

  testWidgets("GetLives is shown when lives == 0", (tester) async {
    when(managers.livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.byType(GetLives), findsOneWidget);
  });

  testWidgets("Play button is hidden when lives == 0", (tester) async {
    when(managers.livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Play"), findsNothing);
  });

  testWidgets("Play button is shown when lives > 0", (tester) async {
    when(managers.livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Play"), findsOneWidget);
  });

  testWidgets("Settings button opens settings page", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game));
    await tapAndSettle(tester, find.text("Settings"));
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets("Difficulty text is shown", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Hard"), findsOneWidget);
  });

  testWidgets("High score text shows none", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    when(managers.statsManager.currentHighScore).thenReturn(0);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("None"), findsOneWidget);
  });

  testWidgets("High score text shows value", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    when(managers.statsManager.currentHighScore).thenReturn(50);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("50"), findsOneWidget);
  });

  testWidgets("Games played text is shown", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    when(managers.statsManager.currentGamesPlayed).thenReturn(25);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("25"), findsOneWidget);
  });

  testWidgets("Text updates when difficulty changes", (tester) async {
    var controller = StreamController.broadcast();
    when(managers.preferenceManager.stream)
        .thenAnswer((_) => controller.stream);

    // Test initial value.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    when(managers.statsManager.currentHighScore).thenReturn(50);
    when(managers.statsManager.currentGamesPlayed).thenReturn(25);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Hard"), findsOneWidget);
    expect(find.text("Normal"), findsNothing);
    expect(find.text("50"), findsOneWidget);
    expect(find.text("25"), findsOneWidget);

    // Update value.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    when(managers.statsManager.currentHighScore).thenReturn(60);
    when(managers.statsManager.currentGamesPlayed).thenReturn(30);
    controller.add(null);
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text("Hard"), findsNothing);
    expect(find.text("Normal"), findsOneWidget);
    expect(find.text("60"), findsOneWidget);
    expect(find.text("30"), findsOneWidget);
  });

  testWidgets("High score page is not shown", (tester) async {
    when(world.shouldShowNewHighScore).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game));
    await tester.pump();

    // Verify NewHighScorePage.initState() is not called instead of checking if
    // widget is visible: the confetti infinite animation doesn't allow
    // pumpAndSettle.
    verifyNever(managers.confettiWrapper
        .newConfettiController(duration: anyNamed("duration")));
    verify(world.shouldShowNewHighScore).called(1);
  });

  testWidgets("High score page is shown", (tester) async {
    when(world.shouldShowNewHighScore).thenReturn(true);
    when(world.score).thenReturn(50);

    when(managers.confettiWrapper.newConfettiController(
      duration: anyNamed("duration"),
    )).thenReturn(ConfettiController(duration: const Duration(seconds: 5)));

    await pumpContext(tester, (context) => Menu.gameOver(game));
    await tester.pump();

    // Verify NewHighScorePage.initState() is called instead of checking if
    // widget is visible: the confetti infinite animation doesn't allow
    // pumpAndSettle.
    verify(managers.confettiWrapper.newConfettiController(
      duration: anyNamed("duration"),
    )).called(1);
    verify(world.shouldShowNewHighScore = false).called(1);
  });
}
