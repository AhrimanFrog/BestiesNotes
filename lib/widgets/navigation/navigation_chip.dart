import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A pill that links to a related screen ("Payments ›").
class NavigationChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final StatusTone tone;
  final VoidCallback? onTap;

  const NavigationChip({
    super.key,
    required this.icon,
    required this.label,
    this.tone = StatusTone.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.tone(tone);
    return Material(
      color: colors.bg,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.xs + 2,
              children: [
                Icon(icon, size: 18, color: colors.fg),
                // Long names (e.g. a group) ellipsize within the space given.
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: colors.fg,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18, color: colors.fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
