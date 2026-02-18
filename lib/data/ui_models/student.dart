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
    Group? group,
    String? note,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      pricing: pricing ?? this.pricing,
      contact: contact ?? this.contact,
      iconPath: iconPath ?? this.iconPath,
      group: group ?? this.group,
      note: note ?? this.note,
    );
  }

  const Student.demo()
    : group = null,
      contact = "+380951112233",
      note = "",
      super(
        name: "Denis Skvorzov",
        pricing: const Rate(rate: 420, period: .daily),
        iconPath: null,
      );
}
