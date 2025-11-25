import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/data/ui_models/index.dart';

extension DbGroupExt on DbGroup {
  Group toDomain({Set<Student>? students}) {
    return Group(
      name: name,
      pricing: Rate(rate: payRate, period: period),
      iconPath: avatarPath,
      students: students,
    );
  }
}
