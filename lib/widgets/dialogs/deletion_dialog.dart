import 'package:flutter/material.dart';

class DeletionDialog extends StatelessWidget {
  final String entryName;
  final VoidCallback? onDelete;

  const DeletionDialog({super.key, required this.entryName, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete $entryName'),
      content: Text('Are you sure you want to delete $entryName?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onDelete != null) onDelete!();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
