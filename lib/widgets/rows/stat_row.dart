import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// "icon  label ........ value" — one line of a stats card.
class StatRow extends StatelessWidget {
  final IconData icon;
  final StatusTone tone;
  final String label;
  final String value;

  const StatRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.tone = StatusTone.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.tone(tone);
    return Row(
      spacing: AppSpacing.md,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: AppRadius.mdAll,
          ),
          child: Icon(icon, size: 18, color: colors.fg),
        ),
        Expanded(child: Text(label, style: context.textTheme.bodyMedium)),
        Text(value, style: context.textTheme.titleSmall),
      ],
    );
  }
}
