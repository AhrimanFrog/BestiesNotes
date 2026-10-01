import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';

/// Sticky "Discard | Save" bar for edit modes, in thumb reach.
class SaveBar extends StatelessWidget {
  final String saveLabel;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const SaveBar({
    super.key,
    required this.saveLabel,
    required this.isSaving,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.tokens.surface,
        border: Border(top: BorderSide(color: context.tokens.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSaving ? null : onDiscard,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.tokens.textMuted,
                  ),
                  child: const Text('Discard'),
                ),
              ),
              Expanded(
                flex: 2,
                child: SubmitButton(
                  label: saveLabel,
                  isSubmitting: isSaving,
                  onPressed: onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
