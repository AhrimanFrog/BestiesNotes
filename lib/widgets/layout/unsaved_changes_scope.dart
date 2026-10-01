import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum UnsavedChoice { save, discard, keepEditing }

/// Guards an edit mode against losing work.
///
/// While [isEditing], back gestures don't leave the screen: they go through
/// [leaveEditing], which asks Save / Discard / Keep editing when there are
/// unsaved changes and simply exits otherwise.
class UnsavedChangesScope extends StatelessWidget {
  final bool isEditing;
  final bool isDirty;

  /// Persists the changes; returns whether it succeeded.
  final Future<bool> Function() onSave;

  /// Leaves edit mode without saving (or closes the screen for new items).
  final VoidCallback onDiscard;

  final Widget child;

  const UnsavedChangesScope({
    super.key,
    required this.isEditing,
    required this.isDirty,
    required this.onSave,
    required this.onDiscard,
    required this.child,
  });

  /// The same flow for explicit "close" buttons inside edit mode.
  static Future<void> leaveEditing(
    BuildContext context, {
    required bool isDirty,
    required Future<bool> Function() onSave,
    required VoidCallback onDiscard,
  }) async {
    if (!isDirty) {
      onDiscard();
      return;
    }
    final choice = await showUnsavedChangesSheet(context);
    switch (choice) {
      case UnsavedChoice.save:
        await onSave();
      case UnsavedChoice.discard:
        onDiscard();
      case UnsavedChoice.keepEditing || null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isEditing,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        leaveEditing(
          context,
          isDirty: isDirty,
          onSave: onSave,
          onDiscard: onDiscard,
        );
      },
      child: child,
    );
  }
}

Future<UnsavedChoice?> showUnsavedChangesSheet(BuildContext context) {
  return showModalBottomSheet<UnsavedChoice>(
    context: context,
    useRootNavigator: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          0,
          AppSpacing.xxl,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Text('Unsaved changes', style: context.textTheme.headlineSmall),
            Text(
              'Save them before leaving?',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: () => Navigator.pop(context, UnsavedChoice.save),
              child: const Text('Save changes'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, UnsavedChoice.discard),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.tokens.danger,
              ),
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, UnsavedChoice.keepEditing),
              child: const Text('Keep editing'),
            ),
          ],
        ),
      ),
    ),
  );
}
