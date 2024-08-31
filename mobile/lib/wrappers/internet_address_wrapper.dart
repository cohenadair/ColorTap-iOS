import 'dart:io';

import 'package:flutter/material.dart';

class InternetAddressWrapper {
  static var _instance = InternetAddressWrapper._();

  static InternetAddressWrapper get get => _instance;

  @visibleForTesting
  static void set(InternetAddressWrapper manager) => _instance = manager;

  InternetAddressWrapper._();

  Future<bool> get isConnected async {
    try {
      return (await InternetAddress.lookup("example.com")).isNotEmpty ||
          (await InternetAddress.lookup("google.com")).isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
