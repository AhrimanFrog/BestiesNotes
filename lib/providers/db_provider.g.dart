// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_provider.dart';

// ignore_for_file: type=lint
class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationInMinutesMeta = const VerificationMeta(
    'durationInMinutes',
  );
  @override
  late final GeneratedColumn<int> durationInMinutes = GeneratedColumn<int>(
    'duration_in_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, start, durationInMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('duration_in_minutes')) {
      context.handle(
        _durationInMinutesMeta,
        durationInMinutes.isAcceptableOrUnknown(
          data['duration_in_minutes']!,
          _durationInMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationInMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      durationInMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_in_minutes'],
      )!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final int id;
  final String name;
  final DateTime start;
  final int durationInMinutes;
  const Lesson({
    required this.id,
    required this.name,
    required this.start,
    required this.durationInMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start'] = Variable<DateTime>(start);
    map['duration_in_minutes'] = Variable<int>(durationInMinutes);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      name: Value(name),
      start: Value(start),
      durationInMinutes: Value(durationInMinutes),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      start: serializer.fromJson<DateTime>(json['start']),
      durationInMinutes: serializer.fromJson<int>(json['durationInMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'start': serializer.toJson<DateTime>(start),
      'durationInMinutes': serializer.toJson<int>(durationInMinutes),
    };
  }

  Lesson copyWith({
    int? id,
    String? name,
    DateTime? start,
    int? durationInMinutes,
  }) => Lesson(
    id: id ?? this.id,
    name: name ?? this.name,
    start: start ?? this.start,
    durationInMinutes: durationInMinutes ?? this.durationInMinutes,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      start: data.start.present ? data.start.value : this.start,
      durationInMinutes: data.durationInMinutes.present
          ? data.durationInMinutes.value
          : this.durationInMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('start: $start, ')
          ..write('durationInMinutes: $durationInMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, start, durationInMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.name == this.name &&
          other.start == this.start &&
          other.durationInMinutes == this.durationInMinutes);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> start;
  final Value<int> durationInMinutes;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.start = const Value.absent(),
    this.durationInMinutes = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime start,
    required int durationInMinutes,
  }) : name = Value(name),
       start = Value(start),
       durationInMinutes = Value(durationInMinutes);
  static Insertable<Lesson> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? start,
    Expression<int>? durationInMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (start != null) 'start': start,
      if (durationInMinutes != null) 'duration_in_minutes': durationInMinutes,
    });
  }

  LessonsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? start,
    Value<int>? durationInMinutes,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      start: start ?? this.start,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (durationInMinutes.present) {
      map['duration_in_minutes'] = Variable<int>(durationInMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('start: $start, ')
          ..write('durationInMinutes: $durationInMinutes')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricingMeta = const VerificationMeta(
    'pricing',
  );
  @override
  late final GeneratedColumn<double> pricing = GeneratedColumn<double>(
    'pricing',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RatePeriod, String> period =
      GeneratedColumn<String>(
        'period',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RatePeriod>($StudentsTable.$converterperiod);
  @override
  List<GeneratedColumn> get $columns => [id, name, pricing, period];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pricing')) {
      context.handle(
        _pricingMeta,
        pricing.isAcceptableOrUnknown(data['pricing']!, _pricingMeta),
      );
    } else if (isInserting) {
      context.missing(_pricingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pricing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pricing'],
      )!,
      period: $StudentsTable.$converterperiod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period'],
        )!,
      ),
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RatePeriod, String, String> $converterperiod =
      const EnumNameConverter<RatePeriod>(RatePeriod.values);
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String name;
  final double pricing;
  final RatePeriod period;
  const Student({
    required this.id,
    required this.name,
    required this.pricing,
    required this.period,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['pricing'] = Variable<double>(pricing);
    {
      map['period'] = Variable<String>(
        $StudentsTable.$converterperiod.toSql(period),
      );
    }
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      name: Value(name),
      pricing: Value(pricing),
      period: Value(period),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pricing: serializer.fromJson<double>(json['pricing']),
      period: $StudentsTable.$converterperiod.fromJson(
        serializer.fromJson<String>(json['period']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'pricing': serializer.toJson<double>(pricing),
      'period': serializer.toJson<String>(
        $StudentsTable.$converterperiod.toJson(period),
      ),
    };
  }

  Student copyWith({
    int? id,
    String? name,
    double? pricing,
    RatePeriod? period,
  }) => Student(
    id: id ?? this.id,
    name: name ?? this.name,
    pricing: pricing ?? this.pricing,
    period: period ?? this.period,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pricing: data.pricing.present ? data.pricing.value : this.pricing,
      period: data.period.present ? data.period.value : this.period,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pricing: $pricing, ')
          ..write('period: $period')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pricing, period);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.name == this.name &&
          other.pricing == this.pricing &&
          other.period == this.period);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> pricing;
  final Value<RatePeriod> period;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pricing = const Value.absent(),
    this.period = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double pricing,
    required RatePeriod period,
  }) : name = Value(name),
       pricing = Value(pricing),
       period = Value(period);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? pricing,
    Expression<String>? period,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pricing != null) 'pricing': pricing,
      if (period != null) 'period': period,
    });
  }

  StudentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? pricing,
    Value<RatePeriod>? period,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pricing: pricing ?? this.pricing,
      period: period ?? this.period,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pricing.present) {
      map['pricing'] = Variable<double>(pricing.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(
        $StudentsTable.$converterperiod.toSql(period.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pricing: $pricing, ')
          ..write('period: $period')
          ..write(')'))
        .toString();
  }
}

class $StudentsLessonsTable extends StudentsLessons
    with TableInfo<$StudentsLessonsTable, StudentsLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [studentId, lessonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentsLesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, studentId};
  @override
  StudentsLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentsLesson(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
    );
  }

  @override
  $StudentsLessonsTable createAlias(String alias) {
    return $StudentsLessonsTable(attachedDatabase, alias);
  }
}

class StudentsLesson extends DataClass implements Insertable<StudentsLesson> {
  final int studentId;
  final int lessonId;
  const StudentsLesson({required this.studentId, required this.lessonId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<int>(studentId);
    map['lesson_id'] = Variable<int>(lessonId);
    return map;
  }

  StudentsLessonsCompanion toCompanion(bool nullToAbsent) {
    return StudentsLessonsCompanion(
      studentId: Value(studentId),
      lessonId: Value(lessonId),
    );
  }

  factory StudentsLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentsLesson(
      studentId: serializer.fromJson<int>(json['studentId']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<int>(studentId),
      'lessonId': serializer.toJson<int>(lessonId),
    };
  }

  StudentsLesson copyWith({int? studentId, int? lessonId}) => StudentsLesson(
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
  );
  StudentsLesson copyWithCompanion(StudentsLessonsCompanion data) {
    return StudentsLesson(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentsLesson(')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(studentId, lessonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentsLesson &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId);
}

class StudentsLessonsCompanion extends UpdateCompanion<StudentsLesson> {
  final Value<int> studentId;
  final Value<int> lessonId;
  final Value<int> rowid;
  const StudentsLessonsCompanion({
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsLessonsCompanion.insert({
    required int studentId,
    required int lessonId,
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       lessonId = Value(lessonId);
  static Insertable<StudentsLesson> custom({
    Expression<int>? studentId,
    Expression<int>? lessonId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsLessonsCompanion copyWith({
    Value<int>? studentId,
    Value<int>? lessonId,
    Value<int>? rowid,
  }) {
    return StudentsLessonsCompanion(
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsLessonsCompanion(')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoadmapNodesTable extends RoadmapNodes
    with TableInfo<$RoadmapNodesTable, RoadmapNode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoadmapNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isHomeworkDoneMeta = const VerificationMeta(
    'isHomeworkDone',
  );
  @override
  late final GeneratedColumn<bool> isHomeworkDone = GeneratedColumn<bool>(
    'is_homework_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_homework_done" IN (0, 1))',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isPaid,
    isHomeworkDone,
    studentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roadmap_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoadmapNode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    } else if (isInserting) {
      context.missing(_isPaidMeta);
    }
    if (data.containsKey('is_homework_done')) {
      context.handle(
        _isHomeworkDoneMeta,
        isHomeworkDone.isAcceptableOrUnknown(
          data['is_homework_done']!,
          _isHomeworkDoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isHomeworkDoneMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoadmapNode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoadmapNode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      isHomeworkDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_homework_done'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
    );
  }

  @override
  $RoadmapNodesTable createAlias(String alias) {
    return $RoadmapNodesTable(attachedDatabase, alias);
  }
}

class RoadmapNode extends DataClass implements Insertable<RoadmapNode> {
  final int id;
  final String name;
  final bool isPaid;
  final bool isHomeworkDone;
  final int studentId;
  const RoadmapNode({
    required this.id,
    required this.name,
    required this.isPaid,
    required this.isHomeworkDone,
    required this.studentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_paid'] = Variable<bool>(isPaid);
    map['is_homework_done'] = Variable<bool>(isHomeworkDone);
    map['student_id'] = Variable<int>(studentId);
    return map;
  }

  RoadmapNodesCompanion toCompanion(bool nullToAbsent) {
    return RoadmapNodesCompanion(
      id: Value(id),
      name: Value(name),
      isPaid: Value(isPaid),
      isHomeworkDone: Value(isHomeworkDone),
      studentId: Value(studentId),
    );
  }

  factory RoadmapNode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoadmapNode(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      isHomeworkDone: serializer.fromJson<bool>(json['isHomeworkDone']),
      studentId: serializer.fromJson<int>(json['studentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isPaid': serializer.toJson<bool>(isPaid),
      'isHomeworkDone': serializer.toJson<bool>(isHomeworkDone),
      'studentId': serializer.toJson<int>(studentId),
    };
  }

  RoadmapNode copyWith({
    int? id,
    String? name,
    bool? isPaid,
    bool? isHomeworkDone,
    int? studentId,
  }) => RoadmapNode(
    id: id ?? this.id,
    name: name ?? this.name,
    isPaid: isPaid ?? this.isPaid,
    isHomeworkDone: isHomeworkDone ?? this.isHomeworkDone,
    studentId: studentId ?? this.studentId,
  );
  RoadmapNode copyWithCompanion(RoadmapNodesCompanion data) {
    return RoadmapNode(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      isHomeworkDone: data.isHomeworkDone.present
          ? data.isHomeworkDone.value
          : this.isHomeworkDone,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoadmapNode(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isPaid: $isPaid, ')
          ..write('isHomeworkDone: $isHomeworkDone, ')
          ..write('studentId: $studentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isPaid, isHomeworkDone, studentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoadmapNode &&
          other.id == this.id &&
          other.name == this.name &&
          other.isPaid == this.isPaid &&
          other.isHomeworkDone == this.isHomeworkDone &&
          other.studentId == this.studentId);
}

class RoadmapNodesCompanion extends UpdateCompanion<RoadmapNode> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isPaid;
  final Value<bool> isHomeworkDone;
  final Value<int> studentId;
  const RoadmapNodesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.isHomeworkDone = const Value.absent(),
    this.studentId = const Value.absent(),
  });
  RoadmapNodesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool isPaid,
    required bool isHomeworkDone,
    required int studentId,
  }) : name = Value(name),
       isPaid = Value(isPaid),
       isHomeworkDone = Value(isHomeworkDone),
       studentId = Value(studentId);
  static Insertable<RoadmapNode> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isPaid,
    Expression<bool>? isHomeworkDone,
    Expression<int>? studentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isPaid != null) 'is_paid': isPaid,
      if (isHomeworkDone != null) 'is_homework_done': isHomeworkDone,
      if (studentId != null) 'student_id': studentId,
    });
  }

  RoadmapNodesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isPaid,
    Value<bool>? isHomeworkDone,
    Value<int>? studentId,
  }) {
    return RoadmapNodesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isPaid: isPaid ?? this.isPaid,
      isHomeworkDone: isHomeworkDone ?? this.isHomeworkDone,
      studentId: studentId ?? this.studentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (isHomeworkDone.present) {
      map['is_homework_done'] = Variable<bool>(isHomeworkDone.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoadmapNodesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isPaid: $isPaid, ')
          ..write('isHomeworkDone: $isHomeworkDone, ')
          ..write('studentId: $studentId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $StudentsLessonsTable studentsLessons = $StudentsLessonsTable(
    this,
  );
  late final $RoadmapNodesTable roadmapNodes = $RoadmapNodesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    lessons,
    students,
    studentsLessons,
    roadmapNodes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('students_lessons', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('students_lessons', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LessonsTableCreateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime start,
      required int durationInMinutes,
    });
typedef $$LessonsTableUpdateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> start,
      Value<int> durationInMinutes,
    });

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudentsLessonsTable, List<StudentsLesson>>
  _studentsLessonsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studentsLessons,
    aliasName: $_aliasNameGenerator(db.lessons.id, db.studentsLessons.lessonId),
  );

  $$StudentsLessonsTableProcessedTableManager get studentsLessonsRefs {
    final manager = $$StudentsLessonsTableTableManager(
      $_db,
      $_db.studentsLessons,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studentsLessonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studentsLessonsRefs(
    Expression<bool> Function($$StudentsLessonsTableFilterComposer f) f,
  ) {
    final $$StudentsLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentsLessons,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsLessonsTableFilterComposer(
            $db: $db,
            $table: $db.studentsLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => column,
  );

  Expression<T> studentsLessonsRefs<T extends Object>(
    Expression<T> Function($$StudentsLessonsTableAnnotationComposer a) f,
  ) {
    final $$StudentsLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentsLessons,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.studentsLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, $$LessonsTableReferences),
          Lesson,
          PrefetchHooks Function({bool studentsLessonsRefs})
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<int> durationInMinutes = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                name: name,
                start: start,
                durationInMinutes: durationInMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime start,
                required int durationInMinutes,
              }) => LessonsCompanion.insert(
                id: id,
                name: name,
                start: start,
                durationInMinutes: durationInMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentsLessonsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studentsLessonsRefs) db.studentsLessons,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studentsLessonsRefs)
                    await $_getPrefetchedData<
                      Lesson,
                      $LessonsTable,
                      StudentsLesson
                    >(
                      currentTable: table,
                      referencedTable: $$LessonsTableReferences
                          ._studentsLessonsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LessonsTableReferences(
                        db,
                        table,
                        p0,
                      ).studentsLessonsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.lessonId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, $$LessonsTableReferences),
      Lesson,
      PrefetchHooks Function({bool studentsLessonsRefs})
    >;
typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      required String name,
      required double pricing,
      required RatePeriod period,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> pricing,
      Value<RatePeriod> period,
    });

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudentsLessonsTable, List<StudentsLesson>>
  _studentsLessonsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studentsLessons,
    aliasName: $_aliasNameGenerator(
      db.students.id,
      db.studentsLessons.studentId,
    ),
  );

  $$StudentsLessonsTableProcessedTableManager get studentsLessonsRefs {
    final manager = $$StudentsLessonsTableTableManager(
      $_db,
      $_db.studentsLessons,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studentsLessonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoadmapNodesTable, List<RoadmapNode>>
  _roadmapNodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roadmapNodes,
    aliasName: $_aliasNameGenerator(db.students.id, db.roadmapNodes.studentId),
  );

  $$RoadmapNodesTableProcessedTableManager get roadmapNodesRefs {
    final manager = $$RoadmapNodesTableTableManager(
      $_db,
      $_db.roadmapNodes,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roadmapNodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricing => $composableBuilder(
    column: $table.pricing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RatePeriod, RatePeriod, String> get period =>
      $composableBuilder(
        column: $table.period,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> studentsLessonsRefs(
    Expression<bool> Function($$StudentsLessonsTableFilterComposer f) f,
  ) {
    final $$StudentsLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentsLessons,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsLessonsTableFilterComposer(
            $db: $db,
            $table: $db.studentsLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roadmapNodesRefs(
    Expression<bool> Function($$RoadmapNodesTableFilterComposer f) f,
  ) {
    final $$RoadmapNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roadmapNodes,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoadmapNodesTableFilterComposer(
            $db: $db,
            $table: $db.roadmapNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricing => $composableBuilder(
    column: $table.pricing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get pricing =>
      $composableBuilder(column: $table.pricing, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RatePeriod, String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  Expression<T> studentsLessonsRefs<T extends Object>(
    Expression<T> Function($$StudentsLessonsTableAnnotationComposer a) f,
  ) {
    final $$StudentsLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentsLessons,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.studentsLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roadmapNodesRefs<T extends Object>(
    Expression<T> Function($$RoadmapNodesTableAnnotationComposer a) f,
  ) {
    final $$RoadmapNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roadmapNodes,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoadmapNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.roadmapNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, $$StudentsTableReferences),
          Student,
          PrefetchHooks Function({
            bool studentsLessonsRefs,
            bool roadmapNodesRefs,
          })
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> pricing = const Value.absent(),
                Value<RatePeriod> period = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                name: name,
                pricing: pricing,
                period: period,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double pricing,
                required RatePeriod period,
              }) => StudentsCompanion.insert(
                id: id,
                name: name,
                pricing: pricing,
                period: period,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({studentsLessonsRefs = false, roadmapNodesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studentsLessonsRefs) db.studentsLessons,
                    if (roadmapNodesRefs) db.roadmapNodes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studentsLessonsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          StudentsLesson
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._studentsLessonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).studentsLessonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (roadmapNodesRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          RoadmapNode
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._roadmapNodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).roadmapNodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, $$StudentsTableReferences),
      Student,
      PrefetchHooks Function({bool studentsLessonsRefs, bool roadmapNodesRefs})
    >;
typedef $$StudentsLessonsTableCreateCompanionBuilder =
    StudentsLessonsCompanion Function({
      required int studentId,
      required int lessonId,
      Value<int> rowid,
    });
typedef $$StudentsLessonsTableUpdateCompanionBuilder =
    StudentsLessonsCompanion Function({
      Value<int> studentId,
      Value<int> lessonId,
      Value<int> rowid,
    });

final class $$StudentsLessonsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StudentsLessonsTable, StudentsLesson> {
  $$StudentsLessonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias(
        $_aliasNameGenerator(db.studentsLessons.studentId, db.students.id),
      );

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias(
        $_aliasNameGenerator(db.studentsLessons.lessonId, db.lessons.id),
      );

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudentsLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsLessonsTable> {
  $$StudentsLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentsLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsLessonsTable> {
  $$StudentsLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentsLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsLessonsTable> {
  $$StudentsLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentsLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsLessonsTable,
          StudentsLesson,
          $$StudentsLessonsTableFilterComposer,
          $$StudentsLessonsTableOrderingComposer,
          $$StudentsLessonsTableAnnotationComposer,
          $$StudentsLessonsTableCreateCompanionBuilder,
          $$StudentsLessonsTableUpdateCompanionBuilder,
          (StudentsLesson, $$StudentsLessonsTableReferences),
          StudentsLesson,
          PrefetchHooks Function({bool studentId, bool lessonId})
        > {
  $$StudentsLessonsTableTableManager(
    _$AppDatabase db,
    $StudentsLessonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> studentId = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsLessonsCompanion(
                studentId: studentId,
                lessonId: lessonId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int studentId,
                required int lessonId,
                Value<int> rowid = const Value.absent(),
              }) => StudentsLessonsCompanion.insert(
                studentId: studentId,
                lessonId: lessonId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentsLessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false, lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable:
                                    $$StudentsLessonsTableReferences
                                        ._studentIdTable(db),
                                referencedColumn:
                                    $$StudentsLessonsTableReferences
                                        ._studentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable:
                                    $$StudentsLessonsTableReferences
                                        ._lessonIdTable(db),
                                referencedColumn:
                                    $$StudentsLessonsTableReferences
                                        ._lessonIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudentsLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsLessonsTable,
      StudentsLesson,
      $$StudentsLessonsTableFilterComposer,
      $$StudentsLessonsTableOrderingComposer,
      $$StudentsLessonsTableAnnotationComposer,
      $$StudentsLessonsTableCreateCompanionBuilder,
      $$StudentsLessonsTableUpdateCompanionBuilder,
      (StudentsLesson, $$StudentsLessonsTableReferences),
      StudentsLesson,
      PrefetchHooks Function({bool studentId, bool lessonId})
    >;
typedef $$RoadmapNodesTableCreateCompanionBuilder =
    RoadmapNodesCompanion Function({
      Value<int> id,
      required String name,
      required bool isPaid,
      required bool isHomeworkDone,
      required int studentId,
    });
typedef $$RoadmapNodesTableUpdateCompanionBuilder =
    RoadmapNodesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isPaid,
      Value<bool> isHomeworkDone,
      Value<int> studentId,
    });

final class $$RoadmapNodesTableReferences
    extends BaseReferences<_$AppDatabase, $RoadmapNodesTable, RoadmapNode> {
  $$RoadmapNodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias(
        $_aliasNameGenerator(db.roadmapNodes.studentId, db.students.id),
      );

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoadmapNodesTableFilterComposer
    extends Composer<_$AppDatabase, $RoadmapNodesTable> {
  $$RoadmapNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHomeworkDone => $composableBuilder(
    column: $table.isHomeworkDone,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoadmapNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoadmapNodesTable> {
  $$RoadmapNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHomeworkDone => $composableBuilder(
    column: $table.isHomeworkDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoadmapNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoadmapNodesTable> {
  $$RoadmapNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<bool> get isHomeworkDone => $composableBuilder(
    column: $table.isHomeworkDone,
    builder: (column) => column,
  );

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoadmapNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoadmapNodesTable,
          RoadmapNode,
          $$RoadmapNodesTableFilterComposer,
          $$RoadmapNodesTableOrderingComposer,
          $$RoadmapNodesTableAnnotationComposer,
          $$RoadmapNodesTableCreateCompanionBuilder,
          $$RoadmapNodesTableUpdateCompanionBuilder,
          (RoadmapNode, $$RoadmapNodesTableReferences),
          RoadmapNode,
          PrefetchHooks Function({bool studentId})
        > {
  $$RoadmapNodesTableTableManager(_$AppDatabase db, $RoadmapNodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoadmapNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoadmapNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoadmapNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<bool> isHomeworkDone = const Value.absent(),
                Value<int> studentId = const Value.absent(),
              }) => RoadmapNodesCompanion(
                id: id,
                name: name,
                isPaid: isPaid,
                isHomeworkDone: isHomeworkDone,
                studentId: studentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required bool isPaid,
                required bool isHomeworkDone,
                required int studentId,
              }) => RoadmapNodesCompanion.insert(
                id: id,
                name: name,
                isPaid: isPaid,
                isHomeworkDone: isHomeworkDone,
                studentId: studentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoadmapNodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$RoadmapNodesTableReferences
                                    ._studentIdTable(db),
                                referencedColumn: $$RoadmapNodesTableReferences
                                    ._studentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoadmapNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoadmapNodesTable,
      RoadmapNode,
      $$RoadmapNodesTableFilterComposer,
      $$RoadmapNodesTableOrderingComposer,
      $$RoadmapNodesTableAnnotationComposer,
      $$RoadmapNodesTableCreateCompanionBuilder,
      $$RoadmapNodesTableUpdateCompanionBuilder,
      (RoadmapNode, $$RoadmapNodesTableReferences),
      RoadmapNode,
      PrefetchHooks Function({bool studentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$StudentsLessonsTableTableManager get studentsLessons =>
      $$StudentsLessonsTableTableManager(_db, _db.studentsLessons);
  $$RoadmapNodesTableTableManager get roadmapNodes =>
      $$RoadmapNodesTableTableManager(_db, _db.roadmapNodes);
}
