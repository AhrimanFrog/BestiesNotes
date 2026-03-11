import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/rate.dart';

import 'student.dart';
import 'teachable.dart';

class Group extends Teachable {
  final Set<Student> students;

  const Group({
    super.id,
    required super.name,
    required super.pricing,
    super.iconPath,
    Set<Student>? students,
  }) : students = students ?? const {};

  const Group.demo()
    : students = const {},
      super(
        name: 'Loading...',
        pricing: const Rate(rate: 0, period: RatePeriod.daily),
        iconPath: null,
      );

  Group copyWith({
    int? id,
    String? name,
    Rate? pricing,
    String? iconPath,
    Set<Student>? students,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      pricing: pricing ?? this.pricing,
      iconPath: iconPath ?? this.iconPath,
      students: students ?? this.students,
    );
  }
}
