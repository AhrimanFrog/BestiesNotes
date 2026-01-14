import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/db_client.dart';

extension DbStudentExt on DbStudent {
  Student toDomain({Group? group}) {
    return Student(
      id: id,
      name: name,
      pricing: Rate(rate: payRate, period: period),
      contact: contact,
      note: notes,
      iconPath: avatarPath,
      group: group,
    );
  }
}
