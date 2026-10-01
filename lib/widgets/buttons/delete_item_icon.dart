import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DeleteItemIcon extends StatelessWidget {
  final VoidCallback? onDelete;

  const DeleteItemIcon({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close_rounded, size: 18),
      color: context.tokens.textSubtle,
      tooltip: 'Delete',
      onPressed: onDelete,
    );
  }
}
