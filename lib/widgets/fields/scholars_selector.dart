import 'package:besties_notes/data/ui_models/teachable.dart';
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
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.people),
        ),
        child: selectedSubjects.isEmpty
            ? const Text('Tap to select', style: TextStyle(color: Colors.grey))
            : Wrap(
                spacing: 8,
                runSpacing: 4,
                children: selectedSubjects
                    .map(
                      (s) => Chip(
                        label: Text(s.name),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: onDeleted != null
                            ? () => onDeleted!(s)
                            : null,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
