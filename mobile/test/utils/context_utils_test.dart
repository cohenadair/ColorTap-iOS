import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/utils/context_utils.dart';

import '../test_utils/test_utils.dart';

void main() {
  test("saveUseContext exits early when not mounted", () async {
    var widget = const _Test();
    var wasCalled = false;
    await safeUseContext(widget.createState(), () => wasCalled = true);
    expect(wasCalled, isFalse);
  });

  testWidgets("saveUseContext doesn't exit early", (tester) async {
    final key = GlobalKey<_TestState>();
    await pumpContext(tester, (_) => _Test(key: key));

    var wasCalled = false;
    await safeUseContext(key.currentState!, () => wasCalled = true);
    expect(wasCalled, isTrue);
  });
}

class _Test extends StatefulWidget {
  const _Test({super.key});

  @override
  State<_Test> createState() => _TestState();
}

class _TestState extends State<_Test> {
  @override
  Widget build(BuildContext context) {
    return const Text("Test");
  }
}
