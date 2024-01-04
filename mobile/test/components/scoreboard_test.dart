import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/components/scoreboard.dart';
import 'package:mobile/components/target.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/target_color.dart';
import 'package:mobile/wrappers/widgets_binding_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

main() {
  late MockColorTapWorld world;
  late MockColorTapGame game;
  late MockWidgetsBindingWrapper widgetsBinding;

  setUp(() {
    world = MockColorTapWorld();

    game = MockColorTapGame();
    when(game.world).thenReturn(world);
    when(game.size).thenReturn(Vector2(400, 1000));
    when(game.hasLayout).thenReturn(true);

    var flutterView = MockFlutterView();
    when(flutterView.padding).thenReturn(ViewPadding.zero);
    when(flutterView.devicePixelRatio).thenReturn(1.0);

    widgetsBinding = MockWidgetsBindingWrapper();
    when(widgetsBinding.implicitView).thenReturn(flutterView);
    WidgetsBindingWrapper.set(widgetsBinding);
  });

  Scoreboard buildScoreboard() {
    var scoreboard = Scoreboard();
    scoreboard.world = world;
    scoreboard.game = game;
    return scoreboard;
  }

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
    var notifier = MockComponentsNotifier<ColorTapWorld>();
    when(game.componentsNotifier<ColorTapWorld>()).thenReturn(notifier);

    var color = TargetColor.random();
    when(world.color).thenReturn(color);

    var scoreboard = buildScoreboard();
    scoreboard.onLoad();

    var scoreTarget = scoreboard.children.whereType<CircleComponent>().first;
    verify(notifier.addListener(any)).called(1);

    // The scoreboard should always be the same size as the generated targets.
    var board = buildBoard();
    board.onLoad();
    expect(
      scoreTarget.radius,
      board.children.whereType<Target>().first.radius,
    );

    expect(scoreTarget.paintLayers.first.color, color.paint.color);
    expect(scoreTarget.position.x, 200 - scoreTarget.radius);
    expect(scoreTarget.position.y, 16);
    expect(
      (scoreTarget.children.whereType<AlignComponent>().first.child
              as TextComponent)
          .text,
      "0",
    );
  });

  test("onRemove removes world listener", () {
    var notifier = MockComponentsNotifier<ColorTapWorld>();
    when(game.componentsNotifier<ColorTapWorld>()).thenReturn(notifier);
    when(world.color).thenReturn(TargetColor.random());

    var scoreboard = buildScoreboard();
    scoreboard.onLoad();
    scoreboard.onRemove();

    verify(notifier.removeListener(any)).called(1);
  });

  test("State updates on world changes", () {
    var notifier = ComponentsNotifier<ColorTapWorld>([]);
    when(game.componentsNotifier<ColorTapWorld>()).thenReturn(notifier);
    when(world.color).thenReturn(TargetColor.random());

    var scoreboard = buildScoreboard();
    scoreboard.onLoad();

    var color = TargetColor.random();
    when(world.color).thenReturn(color);
    when(world.score).thenReturn(1);
    notifier.notifyListeners();

    var scoreTarget = scoreboard.children.whereType<CircleComponent>().first;
    expect(
      (scoreTarget.children.whereType<AlignComponent>().first.child
              as TextComponent)
          .text,
      "1",
    );
    expect(scoreTarget.paintLayers.first.color, color.paint.color);
  });
}
