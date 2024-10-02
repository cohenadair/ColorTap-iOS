import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;
  late MockTapdGame game;
  late MockTapdWorld world;

  setUp(() {
    world = MockTapdWorld();
    when(world.shouldShowNewHighScore).thenReturn(false);

    game = MockTapdGame();
    when(game.world).thenReturn(world);

    managers = StubbedManagers();
    when(managers.livesManager.canPlay).thenReturn(true);
    when(managers.livesManager.lives).thenReturn(3);

    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);

    when(managers.statsManager.currentHighScore).thenReturn(0);
    when(managers.statsManager.currentGamesPlayed).thenReturn(0);
  });

  testWidgets("showErrorDialog", (tester) async {
    var context = await pumpContext(tester, (_) => Menu.main(game));
    var wasCalled = false;

    showErrorDialog(
      context,
      "Test error message",
      onDismissed: () => wasCalled = true,
    );
    await tester.pumpAndSettle();

    expect(find.text("Test error message"), findsOneWidget);

    await tapAndSettle(tester, find.text("Ok"));
    expect(find.text("Test error message"), findsNothing);
    expect(wasCalled, isTrue);
  });

  testWidgets("showContinueDialog", (tester) async {
    var context = await pumpContext(tester, (_) => Menu.main(game));
    var wasCalled = false;

    showContinueDialog(
      context,
      "Title",
      "Test continue message",
      onDismissed: () => wasCalled = true,
    );
    await tester.pumpAndSettle();

    expect(find.text("Test continue message"), findsOneWidget);

    await tapAndSettle(tester, find.text("Continue"));
    expect(find.text("Test continue message"), findsNothing);
    expect(wasCalled, isTrue);
  });
}
