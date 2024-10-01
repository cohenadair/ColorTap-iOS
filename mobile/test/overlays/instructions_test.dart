import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_game_widget.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/overlays/instructions.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  late ColorTapGame game;
  late ColorTapWorld world;

  setUp(() {
    managers = StubbedManagers();
    when(managers.audioManager.onButtonPressed(any))
        .thenAnswer((invocation) => invocation.positionalArguments.first);

    when(managers.livesManager.lives).thenReturn(3);
    when(managers.livesManager.canPlay).thenReturn(true);

    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    when(managers.preferenceManager.colorIndex).thenReturn(null);
    when(managers.preferenceManager.isFpsOn).thenReturn(false);
    when(managers.preferenceManager.didOnboard).thenReturn(true);

    when(managers.statsManager.currentHighScore).thenReturn(50);
    when(managers.statsManager.currentGamesPlayed).thenReturn(100);

    world = ColorTapWorld();
    game = ColorTapGame(world: world);
  });

  testWidgets("Entire flow", (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 1000);

    when(managers.preferenceManager.didOnboard).thenReturn(false);

    await tester.pumpWidget(ColorTapGameWidget(game));
    await tester.pump();

    world.play();

    // Delay that shows the instructions.
    await tester.pump(const Duration(milliseconds: 2000));

    // Fade in duration.
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(Instructions), findsOneWidget);

    // Go through instructions flow.
    expect(
      find.text(
          "Your score will increase by 1 each time you tap a correct target."),
      findsOneWidget,
    );
    await tester.tap(find.text("Next"));
    await tester.pump();

    expect(
      find.text(
          "Watch out! The current target will change throughout the game."),
      findsOneWidget,
    );
    await tester.tap(find.text("Next"));
    await tester.pump();

    expect(
      find.text("The number of lives you have remaining."),
      findsOneWidget,
    );
    await tester.tap(find.text("Next"));
    await tester.pump();

    expect(
      find.text("You can pause and resume the game at any time."),
      findsOneWidget,
    );
    await tester.tap(find.text("Next"));
    await tester.pump();

    expect(
      find.text(
          "Tap the targets that match the current target as they fall down the screen. Tapping the incorrect target, or missing a target will end the game."),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text("Resume Game"));
    await tester.tap(find.text("Resume Game"));
    await tester.pump(animDurationDefault); // Fade out.

    expect(find.byType(Instructions), findsNothing);
  });
}
