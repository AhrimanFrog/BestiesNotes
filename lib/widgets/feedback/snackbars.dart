import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  final tokens = context.tokens;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: tokens.danger,
      content: Row(
        spacing: AppSpacing.md,
        children: [
          Icon(Icons.error_outline_rounded, color: tokens.onAccent),
          Expanded(
            child: Text(message, style: TextStyle(color: tokens.onAccent)),
          ),
        ],
      ),
    ),
  );
}

void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
