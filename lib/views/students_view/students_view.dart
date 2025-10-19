import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Text("Students will be here"),
      ),
    );
  }
}
