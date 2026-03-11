import 'rate.dart';
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
