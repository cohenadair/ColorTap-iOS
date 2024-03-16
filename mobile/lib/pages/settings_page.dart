import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/color_picker.dart';
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
            _buildDifficulty(context),
            _buildColorSelection(context),
            _buildPrivacy(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficulty(BuildContext context) {
    return StreamBuilder(
      stream: PreferenceManager.get.stream,
      builder: (context, _) {
        return ListTile(
          title: Text(Strings.of(context).settingsDifficultyTitle),
          contentPadding: insetsHorizontalDefault,
          trailing: DropdownButton<Difficulty>(
            value: PreferenceManager.get.difficulty,
            items: Difficulty.values.map((e) {
              return DropdownMenuItem<Difficulty>(
                value: e,
                child: _buildDifficultyItem(context, e, isSelected: false),
              );
            }).toList(),
            selectedItemBuilder: (context) => Difficulty.values.map((e) {
              return Padding(
                padding: insetsHorizontalSmall,
                child: Center(
                  child: _buildDifficultyItem(context, e, isSelected: true),
                ),
              );
            }).toList(),
            onChanged: (value) {
              PreferenceManager.get.difficulty = value ?? Difficulty.normal;
              if (!PreferenceManager.get.difficulty.canChooseColor) {
                PreferenceManager.get.colorIndex = null;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildDifficultyItem(
    BuildContext context,
    Difficulty difficulty, {
    required bool isSelected,
  }) {
    return Text(
      difficulty.displayName(context),
      style: isSelected ? themeTextDefault : themeTextLight,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildColorSelection(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.of(context).settingsChooseColorTitle),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => showInfoDialog(
              context,
              Strings.of(context).settingsChooseColorTitle,
              Strings.of(context).settingsChooseColorMessage,
            ),
          ),
        ],
      ),
      contentPadding: insetsHorizontalDefault,
      trailing: ColorPicker(),
    );
  }

  Widget _buildPrivacy(BuildContext context) {
    return ListTile(
      title: Text(Strings.of(context).settingsPrivacyTitle),
      contentPadding: insetsHorizontalDefault,
      trailing: Icon(
        Icons.open_in_new,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () => UrlLauncherWrapper.get.launch(urlPrivacyPolicy),
    );
  }
}
