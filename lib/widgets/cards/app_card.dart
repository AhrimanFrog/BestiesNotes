import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// The base surface for grouped content. Tappable when [onTap] is set; a
/// [stripeColor] adds a leading status/subject stripe.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? stripeColor;
  final bool raised;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.stripeColor,
    this.raised = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    Widget content = Padding(padding: padding, child: child);

    if (stripeColor != null) {
      content = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: stripeColor),
            Expanded(child: content),
          ],
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlAll,
        boxShadow: raised ? AppShadows.raised : AppShadows.card,
      ),
      child: Material(
        color: color ?? tokens.surface,
        borderRadius: AppRadius.xlAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: content,
        ),
      ),
    );
  }
}
