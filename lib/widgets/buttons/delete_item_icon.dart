import 'package:flutter/material.dart';
import 'package:besties_notes/common/app_colors.dart';

class DeleteItemIcon extends StatelessWidget {
  final VoidCallback? onDelete;

  const DeleteItemIcon({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, size: 20),
      color: AppColors.secondaryText,
      onPressed: onDelete,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
