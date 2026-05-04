import 'package:besties_notes/common/app_colors.dart';
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

  static final _borderRadius = BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: _borderRadius,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.people),
          border: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: const BorderSide(color: AppColors.softPink),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: const BorderSide(color: AppColors.softPink),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: _borderRadius,
            borderSide: const BorderSide(color: AppColors.accentPink, width: 2),
          ),
        ),
        child: selectedSubjects.isEmpty
            ? const Text(
                'Tap to select',
                style: TextStyle(color: AppColors.secondaryText),
              )
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
