import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Asks the user to confirm an action. Resolves to `true` only when the
/// confirm button is pressed; dismissing counts as "no".
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      destructive: destructive,
    ),
  );
  return confirmed ?? false;
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AlertDialog(
      title: Text(title),
      content: message != null ? Text(message!) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: tokens.textMuted),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: tokens.danger)
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
