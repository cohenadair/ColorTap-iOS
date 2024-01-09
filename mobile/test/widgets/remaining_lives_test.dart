import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/widgets/remaining_lives.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';
import '../test_utils/test_utils.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();
  });

  testWidgets("Text updates when lives change", (tester) async {
    var controller = StreamController.broadcast();
    when(managers.livesManager.stream).thenAnswer((_) => controller.stream);
    when(managers.livesManager.lives).thenReturn(10);

    await pumpContext(tester, (_) => const RemainingLives());
    expect(find.text("10"), findsOneWidget);

    when(managers.livesManager.lives).thenReturn(15);
    controller.add(null);
    await tester.pump();

    expect(find.text("15"), findsOneWidget);
  });
}
