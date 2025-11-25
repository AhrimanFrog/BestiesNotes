import 'rate.dart';
import 'group.dart';
import 'teachable.dart';

class Student extends Teachable {
  Group? group;
  String contact;
  String note = "";

  Student({
    super.id,
    required super.name,
    required super.pricing,
    required this.contact,
    super.iconPath,
    this.group,
    this.note = "",
  });

  Student.demo()
      : group = null,
        contact = "+380951112233",
        super(
          name: "Denis Skvorzov",
          pricing: Rate(rate: 420, period: .daily),
          iconPath: null,
        );
}
