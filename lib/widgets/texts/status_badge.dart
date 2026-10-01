import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A small pill label colored by a semantic [StatusTone].
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusTone tone;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.tone(tone);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xs,
        children: [
          if (icon != null) Icon(icon, size: 12, color: colors.fg),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(color: colors.fg),
          ),
        ],
      ),
    );
  }
}
