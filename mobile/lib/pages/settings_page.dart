import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:mobile/difficulty.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/utils/alert_utils.dart';
import 'package:mobile/widgets/color_picker.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';

import '../managers/audio_manager.dart';
import '../utils/dimens.dart';
import '../widgets/audio_close_button.dart';

class SettingsPage extends StatelessWidget {
  static const _urlFontLicense =
      "https://cohenadair.github.io/colour-tap/font-license.txt";
  static const _urlAudioLicense = "https://www.zapsplat.com";
  static const _urlPrivacyPolicy =
      "https://cohenadair.github.io/colour-tap/privacy.html";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AudioCloseButton(),
        title: Text(Strings.of(context).settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _buildDifficulty(context),
            _buildColorSelection(context),
            _buildMusic(context),
            _buildSoundEffects(context),
            _buildFps(context),
            const Divider(color: Colors.white10),
            _buildFontLicense(context),
            _buildAudioLicense(context),
            const Divider(color: Colors.white10),
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
          title: Text(Strings.of(context).settingsDifficulty),
          contentPadding: insetsHorizontalDefault,
          trailing: DropdownButton<Difficulty>(
            value: PreferenceManager.get.difficulty,
            items: Difficulty.values.map((e) {
              return DropdownMenuItem<Difficulty>(
                value: e,
                onTap: AudioManager.get.onButtonPressed(),
                child: _buildDifficultyItem(context, e),
              );
            }).toList(),
            selectedItemBuilder: (context) => Difficulty.values.map((e) {
              return Padding(
                padding: insetsHorizontalSmall,
                child: Center(
                  child: _buildDifficultyItem(context, e),
                ),
              );
            }).toList(),
            onChanged: (value) {
              PreferenceManager.get.difficulty = value ?? Difficulty.normal;
              if (!PreferenceManager.get.difficulty.canChooseColor) {
                PreferenceManager.get.colorIndex = null;
              }
            },
            onTap: AudioManager.get.onButtonPressed(),
          ),
        );
      },
    );
  }

  Widget _buildDifficultyItem(BuildContext context, Difficulty difficulty) {
    return Text(
      difficulty.displayName(context),
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
            icon: const Icon(Icons.info_outline),
            onPressed: AudioManager.get.onButtonPressed(
              () => showInfoDialog(
                context,
                Strings.of(context).settingsChooseColorTitle,
                Strings.of(context).settingsChooseColorMessage,
              ),
            ),
          ),
        ],
      ),
      contentPadding: insetsHorizontalDefault,
      trailing: ColorPicker(),
    );
  }

  Widget _buildMusic(BuildContext context) {
    return _buildPreferenceSwitch(
      context,
      label: Strings.of(context).settingsMusic,
      value: () => PreferenceManager.get.isMusicOn,
      setValue: (value) => PreferenceManager.get.isMusicOn = value,
    );
  }

  Widget _buildSoundEffects(BuildContext context) {
    return _buildPreferenceSwitch(
      context,
      label: Strings.of(context).settingsSoundEffects,
      value: () => PreferenceManager.get.isSoundOn,
      setValue: (value) => PreferenceManager.get.isSoundOn = value,
    );
  }

  Widget _buildFps(BuildContext context) {
    return _buildPreferenceSwitch(
      context,
      label: Strings.of(context).settingsFps,
      value: () => PreferenceManager.get.isFpsOn,
      setValue: (value) => PreferenceManager.get.isFpsOn = value,
    );
  }

  Widget _buildPreferenceSwitch(
    BuildContext context, {
    required String label,
    required bool Function() value,
    required void Function(bool) setValue,
  }) {
    return ListTile(
      contentPadding: insetsHorizontalDefault,
      title: Text(label),
      trailing: StreamBuilder(
        stream: PreferenceManager.get.stream,
        builder: (context, snapshot) {
          return Switch(
            value: value(),
            onChanged: (value) =>
                AudioManager.get.onButtonPressed(() => setValue(value))(),
          );
        },
      ),
    );
  }

  Widget _buildFontLicense(BuildContext context) {
    return ListTile(
      title: Text(Strings.of(context).settingsFontLicense),
      contentPadding: insetsHorizontalDefault,
      trailing: const Icon(Icons.open_in_new),
      onTap: AudioManager.get.onButtonPressed(
          () => UrlLauncherWrapper.get.launch(_urlFontLicense)),
    );
  }

  Widget _buildAudioLicense(BuildContext context) {
    return ListTile(
      title: Text(Strings.of(context).settingsAudioLicense),
      contentPadding: insetsHorizontalDefault,
      trailing: const Icon(Icons.open_in_new),
      onTap: AudioManager.get.onButtonPressed(
          () => UrlLauncherWrapper.get.launch(_urlAudioLicense)),
    );
  }

  Widget _buildPrivacy(BuildContext context) {
    return ListTile(
      title: Text(Strings.of(context).settingsPrivacy),
      contentPadding: insetsHorizontalDefault,
      trailing: const Icon(Icons.open_in_new),
      onTap: AudioManager.get.onButtonPressed(
          () => UrlLauncherWrapper.get.launch(_urlPrivacyPolicy)),
    );
  }
}
