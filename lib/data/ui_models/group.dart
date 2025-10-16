import 'student.dart';

import 'teachable.dart';

class Group extends Teachable {
  Set<Student> students;

  Group({
    required super.name,
    required super.pricing,
    super.iconPath,
    Set<Student>? students,
  }) : students = students ?? {};
}
