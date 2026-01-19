import 'package:flutter/material.dart';

enum _ToastType { success, error, warning }

final appScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class ToastUtil {
  ToastUtil._();

  static void success(String message, {Duration? duration}) {
    _show(
      message,
      type: _ToastType.success,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static void error(String message, {Duration? duration}) {
    _show(
      message,
      type: _ToastType.error,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static void warning(String message, {Duration? duration}) {
    _show(
      message,
      type: _ToastType.warning,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static void _show(
    String message, {
    _ToastType type = _ToastType.success,
    Duration duration = const Duration(seconds: 2),
  }) {
    final messenger = appScaffoldMessengerKey.currentState;
    if (messenger == null) {
      return;
    }

    final colorScheme = Theme.of(messenger.context).colorScheme;
    final backgroundColor = switch (type) {
      _ToastType.success => colorScheme.primary,
      _ToastType.error => colorScheme.error,
      _ToastType.warning => Color(0xFFF4B740),
    };
    final textColor = switch (type) {
      _ToastType.success => colorScheme.onPrimary,
      _ToastType.error => colorScheme.onError,
      _ToastType.warning => Color(0xFF241A00),
    };

    final iconColor = switch (type) {
      _ToastType.success => colorScheme.onPrimary,
      _ToastType.error => colorScheme.onError,
      _ToastType.warning => Color(0xFF241A00),
    };
    final icon = switch (type) {
      _ToastType.success => Icons.check_circle_rounded,
      _ToastType.error => Icons.error_rounded,
      _ToastType.warning => Icons.warning_rounded,
    };

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          content: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message, style: TextStyle(color: textColor)),
              ),
            ],
          ),
        ),
      );
  }
}
