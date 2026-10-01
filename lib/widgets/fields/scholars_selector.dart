import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/user_avatar.dart';
import 'package:flutter/material.dart';

class ScholarsSelector extends StatelessWidget {
  final String label;
  final Iterable<Teachable> selectedSubjects;
  final VoidCallback? onTap;
  final Function(Teachable)? onDeleted;

  const ScholarsSelector({
    super.key,
    required this.label,
    required this.selectedSubjects,
    this.onTap,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgAll,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.people_outline_rounded),
        ),
        child: selectedSubjects.isEmpty
            ? Text(
                'Tap to select',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.tokens.textSubtle,
                ),
              )
            : Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final s in selectedSubjects)
                    InputChip(
                      avatar: UserAvatar(teachable: s, size: 24),
                      label: Text(s.name),
                      onDeleted: onDeleted != null ? () => onDeleted!(s) : null,
                    ),
                ],
              ),
      ),
    );
  }
}
