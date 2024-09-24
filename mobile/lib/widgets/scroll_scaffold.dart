import 'package:flutter/material.dart';

import '../utils/dimens.dart';

class ScrollScaffold extends StatelessWidget {
  final List<Widget> Function(BuildContext) childBuilder;
  final PreferredSizeWidget? appBar;
  final bool extendBodyBehindAppBar;

  const ScrollScaffold({
    required this.childBuilder,
    this.appBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: SafeArea(
                child: Padding(
                  padding: insetsDefault,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: childBuilder(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
