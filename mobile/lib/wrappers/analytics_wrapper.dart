import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsWrapper {
  static var _instance = AnalyticsWrapper._();

  static AnalyticsWrapper get get => _instance;

  @visibleForTesting
  static void set(AnalyticsWrapper manager) => _instance = manager;

  AnalyticsWrapper._();

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    return FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
      callOptions: callOptions,
    );
  }
}
