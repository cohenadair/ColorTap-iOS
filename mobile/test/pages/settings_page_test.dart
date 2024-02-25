import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/test_utils.dart';

void main() {
  late MockUrlLauncherWrapper urlLauncherWrapper;

  setUp(() {
    urlLauncherWrapper = MockUrlLauncherWrapper();
    when(urlLauncherWrapper.launch(any)).thenAnswer((_) => Future.value(true));
    UrlLauncherWrapper.set(urlLauncherWrapper);
  });

  testWidgets("Privacy link opens privacy policy", (tester) async {
    await pumpContext(tester, (_) => SettingsPage());
    await tapAndSettle(tester, find.text("Privacy Policy"));

    var result = verify(urlLauncherWrapper.launch(captureAny));
    result.called(1);
    expect((result.captured.first as String).contains("privacy.html"), isTrue);
  });
}
