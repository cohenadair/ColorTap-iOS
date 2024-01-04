import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/components/target.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/utils/target_utils.dart';
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

  TargetBoard buildBoard() {
    var board = TargetBoard(
      otherBoardKey: ComponentKey.unique(),
      verticalStartFactor: 1,
    );
    board.game = game;
    board.world = world;
    return board;
  }

  test("onLoad", () {
    var board = buildBoard();
    board.onLoad();

    // Height * targetBoardHeightFactor.
    expect(board.position.y, -1750);
    expect(board.children.whereType<Target>().length, 72);
  });

  test("Update is no-op when paused", () {
    when(world.scrollingPaused).thenReturn(true);

    var board = buildBoard();
    var expectedPos = board.position;

    board.update(0);
    expect(board.position, expectedPos);
  });

  test("Update resets to top position", () {
    when(world.scrollingPaused).thenReturn(false);

    var otherBoard = TargetBoard(
      otherBoardKey: ComponentKey.unique(),
      verticalStartFactor: 0,
    );
    otherBoard.position = Vector2(0, -1000);
    when(game.findByKey(any)).thenReturn(otherBoard);

    var board = buildBoard();
    board.onLoad();

    board.position = Vector2(board.x, targetBoardSize(game.size).y);
    board.update(0);
    expect(board.position.y, -2746);
  });

  test("Update scrolls down", () {
    when(world.scrollingPaused).thenReturn(false);
    when(world.speed).thenReturn(2.0);

    var board = buildBoard();
    board.onLoad();
    var startY = board.position.y;

    board.update(0);
    expect(board.position.y, startY + 2);

    board.update(0);
    expect(board.position.y, startY + 4);

    board.update(0);
    expect(board.position.y, startY + 6);
  });

  test("Reset", () {
    when(world.scrollingPaused).thenReturn(false);
    when(world.speed).thenReturn(2.0);

    var board = buildBoard();
    board.onLoad();
    var startY = board.position.y;

    board.update(0);
    expect(board.position.y, startY + 2);

    board.reset();
    expect(board.position.y, startY);
  });
}
