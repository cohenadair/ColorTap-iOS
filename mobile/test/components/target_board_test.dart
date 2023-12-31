import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/components/target.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

main() {
  late MockColorTapGame game;
  late MockColorTapWorld world;

  setUp(() {
    world = MockColorTapWorld();

    game = MockColorTapGame();
    when(game.world).thenReturn(world);
    when(game.size).thenReturn(Vector2(400, 1000));
    when(game.hasLayout).thenReturn(true);
  });

  test("Initial state", () {
    var board = TargetBoard(
      otherBoardKey: ComponentKey.unique(),
      verticalStartFactor: 1,
    );
    board.game = game;
    board.onLoad();

    // Height * targetBoardHeightFactor.
    expect(board.position.y, -1250);
    expect(board.children.whereType<Target>().length, 52);
  });

  test("Update is no-op when paused", () {
    // TODO
  });

  test("Update resets to top position", () {
    // TODO
  });

  test("Update scrolls down", () {
    // TODO
  });

  test("Reset", () {
    // TODO
  });
}
