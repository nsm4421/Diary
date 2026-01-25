mixin class DevLoggerMixIn {
  static bool get _enabled {
    var enabled = false;
    assert(() {
      enabled = true;
      return true;
    }());
    return enabled;
  }

  void logD(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_enabled) return;

    print('[DEBUG] $message');
    if (error != null) print(error);
    if (stackTrace != null) print(stackTrace);
  }

  void logE(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_enabled) return;

    print('[ERROR] $message');
    if (error != null) print(error);
    if (stackTrace != null) print(stackTrace);
  }
}
