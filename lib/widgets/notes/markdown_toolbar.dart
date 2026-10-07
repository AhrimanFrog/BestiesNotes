import 'package:besties_notes/data/markdown_lite.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Formatting buttons for a note's body field. Programmatic edits don't fire
/// the field's `onChanged`, so changes are reported through [onChanged].
class MarkdownToolbar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MarkdownToolbar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  void _apply(TextEditingValue Function(TextEditingValue) edit) {
    controller.value = edit(controller.value);
    onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    // Taps here count as inside the text field, so it keeps focus.
    return TextFieldTapRegion(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.surface,
          border: Border(top: BorderSide(color: tokens.divider)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              for (final (icon, tooltip, edit) in [
                (
                  Icons.format_bold_rounded,
                  l10n.noteBold,
                  (TextEditingValue v) => MarkdownLite.toggleWrap(v, '**'),
                ),
                (
                  Icons.format_italic_rounded,
                  l10n.noteItalic,
                  (TextEditingValue v) => MarkdownLite.toggleWrap(v, '_'),
                ),
                (
                  Icons.format_list_bulleted_rounded,
                  l10n.noteBulletList,
                  (TextEditingValue v) =>
                      MarkdownLite.toggleList(v, MdListKind.bullet),
                ),
                (
                  Icons.checklist_rounded,
                  l10n.noteChecklist,
                  (TextEditingValue v) =>
                      MarkdownLite.toggleList(v, MdListKind.checkbox),
                ),
              ])
                IconButton(
                  icon: Icon(icon),
                  tooltip: tooltip,
                  onPressed: () => _apply(edit),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
