import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/overlays/menu.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/test_utils.dart';

void main() {
  late MockColorTapGame game;
  late MockColorTapWorld world;
  late MockLivesManager livesManager;

  setUp(() {
    world = MockColorTapWorld();

    game = MockColorTapGame();
    when(game.world).thenReturn(world);

    livesManager = MockLivesManager();
    LivesManager.set(livesManager);
    when(livesManager.canPlay).thenReturn(true);
    when(livesManager.lives).thenReturn(3);
    when(livesManager.stream).thenAnswer((_) => const Stream.empty());
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
