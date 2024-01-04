import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils.dart';

void main() {
  late MockColorTapGame game;
  late MockColorTapWorld world;

  setUp(() {
    world = MockColorTapWorld();
    when(world.play()).thenAnswer((_) {});

    game = MockColorTapGame();
    when(game.world).thenReturn(world);
  });

  testWidgets("Score is hidden", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    expect(find.byType(Text), findsNWidgets(2));
  });

  testWidgets("Score is shown", (tester) async {
    when(world.score).thenReturn(10);
    await pumpContext(tester, (context) => Menu.gameOver(game: game));
    expect(find.byType(Text), findsNWidgets(3));
  });

  testWidgets("Play button starts the game", (tester) async {
    await pumpContext(tester, (context) => Menu.main(game: game));
    await tapAndSettle(tester, find.text("Play"));
    verify(world.play()).called(1);
  });
}
