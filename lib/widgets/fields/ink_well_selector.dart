import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A tappable, input-styled field that opens a picker (date, time, …).
class InkWellSelector extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final VoidCallback? onTap;

  const InkWellSelector({
    super.key,
    required this.title,
    required this.body,
    this.icon = Icons.access_time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgAll,
      child: InputDecorator(
        decoration: InputDecoration(labelText: title, prefixIcon: Icon(icon)),
        child: Text(body, style: context.textTheme.bodyLarge),
      ),
    );
  }
}
