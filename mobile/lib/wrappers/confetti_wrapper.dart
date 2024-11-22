import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiWrapper {
  static var _instance = ConfettiWrapper._();

  static ConfettiWrapper get get => _instance;

  @visibleForTesting
  static void set(ConfettiWrapper manager) => _instance = manager;

  ConfettiWrapper._();

  ConfettiController newConfettiController({required Duration duration}) =>
      ConfettiController(duration: duration);
}
