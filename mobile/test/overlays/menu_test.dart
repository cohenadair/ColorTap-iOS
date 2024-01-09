import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/test_utils.dart';

void main() {
  late MockColorTapGame game;
  late MockColorTapWorld world;
  late MockLivesManager livesManager;

  setUp(() {
    world = MockColorTapWorld();
    when(world.play()).thenAnswer((_) {});

    game = MockColorTapGame();
    when(game.world).thenReturn(world);

    livesManager = MockLivesManager();
    LivesManager.set(livesManager);
    when(livesManager.canPlay).thenReturn(true);
    when(livesManager.lives).thenReturn(3);
    when(livesManager.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets("Score is hidden", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.byType(Text), findsNWidgets(4));
  });

  testWidgets("Score is shown", (tester) async {
    when(world.score).thenReturn(10);
    await pumpContext(tester, (context) => Menu.gameOver(game: game));
    expect(find.byType(Text), findsNWidgets(5));
  });

  testWidgets("Play button starts the game", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    await tapAndSettle(tester, find.text("Play"));
    verify(world.play()).called(1);
  });

  testWidgets("Play button is disabled if out of lives", (tester) async {
    when(livesManager.canPlay).thenReturn(false);
    await pumpContext(tester, (context) => Menu.main(game: game));

    var play = tester
        .firstWidget<FilledButton>(find.widgetWithText(FilledButton, "Play"));
    expect(play.onPressed, null);
  });

  testWidgets("Play button is enabled", (tester) async {
    when(livesManager.canPlay).thenReturn(true);
    await pumpContext(tester, (context) => Menu.main(game: game));

    var play = tester
        .firstWidget<FilledButton>(find.widgetWithText(FilledButton, "Play"));
    expect(play.onPressed, isNotNull);
  });

  testWidgets("Add lives button resets lives", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));

    when(livesManager.lives).thenReturn(10);
    await tapAndSettle(tester, find.text("Replenish Lives"));

    verify(livesManager.reset()).called(1);
    expect(find.text("10"), findsOneWidget);
  });
}
