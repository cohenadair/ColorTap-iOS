import 'dart:async';

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
    when(managers.preferenceManager.currentHighScore).thenReturn(null);

    when(managers.purchasesWrapper.getOfferings())
        .thenAnswer((_) => Future.value(MockOfferings()));

    world = MockColorTapWorld();
    when(world.play()).thenAnswer((_) {});

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
    expect(find.text("Difficulty: Hard"), findsOneWidget);
  });

  testWidgets("High score text shows none", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    when(managers.preferenceManager.currentHighScore).thenReturn(null);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("High Score: None"), findsOneWidget);
  });

  testWidgets("High score text shows value", (tester) async {
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    when(managers.preferenceManager.currentHighScore).thenReturn(50);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("High Score: 50"), findsOneWidget);
  });

  testWidgets("Text updates when difficulty changes", (tester) async {
    var controller = StreamController.broadcast();
    when(managers.preferenceManager.stream)
        .thenAnswer((_) => controller.stream);

    // Test initial value.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.hard);
    await pumpContext(tester, (context) => Menu.main(game));
    expect(find.text("Difficulty: Hard"), findsOneWidget);
    expect(find.text("Difficulty: Normal"), findsNothing);

    // Update value.
    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    controller.add(null);
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text("Difficulty: Hard"), findsNothing);
    expect(find.text("Difficulty: Normal"), findsOneWidget);
  });
}
