import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/money.dart';
import 'package:equatable/equatable.dart';

import 'group.dart';
import 'rate.dart';
import 'student.dart';

/// A student being created or edited. The rate stays as typed text until
/// saved, so half-typed input ("12,") doesn't fight the field.
class StudentDraft extends Equatable {
  final String name;
  final String contact;
  final String rateInput;
  final RatePeriod period;
  final String note;
  final String? iconPath;
  final Group? group;

  const StudentDraft({
    this.name = '',
    this.contact = '',
    this.rateInput = '',
    this.period = RatePeriod.perLesson,
    this.note = '',
    this.iconPath,
    this.group,
  });

  factory StudentDraft.fromStudent(Student s) => StudentDraft(
    name: s.name,
    contact: s.contact,
    rateInput: formatAmountForInput(s.pricing.rate),
    period: s.pricing.period,
    note: s.note,
    iconPath: s.iconPath,
    group: s.group,
  );

  double? get rate => Rate.tryParseAmount(rateInput);

  bool get isValid => name.trim().isNotEmpty && (rate ?? 0) > 0;

  Student toStudent({int? id}) => Student(
    id: id,
    name: name.trim(),
    contact: contact.trim(),
    pricing: Rate(rate: rate!, period: period),
    note: note.trim(),
    iconPath: iconPath,
    group: group,
  );

  /// [iconPath] and [group] take builders so they can be cleared.
  StudentDraft copyWith({
    String? name,
    String? contact,
    String? rateInput,
    RatePeriod? period,
    String? note,
    String? Function()? iconPath,
    Group? Function()? group,
  }) {
    return StudentDraft(
      name: name ?? this.name,
      contact: contact ?? this.contact,
      rateInput: rateInput ?? this.rateInput,
      period: period ?? this.period,
      note: note ?? this.note,
      iconPath: iconPath != null ? iconPath() : this.iconPath,
      group: group != null ? group() : this.group,
    );
  }

  @override
  List<Object?> get props => [
    name,
    contact,
    rateInput,
    period,
    note,
    iconPath,
    group?.id,
  ];
}

/// A group being created or edited.
class GroupDraft extends Equatable {
  final String name;
  final String rateInput;
  final RatePeriod period;
  final String? iconPath;
  final List<Student> members;

  const GroupDraft({
    this.name = '',
    this.rateInput = '',
    this.period = RatePeriod.perLesson,
    this.iconPath,
    this.members = const [],
  });

  factory GroupDraft.fromGroup(Group g) => GroupDraft(
    name: g.name,
    rateInput: formatAmountForInput(g.pricing.rate),
    period: g.pricing.period,
    iconPath: g.iconPath,
    members: g.students.toList(),
  );

  double? get rate => Rate.tryParseAmount(rateInput);

  bool get isValid =>
      name.trim().isNotEmpty && (rate ?? 0) > 0 && members.isNotEmpty;

  Group toGroup({int? id}) => Group(
    id: id,
    name: name.trim(),
    pricing: Rate(rate: rate!, period: period),
    iconPath: iconPath,
    students: members.toSet(),
  );

  GroupDraft copyWith({
    String? name,
    String? rateInput,
    RatePeriod? period,
    String? Function()? iconPath,
    List<Student>? members,
  }) {
    return GroupDraft(
      name: name ?? this.name,
      rateInput: rateInput ?? this.rateInput,
      period: period ?? this.period,
      iconPath: iconPath != null ? iconPath() : this.iconPath,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props => [
    name,
    rateInput,
    period,
    iconPath,
    // Membership, not order or stale copies of the students.
    {for (final m in members) m.id},
  ];
}
