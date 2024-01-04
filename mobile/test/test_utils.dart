import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class Testable extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const Testable(
    this.builder, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: builder),
    );
  }
}

Future<BuildContext> pumpContext(
  WidgetTester tester,
  Widget Function(BuildContext) builder,
) async {
  late BuildContext context;
  await tester.pumpWidget(
    Testable(
      (buildContext) {
        context = buildContext;
        return builder(context);
      },
    ),
  );
  return context;
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
