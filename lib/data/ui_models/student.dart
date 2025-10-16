import 'group.dart';
import 'teachable.dart';

class Student extends Teachable {
  Group? group;

  Student({
    required super.name,
    required super.pricing,
    super.iconPath,
    this.group,
  });
}
