import 'package:flutter/material.dart';
import 'package:besties_notes/widgets/index.dart' show Tag;

class NoteRow extends StatelessWidget {
  final String note;

  const NoteRow({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 12,
          children: [
            Text('Note', style: Theme.of(context).textTheme.titleMedium),
            Icon(
              Icons.edit_note_outlined,
              size: 24,
              color: Colors.grey.shade700,
            ),
          ],
        ),
        Tag(label: note),
      ],
    );
  }
}
