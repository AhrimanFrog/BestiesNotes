// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_provider.dart';

// ignore_for_file: type=lint
class $DbLessonsTable extends DbLessons
    with TableInfo<$DbLessonsTable, DbLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbLessonsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'db_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbLesson> instance, {
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
  DbLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbLesson(
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
  $DbLessonsTable createAlias(String alias) {
    return $DbLessonsTable(attachedDatabase, alias);
  }
}

class DbLesson extends DataClass implements Insertable<DbLesson> {
  final int id;
  final String name;
  final DateTime start;
  final int durationInMinutes;
  const DbLesson({
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

  DbLessonsCompanion toCompanion(bool nullToAbsent) {
    return DbLessonsCompanion(
      id: Value(id),
      name: Value(name),
      start: Value(start),
      durationInMinutes: Value(durationInMinutes),
    );
  }

  factory DbLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbLesson(
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

  DbLesson copyWith({
    int? id,
    String? name,
    DateTime? start,
    int? durationInMinutes,
  }) => DbLesson(
    id: id ?? this.id,
    name: name ?? this.name,
    start: start ?? this.start,
    durationInMinutes: durationInMinutes ?? this.durationInMinutes,
  );
  DbLesson copyWithCompanion(DbLessonsCompanion data) {
    return DbLesson(
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
    return (StringBuffer('DbLesson(')
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
      (other is DbLesson &&
          other.id == this.id &&
          other.name == this.name &&
          other.start == this.start &&
          other.durationInMinutes == this.durationInMinutes);
}

class DbLessonsCompanion extends UpdateCompanion<DbLesson> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> start;
  final Value<int> durationInMinutes;
  const DbLessonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.start = const Value.absent(),
    this.durationInMinutes = const Value.absent(),
  });
  DbLessonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime start,
    required int durationInMinutes,
  }) : name = Value(name),
       start = Value(start),
       durationInMinutes = Value(durationInMinutes);
  static Insertable<DbLesson> custom({
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

  DbLessonsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? start,
    Value<int>? durationInMinutes,
  }) {
    return DbLessonsCompanion(
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
    return (StringBuffer('DbLessonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('start: $start, ')
          ..write('durationInMinutes: $durationInMinutes')
          ..write(')'))
        .toString();
  }
}

class $DbStudentsTable extends DbStudents
    with TableInfo<$DbStudentsTable, DbStudent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbStudentsTable(this.attachedDatabase, [this._alias]);
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
      ).withConverter<RatePeriod>($DbStudentsTable.$converterperiod);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, pricing, period, groupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_students';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbStudent> instance, {
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
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbStudent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbStudent(
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
      period: $DbStudentsTable.$converterperiod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period'],
        )!,
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      ),
    );
  }

  @override
  $DbStudentsTable createAlias(String alias) {
    return $DbStudentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RatePeriod, String, String> $converterperiod =
      const EnumNameConverter<RatePeriod>(RatePeriod.values);
}

class DbStudent extends DataClass implements Insertable<DbStudent> {
  final int id;
  final String name;
  final double pricing;
  final RatePeriod period;
  final int? groupId;
  const DbStudent({
    required this.id,
    required this.name,
    required this.pricing,
    required this.period,
    this.groupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['pricing'] = Variable<double>(pricing);
    {
      map['period'] = Variable<String>(
        $DbStudentsTable.$converterperiod.toSql(period),
      );
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    return map;
  }

  DbStudentsCompanion toCompanion(bool nullToAbsent) {
    return DbStudentsCompanion(
      id: Value(id),
      name: Value(name),
      pricing: Value(pricing),
      period: Value(period),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
    );
  }

  factory DbStudent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbStudent(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pricing: serializer.fromJson<double>(json['pricing']),
      period: $DbStudentsTable.$converterperiod.fromJson(
        serializer.fromJson<String>(json['period']),
      ),
      groupId: serializer.fromJson<int?>(json['groupId']),
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
        $DbStudentsTable.$converterperiod.toJson(period),
      ),
      'groupId': serializer.toJson<int?>(groupId),
    };
  }

  DbStudent copyWith({
    int? id,
    String? name,
    double? pricing,
    RatePeriod? period,
    Value<int?> groupId = const Value.absent(),
  }) => DbStudent(
    id: id ?? this.id,
    name: name ?? this.name,
    pricing: pricing ?? this.pricing,
    period: period ?? this.period,
    groupId: groupId.present ? groupId.value : this.groupId,
  );
  DbStudent copyWithCompanion(DbStudentsCompanion data) {
    return DbStudent(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pricing: data.pricing.present ? data.pricing.value : this.pricing,
      period: data.period.present ? data.period.value : this.period,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbStudent(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pricing: $pricing, ')
          ..write('period: $period, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pricing, period, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbStudent &&
          other.id == this.id &&
          other.name == this.name &&
          other.pricing == this.pricing &&
          other.period == this.period &&
          other.groupId == this.groupId);
}

class DbStudentsCompanion extends UpdateCompanion<DbStudent> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> pricing;
  final Value<RatePeriod> period;
  final Value<int?> groupId;
  const DbStudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pricing = const Value.absent(),
    this.period = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  DbStudentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double pricing,
    required RatePeriod period,
    this.groupId = const Value.absent(),
  }) : name = Value(name),
       pricing = Value(pricing),
       period = Value(period);
  static Insertable<DbStudent> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? pricing,
    Expression<String>? period,
    Expression<int>? groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pricing != null) 'pricing': pricing,
      if (period != null) 'period': period,
      if (groupId != null) 'group_id': groupId,
    });
  }

  DbStudentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? pricing,
    Value<RatePeriod>? period,
    Value<int?>? groupId,
  }) {
    return DbStudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pricing: pricing ?? this.pricing,
      period: period ?? this.period,
      groupId: groupId ?? this.groupId,
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
        $DbStudentsTable.$converterperiod.toSql(period.value),
      );
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbStudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pricing: $pricing, ')
          ..write('period: $period, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }
}

class $DbStudentsLessonsTable extends DbStudentsLessons
    with TableInfo<$DbStudentsLessonsTable, DbStudentsLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbStudentsLessonsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES db_students (id) ON DELETE CASCADE',
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
      'REFERENCES db_lessons (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [studentId, lessonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_students_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbStudentsLesson> instance, {
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
  DbStudentsLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbStudentsLesson(
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
  $DbStudentsLessonsTable createAlias(String alias) {
    return $DbStudentsLessonsTable(attachedDatabase, alias);
  }
}

class DbStudentsLesson extends DataClass
    implements Insertable<DbStudentsLesson> {
  final int studentId;
  final int lessonId;
  const DbStudentsLesson({required this.studentId, required this.lessonId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<int>(studentId);
    map['lesson_id'] = Variable<int>(lessonId);
    return map;
  }

  DbStudentsLessonsCompanion toCompanion(bool nullToAbsent) {
    return DbStudentsLessonsCompanion(
      studentId: Value(studentId),
      lessonId: Value(lessonId),
    );
  }

  factory DbStudentsLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbStudentsLesson(
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

  DbStudentsLesson copyWith({int? studentId, int? lessonId}) =>
      DbStudentsLesson(
        studentId: studentId ?? this.studentId,
        lessonId: lessonId ?? this.lessonId,
      );
  DbStudentsLesson copyWithCompanion(DbStudentsLessonsCompanion data) {
    return DbStudentsLesson(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbStudentsLesson(')
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
      (other is DbStudentsLesson &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId);
}

class DbStudentsLessonsCompanion extends UpdateCompanion<DbStudentsLesson> {
  final Value<int> studentId;
  final Value<int> lessonId;
  final Value<int> rowid;
  const DbStudentsLessonsCompanion({
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbStudentsLessonsCompanion.insert({
    required int studentId,
    required int lessonId,
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       lessonId = Value(lessonId);
  static Insertable<DbStudentsLesson> custom({
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

  DbStudentsLessonsCompanion copyWith({
    Value<int>? studentId,
    Value<int>? lessonId,
    Value<int>? rowid,
  }) {
    return DbStudentsLessonsCompanion(
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
    return (StringBuffer('DbStudentsLessonsCompanion(')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbLessonNotesTable extends DbLessonNotes
    with TableInfo<$DbLessonNotesTable, DbLessonNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbLessonNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
      'REFERENCES db_lessons (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, lessonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_lesson_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbLessonNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbLessonNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbLessonNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
    );
  }

  @override
  $DbLessonNotesTable createAlias(String alias) {
    return $DbLessonNotesTable(attachedDatabase, alias);
  }
}

class DbLessonNote extends DataClass implements Insertable<DbLessonNote> {
  final int id;
  final String content;
  final int lessonId;
  const DbLessonNote({
    required this.id,
    required this.content,
    required this.lessonId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['lesson_id'] = Variable<int>(lessonId);
    return map;
  }

  DbLessonNotesCompanion toCompanion(bool nullToAbsent) {
    return DbLessonNotesCompanion(
      id: Value(id),
      content: Value(content),
      lessonId: Value(lessonId),
    );
  }

  factory DbLessonNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbLessonNote(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'lessonId': serializer.toJson<int>(lessonId),
    };
  }

  DbLessonNote copyWith({int? id, String? content, int? lessonId}) =>
      DbLessonNote(
        id: id ?? this.id,
        content: content ?? this.content,
        lessonId: lessonId ?? this.lessonId,
      );
  DbLessonNote copyWithCompanion(DbLessonNotesCompanion data) {
    return DbLessonNote(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbLessonNote(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, lessonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbLessonNote &&
          other.id == this.id &&
          other.content == this.content &&
          other.lessonId == this.lessonId);
}

class DbLessonNotesCompanion extends UpdateCompanion<DbLessonNote> {
  final Value<int> id;
  final Value<String> content;
  final Value<int> lessonId;
  const DbLessonNotesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.lessonId = const Value.absent(),
  });
  DbLessonNotesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required int lessonId,
  }) : content = Value(content),
       lessonId = Value(lessonId);
  static Insertable<DbLessonNote> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<int>? lessonId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (lessonId != null) 'lesson_id': lessonId,
    });
  }

  DbLessonNotesCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<int>? lessonId,
  }) {
    return DbLessonNotesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      lessonId: lessonId ?? this.lessonId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbLessonNotesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DbLessonsTable dbLessons = $DbLessonsTable(this);
  late final $DbStudentsTable dbStudents = $DbStudentsTable(this);
  late final $DbStudentsLessonsTable dbStudentsLessons =
      $DbStudentsLessonsTable(this);
  late final $DbLessonNotesTable dbLessonNotes = $DbLessonNotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dbLessons,
    dbStudents,
    dbStudentsLessons,
    dbLessonNotes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('db_students_lessons', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('db_students_lessons', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('db_lesson_notes', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DbLessonsTableCreateCompanionBuilder =
    DbLessonsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime start,
      required int durationInMinutes,
    });
typedef $$DbLessonsTableUpdateCompanionBuilder =
    DbLessonsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> start,
      Value<int> durationInMinutes,
    });

final class $$DbLessonsTableReferences
    extends BaseReferences<_$AppDatabase, $DbLessonsTable, DbLesson> {
  $$DbLessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DbStudentsLessonsTable, List<DbStudentsLesson>>
  _dbStudentsLessonsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dbStudentsLessons,
        aliasName: $_aliasNameGenerator(
          db.dbLessons.id,
          db.dbStudentsLessons.lessonId,
        ),
      );

  $$DbStudentsLessonsTableProcessedTableManager get dbStudentsLessonsRefs {
    final manager = $$DbStudentsLessonsTableTableManager(
      $_db,
      $_db.dbStudentsLessons,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dbStudentsLessonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DbLessonNotesTable, List<DbLessonNote>>
  _dbLessonNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dbLessonNotes,
    aliasName: $_aliasNameGenerator(db.dbLessons.id, db.dbLessonNotes.lessonId),
  );

  $$DbLessonNotesTableProcessedTableManager get dbLessonNotesRefs {
    final manager = $$DbLessonNotesTableTableManager(
      $_db,
      $_db.dbLessonNotes,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dbLessonNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DbLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $DbLessonsTable> {
  $$DbLessonsTableFilterComposer({
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

  Expression<bool> dbStudentsLessonsRefs(
    Expression<bool> Function($$DbStudentsLessonsTableFilterComposer f) f,
  ) {
    final $$DbStudentsLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbStudentsLessons,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbStudentsLessonsTableFilterComposer(
            $db: $db,
            $table: $db.dbStudentsLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dbLessonNotesRefs(
    Expression<bool> Function($$DbLessonNotesTableFilterComposer f) f,
  ) {
    final $$DbLessonNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbLessonNotes,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonNotesTableFilterComposer(
            $db: $db,
            $table: $db.dbLessonNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DbLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $DbLessonsTable> {
  $$DbLessonsTableOrderingComposer({
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

class $$DbLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbLessonsTable> {
  $$DbLessonsTableAnnotationComposer({
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

  Expression<T> dbStudentsLessonsRefs<T extends Object>(
    Expression<T> Function($$DbStudentsLessonsTableAnnotationComposer a) f,
  ) {
    final $$DbStudentsLessonsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dbStudentsLessons,
          getReferencedColumn: (t) => t.lessonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DbStudentsLessonsTableAnnotationComposer(
                $db: $db,
                $table: $db.dbStudentsLessons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> dbLessonNotesRefs<T extends Object>(
    Expression<T> Function($$DbLessonNotesTableAnnotationComposer a) f,
  ) {
    final $$DbLessonNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbLessonNotes,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.dbLessonNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DbLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DbLessonsTable,
          DbLesson,
          $$DbLessonsTableFilterComposer,
          $$DbLessonsTableOrderingComposer,
          $$DbLessonsTableAnnotationComposer,
          $$DbLessonsTableCreateCompanionBuilder,
          $$DbLessonsTableUpdateCompanionBuilder,
          (DbLesson, $$DbLessonsTableReferences),
          DbLesson,
          PrefetchHooks Function({
            bool dbStudentsLessonsRefs,
            bool dbLessonNotesRefs,
          })
        > {
  $$DbLessonsTableTableManager(_$AppDatabase db, $DbLessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<int> durationInMinutes = const Value.absent(),
              }) => DbLessonsCompanion(
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
              }) => DbLessonsCompanion.insert(
                id: id,
                name: name,
                start: start,
                durationInMinutes: durationInMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbLessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({dbStudentsLessonsRefs = false, dbLessonNotesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dbStudentsLessonsRefs) db.dbStudentsLessons,
                    if (dbLessonNotesRefs) db.dbLessonNotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dbStudentsLessonsRefs)
                        await $_getPrefetchedData<
                          DbLesson,
                          $DbLessonsTable,
                          DbStudentsLesson
                        >(
                          currentTable: table,
                          referencedTable: $$DbLessonsTableReferences
                              ._dbStudentsLessonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DbLessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).dbStudentsLessonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dbLessonNotesRefs)
                        await $_getPrefetchedData<
                          DbLesson,
                          $DbLessonsTable,
                          DbLessonNote
                        >(
                          currentTable: table,
                          referencedTable: $$DbLessonsTableReferences
                              ._dbLessonNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DbLessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).dbLessonNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
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

typedef $$DbLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DbLessonsTable,
      DbLesson,
      $$DbLessonsTableFilterComposer,
      $$DbLessonsTableOrderingComposer,
      $$DbLessonsTableAnnotationComposer,
      $$DbLessonsTableCreateCompanionBuilder,
      $$DbLessonsTableUpdateCompanionBuilder,
      (DbLesson, $$DbLessonsTableReferences),
      DbLesson,
      PrefetchHooks Function({
        bool dbStudentsLessonsRefs,
        bool dbLessonNotesRefs,
      })
    >;
typedef $$DbStudentsTableCreateCompanionBuilder =
    DbStudentsCompanion Function({
      Value<int> id,
      required String name,
      required double pricing,
      required RatePeriod period,
      Value<int?> groupId,
    });
typedef $$DbStudentsTableUpdateCompanionBuilder =
    DbStudentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> pricing,
      Value<RatePeriod> period,
      Value<int?> groupId,
    });

final class $$DbStudentsTableReferences
    extends BaseReferences<_$AppDatabase, $DbStudentsTable, DbStudent> {
  $$DbStudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DbStudentsLessonsTable, List<DbStudentsLesson>>
  _dbStudentsLessonsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dbStudentsLessons,
        aliasName: $_aliasNameGenerator(
          db.dbStudents.id,
          db.dbStudentsLessons.studentId,
        ),
      );

  $$DbStudentsLessonsTableProcessedTableManager get dbStudentsLessonsRefs {
    final manager = $$DbStudentsLessonsTableTableManager(
      $_db,
      $_db.dbStudentsLessons,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dbStudentsLessonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DbStudentsTableFilterComposer
    extends Composer<_$AppDatabase, $DbStudentsTable> {
  $$DbStudentsTableFilterComposer({
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

  ColumnFilters<int> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dbStudentsLessonsRefs(
    Expression<bool> Function($$DbStudentsLessonsTableFilterComposer f) f,
  ) {
    final $$DbStudentsLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbStudentsLessons,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbStudentsLessonsTableFilterComposer(
            $db: $db,
            $table: $db.dbStudentsLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DbStudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DbStudentsTable> {
  $$DbStudentsTableOrderingComposer({
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

  ColumnOrderings<int> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbStudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbStudentsTable> {
  $$DbStudentsTableAnnotationComposer({
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

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  Expression<T> dbStudentsLessonsRefs<T extends Object>(
    Expression<T> Function($$DbStudentsLessonsTableAnnotationComposer a) f,
  ) {
    final $$DbStudentsLessonsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dbStudentsLessons,
          getReferencedColumn: (t) => t.studentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DbStudentsLessonsTableAnnotationComposer(
                $db: $db,
                $table: $db.dbStudentsLessons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DbStudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DbStudentsTable,
          DbStudent,
          $$DbStudentsTableFilterComposer,
          $$DbStudentsTableOrderingComposer,
          $$DbStudentsTableAnnotationComposer,
          $$DbStudentsTableCreateCompanionBuilder,
          $$DbStudentsTableUpdateCompanionBuilder,
          (DbStudent, $$DbStudentsTableReferences),
          DbStudent,
          PrefetchHooks Function({bool dbStudentsLessonsRefs})
        > {
  $$DbStudentsTableTableManager(_$AppDatabase db, $DbStudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbStudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbStudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbStudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> pricing = const Value.absent(),
                Value<RatePeriod> period = const Value.absent(),
                Value<int?> groupId = const Value.absent(),
              }) => DbStudentsCompanion(
                id: id,
                name: name,
                pricing: pricing,
                period: period,
                groupId: groupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double pricing,
                required RatePeriod period,
                Value<int?> groupId = const Value.absent(),
              }) => DbStudentsCompanion.insert(
                id: id,
                name: name,
                pricing: pricing,
                period: period,
                groupId: groupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbStudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dbStudentsLessonsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dbStudentsLessonsRefs) db.dbStudentsLessons,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dbStudentsLessonsRefs)
                    await $_getPrefetchedData<
                      DbStudent,
                      $DbStudentsTable,
                      DbStudentsLesson
                    >(
                      currentTable: table,
                      referencedTable: $$DbStudentsTableReferences
                          ._dbStudentsLessonsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DbStudentsTableReferences(
                            db,
                            table,
                            p0,
                          ).dbStudentsLessonsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.studentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DbStudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DbStudentsTable,
      DbStudent,
      $$DbStudentsTableFilterComposer,
      $$DbStudentsTableOrderingComposer,
      $$DbStudentsTableAnnotationComposer,
      $$DbStudentsTableCreateCompanionBuilder,
      $$DbStudentsTableUpdateCompanionBuilder,
      (DbStudent, $$DbStudentsTableReferences),
      DbStudent,
      PrefetchHooks Function({bool dbStudentsLessonsRefs})
    >;
typedef $$DbStudentsLessonsTableCreateCompanionBuilder =
    DbStudentsLessonsCompanion Function({
      required int studentId,
      required int lessonId,
      Value<int> rowid,
    });
typedef $$DbStudentsLessonsTableUpdateCompanionBuilder =
    DbStudentsLessonsCompanion Function({
      Value<int> studentId,
      Value<int> lessonId,
      Value<int> rowid,
    });

final class $$DbStudentsLessonsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DbStudentsLessonsTable,
          DbStudentsLesson
        > {
  $$DbStudentsLessonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DbStudentsTable _studentIdTable(_$AppDatabase db) =>
      db.dbStudents.createAlias(
        $_aliasNameGenerator(db.dbStudentsLessons.studentId, db.dbStudents.id),
      );

  $$DbStudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$DbStudentsTableTableManager(
      $_db,
      $_db.dbStudents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DbLessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.dbLessons.createAlias(
        $_aliasNameGenerator(db.dbStudentsLessons.lessonId, db.dbLessons.id),
      );

  $$DbLessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$DbLessonsTableTableManager(
      $_db,
      $_db.dbLessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DbStudentsLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $DbStudentsLessonsTable> {
  $$DbStudentsLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DbStudentsTableFilterComposer get studentId {
    final $$DbStudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.dbStudents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbStudentsTableFilterComposer(
            $db: $db,
            $table: $db.dbStudents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DbLessonsTableFilterComposer get lessonId {
    final $$DbLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.dbLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonsTableFilterComposer(
            $db: $db,
            $table: $db.dbLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbStudentsLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $DbStudentsLessonsTable> {
  $$DbStudentsLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DbStudentsTableOrderingComposer get studentId {
    final $$DbStudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.dbStudents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbStudentsTableOrderingComposer(
            $db: $db,
            $table: $db.dbStudents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DbLessonsTableOrderingComposer get lessonId {
    final $$DbLessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.dbLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonsTableOrderingComposer(
            $db: $db,
            $table: $db.dbLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbStudentsLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbStudentsLessonsTable> {
  $$DbStudentsLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DbStudentsTableAnnotationComposer get studentId {
    final $$DbStudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.dbStudents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbStudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.dbStudents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DbLessonsTableAnnotationComposer get lessonId {
    final $$DbLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.dbLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.dbLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbStudentsLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DbStudentsLessonsTable,
          DbStudentsLesson,
          $$DbStudentsLessonsTableFilterComposer,
          $$DbStudentsLessonsTableOrderingComposer,
          $$DbStudentsLessonsTableAnnotationComposer,
          $$DbStudentsLessonsTableCreateCompanionBuilder,
          $$DbStudentsLessonsTableUpdateCompanionBuilder,
          (DbStudentsLesson, $$DbStudentsLessonsTableReferences),
          DbStudentsLesson,
          PrefetchHooks Function({bool studentId, bool lessonId})
        > {
  $$DbStudentsLessonsTableTableManager(
    _$AppDatabase db,
    $DbStudentsLessonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbStudentsLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbStudentsLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbStudentsLessonsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> studentId = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbStudentsLessonsCompanion(
                studentId: studentId,
                lessonId: lessonId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int studentId,
                required int lessonId,
                Value<int> rowid = const Value.absent(),
              }) => DbStudentsLessonsCompanion.insert(
                studentId: studentId,
                lessonId: lessonId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbStudentsLessonsTableReferences(db, table, e),
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
                                    $$DbStudentsLessonsTableReferences
                                        ._studentIdTable(db),
                                referencedColumn:
                                    $$DbStudentsLessonsTableReferences
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
                                    $$DbStudentsLessonsTableReferences
                                        ._lessonIdTable(db),
                                referencedColumn:
                                    $$DbStudentsLessonsTableReferences
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

typedef $$DbStudentsLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DbStudentsLessonsTable,
      DbStudentsLesson,
      $$DbStudentsLessonsTableFilterComposer,
      $$DbStudentsLessonsTableOrderingComposer,
      $$DbStudentsLessonsTableAnnotationComposer,
      $$DbStudentsLessonsTableCreateCompanionBuilder,
      $$DbStudentsLessonsTableUpdateCompanionBuilder,
      (DbStudentsLesson, $$DbStudentsLessonsTableReferences),
      DbStudentsLesson,
      PrefetchHooks Function({bool studentId, bool lessonId})
    >;
typedef $$DbLessonNotesTableCreateCompanionBuilder =
    DbLessonNotesCompanion Function({
      Value<int> id,
      required String content,
      required int lessonId,
    });
typedef $$DbLessonNotesTableUpdateCompanionBuilder =
    DbLessonNotesCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<int> lessonId,
    });

final class $$DbLessonNotesTableReferences
    extends BaseReferences<_$AppDatabase, $DbLessonNotesTable, DbLessonNote> {
  $$DbLessonNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DbLessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.dbLessons.createAlias(
        $_aliasNameGenerator(db.dbLessonNotes.lessonId, db.dbLessons.id),
      );

  $$DbLessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$DbLessonsTableTableManager(
      $_db,
      $_db.dbLessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DbLessonNotesTableFilterComposer
    extends Composer<_$AppDatabase, $DbLessonNotesTable> {
  $$DbLessonNotesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  $$DbLessonsTableFilterComposer get lessonId {
    final $$DbLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.dbLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonsTableFilterComposer(
            $db: $db,
            $table: $db.dbLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbLessonNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $DbLessonNotesTable> {
  $$DbLessonNotesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  $$DbLessonsTableOrderingComposer get lessonId {
    final $$DbLessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.dbLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonsTableOrderingComposer(
            $db: $db,
            $table: $db.dbLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbLessonNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbLessonNotesTable> {
  $$DbLessonNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$DbLessonsTableAnnotationComposer get lessonId {
    final $$DbLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.dbLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.dbLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbLessonNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DbLessonNotesTable,
          DbLessonNote,
          $$DbLessonNotesTableFilterComposer,
          $$DbLessonNotesTableOrderingComposer,
          $$DbLessonNotesTableAnnotationComposer,
          $$DbLessonNotesTableCreateCompanionBuilder,
          $$DbLessonNotesTableUpdateCompanionBuilder,
          (DbLessonNote, $$DbLessonNotesTableReferences),
          DbLessonNote,
          PrefetchHooks Function({bool lessonId})
        > {
  $$DbLessonNotesTableTableManager(_$AppDatabase db, $DbLessonNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbLessonNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbLessonNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbLessonNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
              }) => DbLessonNotesCompanion(
                id: id,
                content: content,
                lessonId: lessonId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                required int lessonId,
              }) => DbLessonNotesCompanion.insert(
                id: id,
                content: content,
                lessonId: lessonId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbLessonNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
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
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$DbLessonNotesTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn: $$DbLessonNotesTableReferences
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

typedef $$DbLessonNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DbLessonNotesTable,
      DbLessonNote,
      $$DbLessonNotesTableFilterComposer,
      $$DbLessonNotesTableOrderingComposer,
      $$DbLessonNotesTableAnnotationComposer,
      $$DbLessonNotesTableCreateCompanionBuilder,
      $$DbLessonNotesTableUpdateCompanionBuilder,
      (DbLessonNote, $$DbLessonNotesTableReferences),
      DbLessonNote,
      PrefetchHooks Function({bool lessonId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DbLessonsTableTableManager get dbLessons =>
      $$DbLessonsTableTableManager(_db, _db.dbLessons);
  $$DbStudentsTableTableManager get dbStudents =>
      $$DbStudentsTableTableManager(_db, _db.dbStudents);
  $$DbStudentsLessonsTableTableManager get dbStudentsLessons =>
      $$DbStudentsLessonsTableTableManager(_db, _db.dbStudentsLessons);
  $$DbLessonNotesTableTableManager get dbLessonNotes =>
      $$DbLessonNotesTableTableManager(_db, _db.dbLessonNotes);
}
