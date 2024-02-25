import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
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
      localizationsDelegates: Strings.localizationsDelegates,
      supportedLocales: Strings.supportedLocales,
      locale: const Locale("en", "CA"),
      home: Builder(builder: builder),
    );
  }
}

/// A test widget that allows testing of [child.dispose] by invoking
/// [DisposableTesterState.removeChild].
class DisposableTester extends StatefulWidget {
  final Widget child;

  const DisposableTester({required this.child});

  @override
  DisposableTesterState createState() => DisposableTesterState();
}

class DisposableTesterState extends State<DisposableTester> {
  bool _showChild = true;

  void removeChild() => setState(() => _showChild = false);

  @override
  Widget build(BuildContext context) => _showChild ? widget.child : Container();
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
