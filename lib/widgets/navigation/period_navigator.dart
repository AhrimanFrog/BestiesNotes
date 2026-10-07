import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// "‹  28 Sep – 4 Oct  ›" — steps through calendar periods. Tapping the
/// label lets the user jump to a date.
class PeriodNavigator extends StatelessWidget {
  final String label;
  final String previousTooltip;
  final String nextTooltip;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onLabelTap;

  const PeriodNavigator({
    super.key,
    required this.label,
    required this.previousTooltip,
    required this.nextTooltip,
    this.onPrevious,
    this.onNext,
    this.onLabelTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = context.tokens.accent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          color: accent,
          tooltip: previousTooltip,
          onPressed: onPrevious,
        ),
        Flexible(
          // Shrinks instead of overflowing with large system text.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: onLabelTap,
              style: TextButton.styleFrom(foregroundColor: context.tokens.text),
              child: Text(label, style: context.textTheme.titleSmall),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          color: accent,
          tooltip: nextTooltip,
          onPressed: onNext,
        ),
      ],
    );
  }
}
