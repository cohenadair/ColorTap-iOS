import 'package:flutter/foundation.dart';
import 'package:mobile/wrappers/crashlytics_wrapper.dart';

class Log {
  final String _className;
  final bool _isDebug;

  const Log(
    this._className, {
    bool isDebug = kDebugMode,
  }) : _isDebug = isDebug;

  String get _prefix => "Tapd-$_className: ";

  void d(String msg) {
    _log("D/$_prefix$msg");
  }

  void e(StackTrace stackTrace, String msg) {
    _log("E/$_prefix$msg", stackTrace);
  }

  void w(String msg) {
    _log("W/$_prefix$msg");
  }

  void _log(String msg, [StackTrace? stackTrace]) {
    // Don't engage Crashlytics at all if we're on a debug build. Event if
    // crash reporting is off, Crashlytics queues crashes to be sent later.
    if (_isDebug) {
      // ignore: avoid_print
      print(msg);
      return;
    }

    if (stackTrace == null) {
      CrashlyticsWrapper.get.log(msg);
    } else {
      CrashlyticsWrapper.get.recordError(msg, stackTrace, "Logged error");
    }
  }
}
