import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/wrappers/widgets_binding_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockWidgetsBindingWrapper widgetsBinding;

  setUp(() {
    widgetsBinding = MockWidgetsBindingWrapper();
    WidgetsBindingWrapper.set(widgetsBinding);
  });

  group("safeAreaTopPadding", () {
    test("Assertion when view is null", () {
      when(widgetsBinding.implicitView).thenReturn(null);
      expect(() => safeAreaTopPadding(), throwsAssertionError);
    });

    test("Valid value is returned", () {
      var view = MockFlutterView();
      when(view.padding).thenReturn(ViewPadding.zero);
      when(view.devicePixelRatio).thenReturn(1.0);
      when(widgetsBinding.implicitView).thenReturn(view);
      expect(safeAreaTopPadding(), 0);
    });
  });
}
