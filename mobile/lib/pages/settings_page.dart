import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';

import '../utils/dimens.dart';

class SettingsPage extends StatelessWidget {
  static const urlPrivacyPolicy =
      "https://cohenadair.github.io/colour-tap/privacy.html";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(Strings.of(context).settingsPrivacyTitle),
              contentPadding: insetsHorizontalDefault,
              trailing: Icon(
                Icons.open_in_new,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => UrlLauncherWrapper.get.launch(urlPrivacyPolicy),
            ),
          ],
        ),
      ),
    );
  }
}
