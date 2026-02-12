import 'package:flutter/material.dart';
import 'package:besties_notes/data/ui_models/index.dart';

class TeachableSelectionDialog extends StatefulWidget {
  final String title;
  final List<Teachable> available;
  final Iterable<Teachable> selected;

  const TeachableSelectionDialog({
    super.key,
    required this.title,
    required this.available,
    required this.selected,
  });

  @override
  State<TeachableSelectionDialog> createState() =>
      _TeachableSelectionDialogState();
}

class _TeachableSelectionDialogState extends State<TeachableSelectionDialog> {
  late List<Teachable> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.available.length,
          itemBuilder: (context, index) {
            final teachable = widget.available[index];
            final isSelected = _selected.any((t) => t.id == teachable.id);
            final isGroup = teachable is Group;

            return CheckboxListTile(
              value: isSelected,
              title: Text(teachable.name),
              subtitle: Text(
                isGroup ? 'Group' : (teachable as Student).contact,
              ),
              secondary: Icon(isGroup ? Icons.groups : Icons.person),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selected.add(teachable);
                  } else {
                    _selected.removeWhere((t) => t.id == teachable.id);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selected),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
