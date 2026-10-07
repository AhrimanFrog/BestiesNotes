import 'package:besties_notes/data/markdown_lite.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:flutter/material.dart';

/// A note in a list: title, a preview of the text, what it's linked to and
/// checklist progress.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;

  /// Hide the link chip where it's obvious (a student's own notes).
  final bool showLink;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.showLink = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final preview = MarkdownLite.plainText(note.body);
    final progress = MarkdownLite.checklistProgress(note.body);
    final title = note.title.trim().isNotEmpty ? note.title : null;

    final meta = [
      if (note.updatedAt case final at?) at.toDayMonthFormat(),
      if (progress.total > 0)
        l10n.noteChecklistProgress(progress.done, progress.total),
    ].join(' · ');

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text(
                  title ?? (preview.isNotEmpty ? preview : l10n.noteUntitled),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall,
                ),
              ),
              if (note.isPinned)
                Icon(
                  Icons.push_pin_rounded,
                  size: 16,
                  color: tokens.accent,
                  semanticLabel: l10n.notePinned,
                ),
            ],
          ),
          // The preview is already the heading of an untitled note.
          if (title != null && preview.isNotEmpty)
            Text(
              preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall,
            ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (showLink) ...noteLinkChips(context, note),
              if (meta.isNotEmpty)
                Text(meta, style: context.textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small chips naming the student and lesson a note is about.
List<Widget> noteLinkChips(BuildContext context, Note note) {
  return [
    if (note.studentName case final name?)
      _LinkChip(icon: Icons.person_outline_rounded, label: name),
    if (note.lessonName case final lesson?)
      _LinkChip(
        icon: Icons.event_note_outlined,
        label: [
          lesson,
          if (note.lessonStart case final start?) start.toDayMonthFormat(),
        ].join(' · '),
      ),
  ];
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LinkChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xs,
        children: [
          Icon(icon, size: 14, color: tokens.textMuted),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
