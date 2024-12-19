import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/utils/ad_utils.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() {
    managers = StubbedManagers();
  });

  test("Test Android ad unit IDs are used for debug builds", () {
    when(managers.platformWrapper.isDebug).thenReturn(true);
    when(managers.platformWrapper.isAndroid).thenReturn(true);

    expect(
      adUnitId(
        androidTestId: "androidTestId",
        iosTestId: "iosTestId",
        androidRealId: "androidRealId",
        iosRealId: "iosRealId",
      ),
      "androidTestId",
    );
  });

  test("Test iOS ad unit IDs are used for debug builds", () {
    when(managers.platformWrapper.isDebug).thenReturn(true);
    when(managers.platformWrapper.isAndroid).thenReturn(false);

    expect(
      adUnitId(
        androidTestId: "androidTestId",
        iosTestId: "iosTestId",
        androidRealId: "androidRealId",
        iosRealId: "iosRealId",
      ),
      "iosTestId",
    );
  });

  test("Valid Android ad unit IDs are used for non-debug builds", () {
    when(managers.platformWrapper.isDebug).thenReturn(false);
    when(managers.platformWrapper.isAndroid).thenReturn(true);

    expect(
      adUnitId(
        androidTestId: "androidTestId",
        iosTestId: "iosTestId",
        androidRealId: "androidRealId",
        iosRealId: "iosRealId",
      ),
      "androidRealId",
    );
  });

  test("Valid iOS ad unit IDs are used for non-debug builds", () {
    when(managers.platformWrapper.isDebug).thenReturn(false);
    when(managers.platformWrapper.isAndroid).thenReturn(false);

    expect(
      adUnitId(
        androidTestId: "androidTestId",
        iosTestId: "iosTestId",
        androidRealId: "androidRealId",
        iosRealId: "iosRealId",
      ),
      "iosRealId",
    );
  });
}
