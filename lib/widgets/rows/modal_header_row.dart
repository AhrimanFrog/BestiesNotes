import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ModalHeaderRow extends StatelessWidget {
  final String title;
  final IconData icon;

  const ModalHeaderRow({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.md,
      children: [
        Icon(icon, size: 26, color: context.tokens.accent),
        Expanded(
          child: Text(title, style: context.textTheme.headlineSmall),
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          style: IconButton.styleFrom(
            backgroundColor: context.tokens.surfaceMuted,
            foregroundColor: context.tokens.text,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
