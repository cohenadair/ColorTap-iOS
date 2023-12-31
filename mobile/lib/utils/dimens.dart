import 'package:flutter/material.dart';

const double paddingDefault = 16.0;

/// Returns the number of logical pixels of top padding for the main view. Use
/// to account for safe area padding at the top of the screen.
double safeAreaTopPadding() {
  var view = WidgetsBinding.instance.platformDispatcher.implicitView;
  assert(view != null, "View is null; something went very wrong.");
  return view!.padding.top / view.devicePixelRatio;
}