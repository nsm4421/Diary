import 'package:flutter/material.dart';

extension ToastExtension on BuildContext {
  void showToast(String message, {Color? color}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color ?? Colors.black.withAlpha(80),
          content: Text(message, style: const TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
