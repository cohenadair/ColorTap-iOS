import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;
  late MockColorTapGame game;
  late MockColorTapWorld world;

  setUp(() {
    world = MockColorTapWorld();

    game = MockColorTapGame();
    when(game.world).thenReturn(world);

    managers = StubbedManagers();
    when(managers.livesManager.canPlay).thenReturn(true);
    when(managers.livesManager.lives).thenReturn(3);

    when(managers.preferenceManager.difficulty).thenReturn(Difficulty.normal);
    when(managers.preferenceManager.currentHighScore).thenReturn(null);
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
}
