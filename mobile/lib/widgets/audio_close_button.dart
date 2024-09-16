import 'package:flutter/material.dart';

import '../managers/audio_manager.dart';

class AudioCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CloseButton(
      onPressed:
          AudioManager.get.onButtonPressed(() => Navigator.of(context).pop()),
    );
  }
}
