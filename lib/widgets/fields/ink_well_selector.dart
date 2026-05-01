import 'package:flutter/material.dart';

class InkWellSelector extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onTap;

  const InkWellSelector({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Text(body),
      ),
    );
  }
}
