import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// What a screen shows when it has nothing yet: an icon, a short explanation
/// and, ideally, the action that fixes it.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Smaller variant for empty sections inside a screen.
  final bool compact;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final iconSize = compact ? 24.0 : 36.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: compact ? AppSpacing.sm : AppSpacing.md,
          children: [
            Container(
              padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
              decoration: BoxDecoration(
                color: tokens.accentSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: tokens.accent),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: compact
                  ? context.textTheme.titleSmall
                  : context.textTheme.titleMedium,
            ),
            if (message != null)
              Text(
                message!,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
            if (actionLabel != null && onAction != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: FilledButton.tonal(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
