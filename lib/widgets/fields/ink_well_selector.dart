import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

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

  static final _borderRadius = BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: _borderRadius,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon),
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
        child: Text(body),
      ),
    );
  }
}
