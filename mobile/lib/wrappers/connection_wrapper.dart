import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionWrapper {
  static var _instance = ConnectionWrapper._();

  static ConnectionWrapper get get => _instance;

  @visibleForTesting
  static void set(ConnectionWrapper manager) => _instance = manager;

  ConnectionWrapper._();

  Future<bool> get hasInternetAddress => InternetConnection().hasInternetAccess;
}
