import 'rate.dart';
import 'group.dart';
import 'teachable.dart';

class Student extends Teachable {
  final Group? group;
  final String contact;

  const Student({
    super.id,
    required super.name,
    required super.pricing,
    required this.contact,
    super.iconPath,
    this.group,
  });

  Student copyWith({
    int? id,
    String? name,
    Rate? pricing,
    String? contact,
    String? iconPath,
    Group? Function()? group,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      pricing: pricing ?? this.pricing,
      contact: contact ?? this.contact,
      iconPath: iconPath ?? this.iconPath,
      group: group != null ? group() : this.group,
    );
  }

  // Only the group id: comparing the whole group would pull its member set in.
  @override
  List<Object?> get props => [...super.props, group?.id, contact];

  const Student.demo()
    : group = null,
      contact = "Loading...",
      super(
        name: "Loading...",
        pricing: const Rate(rate: 0, period: .perLesson),
        iconPath: null,
      );
}
