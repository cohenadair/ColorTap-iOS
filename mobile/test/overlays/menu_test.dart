import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/widgets/get_lives.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/test_utils.dart';

void main() {
  late MockColorTapGame game;
  late MockColorTapWorld world;
  late MockLivesManager livesManager;
  late MockPurchasesWrapper purchasesWrapper;

  setUp(() {
    world = MockColorTapWorld();
    when(world.play()).thenAnswer((_) {});

    game = MockColorTapGame();
    when(game.world).thenReturn(world);

    purchasesWrapper = MockPurchasesWrapper();
    when(purchasesWrapper.getOfferings())
        .thenAnswer((_) => Future.value(MockOfferings()));
    PurchasesWrapper.set(purchasesWrapper);

    livesManager = MockLivesManager();
    LivesManager.set(livesManager);
    when(livesManager.canPlay).thenReturn(true);
    when(livesManager.lives).thenReturn(3);
    when(livesManager.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets("Score is hidden", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    verifyNever(world.score);
  });

  testWidgets("Score is shown", (tester) async {
    when(world.score).thenReturn(77);
    await pumpContext(tester, (context) => Menu.gameOver(game: game));
    expect(find.text("77"), findsOneWidget);
    verify(world.score).called(1);
  });

  testWidgets("Play button starts the game", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    await tapAndSettle(tester, find.text("Play"));
    verify(world.play()).called(1);
  });

  testWidgets("Play button is hidden if out of lives", (tester) async {
    when(livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.text("Play"), findsNothing);
  });

  testWidgets("Play button is enabled", (tester) async {
    when(livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.text("Play"), findsOneWidget);
  });

  testWidgets("GetLives is hidden when lives > 0", (tester) async {
    when(livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.byType(GetLives), findsNothing);
  });

  testWidgets("GetLives is shown when lives == 0", (tester) async {
    when(livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.byType(GetLives), findsOneWidget);
  });

  testWidgets("Play button is hidden when lives == 0", (tester) async {
    when(livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.text("Play"), findsNothing);
  });

  testWidgets("Play button is shown when lives > 0", (tester) async {
    when(livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.text("Play"), findsOneWidget);
  });

  testWidgets("Store button opens store page", (tester) async {
    var offerings = MockOfferings();
    when(offerings.getOffering(any)).thenReturn(null);
    when(purchasesWrapper.getOfferings())
        .thenAnswer((_) => Future.value(offerings));

    await pumpContext(tester, (context) => Menu.main(game: game));
    await tapAndSettle(tester, find.text("Store"));
    expect(find.text("BUY LIVES"), findsOneWidget);
  });

  testWidgets("Settings button opens settings page", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    await tapAndSettle(tester, find.text("Settings"));
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
