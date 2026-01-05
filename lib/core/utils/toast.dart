import 'package:flutter/material.dart';

final appScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

enum ToastType { success, failure, warning }

class Toast {
  static void _show(
    String message, {
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 2),
  }) {
    final messenger = appScaffoldMessengerKey.currentState;
    if (messenger == null) {
      return;
    }

    final colorScheme = Theme.of(messenger.context).colorScheme;
    final backgroundColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.failure => colorScheme.error,
      ToastType.warning => Color(0xFFF4B740),
    };
    final textColor = switch (type) {
      ToastType.success => colorScheme.onPrimary,
      ToastType.failure => colorScheme.onError,
      ToastType.warning => Color(0xFF241A00),
    };

    final iconColor = switch (type) {
      ToastType.success => colorScheme.onPrimary,
      ToastType.failure => colorScheme.onError,
      ToastType.warning => Color(0xFF241A00),
    };
    final icon = switch (type) {
      ToastType.success => Icons.check_circle_rounded,
      ToastType.failure => Icons.error_rounded,
      ToastType.warning => Icons.warning_rounded,
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

  static void success(String message, {Duration? duration}) {
    _show(
      message,
      type: ToastType.success,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static void failure(String message, {Duration? duration}) {
    _show(
      message,
      type: ToastType.failure,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static void warning(String message, {Duration? duration}) {
    _show(
      message,
      type: ToastType.warning,
      duration: duration ?? const Duration(seconds: 2),
    );
  }
}
