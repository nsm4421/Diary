import 'package:flutter/material.dart';

class AuthRequiredDialog extends StatelessWidget {
  const AuthRequiredDialog({
    super.key,
    this.title = '로그인 필요',
    this.message = '로그인을 해야 이용할 수 있어요.',
    this.cancelLabel = '취소',
    this.confirmLabel = '로그인 화면으로 이동',
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;

  static Future<bool> show(
    BuildContext context, {
    String title = '로그인 필요',
    String message = '로그인을 해야 이용할 수 있어요.',
    String cancelLabel = '취소',
    String confirmLabel = '로그인 화면으로 이동',
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AuthRequiredDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
