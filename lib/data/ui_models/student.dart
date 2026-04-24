import 'rate.dart';
import 'group.dart';
import 'teachable.dart';

class Student extends Teachable {
  final Group? group;
  final String contact;
  final String note;

  const Student({
    super.id,
    required super.name,
    required super.pricing,
    required this.contact,
    super.iconPath,
    this.group,
    this.note = "",
  });

  Student copyWith({
    int? id,
    String? name,
    Rate? pricing,
    String? contact,
    String? iconPath,
    Group? Function()? group,
    String? note,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      pricing: pricing ?? this.pricing,
      contact: contact ?? this.contact,
      iconPath: iconPath ?? this.iconPath,
      group: group != null ? group() : this.group,
      note: note ?? this.note,
    );
  }

  const Student.demo()
    : group = null,
      contact = "Loading...",
      note = "",
      super(
        name: "Loading...",
        pricing: const Rate(rate: 0, period: .daily),
        iconPath: null,
      );
}
