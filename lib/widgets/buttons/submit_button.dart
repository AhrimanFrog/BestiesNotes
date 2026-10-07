import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A full-width primary button that shows a spinner while [isSubmitting].
class SubmitButton extends StatelessWidget {
  final String label;
  final bool isSubmitting;
  final VoidCallback? onPressed;

  const SubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isSubmitting ? null : onPressed,
      child: isSubmitting
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.tokens.textMuted,
              ),
            )
          : Text(label),
    );
  }
}
