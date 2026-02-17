// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_client.dart';

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
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LessonStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LessonStatus>($DbLessonsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topic,
    start,
    durationInMinutes,
    note,
    status,
    createdAt,
    updatedAt,
  ];
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
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
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
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      durationInMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_in_minutes'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: $DbLessonsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DbLessonsTable createAlias(String alias) {
    return $DbLessonsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LessonStatus, String, String> $converterstatus =
      const EnumNameConverter<LessonStatus>(LessonStatus.values);
}

class DbLesson extends DataClass implements Insertable<DbLesson> {
  final int id;
  final String topic;
  final DateTime start;
  final int durationInMinutes;
  final String? note;
  final LessonStatus status;
  final int createdAt;
  final int updatedAt;
  const DbLesson({
    required this.id,
    required this.topic,
    required this.start,
    required this.durationInMinutes,
    this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['topic'] = Variable<String>(topic);
    map['start'] = Variable<DateTime>(start);
    map['duration_in_minutes'] = Variable<int>(durationInMinutes);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['status'] = Variable<String>(
        $DbLessonsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DbLessonsCompanion toCompanion(bool nullToAbsent) {
    return DbLessonsCompanion(
      id: Value(id),
      topic: Value(topic),
      start: Value(start),
      durationInMinutes: Value(durationInMinutes),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbLesson(
      id: serializer.fromJson<int>(json['id']),
      topic: serializer.fromJson<String>(json['topic']),
      start: serializer.fromJson<DateTime>(json['start']),
      durationInMinutes: serializer.fromJson<int>(json['durationInMinutes']),
      note: serializer.fromJson<String?>(json['note']),
      status: $DbLessonsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'topic': serializer.toJson<String>(topic),
      'start': serializer.toJson<DateTime>(start),
      'durationInMinutes': serializer.toJson<int>(durationInMinutes),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(
        $DbLessonsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DbLesson copyWith({
    int? id,
    String? topic,
    DateTime? start,
    int? durationInMinutes,
    Value<String?> note = const Value.absent(),
    LessonStatus? status,
    int? createdAt,
    int? updatedAt,
  }) => DbLesson(
    id: id ?? this.id,
    topic: topic ?? this.topic,
    start: start ?? this.start,
    durationInMinutes: durationInMinutes ?? this.durationInMinutes,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbLesson copyWithCompanion(DbLessonsCompanion data) {
    return DbLesson(
      id: data.id.present ? data.id.value : this.id,
      topic: data.topic.present ? data.topic.value : this.topic,
      start: data.start.present ? data.start.value : this.start,
      durationInMinutes: data.durationInMinutes.present
          ? data.durationInMinutes.value
          : this.durationInMinutes,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbLesson(')
          ..write('id: $id, ')
          ..write('topic: $topic, ')
          ..write('start: $start, ')
          ..write('durationInMinutes: $durationInMinutes, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    topic,
    start,
    durationInMinutes,
    note,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbLesson &&
          other.id == this.id &&
          other.topic == this.topic &&
          other.start == this.start &&
          other.durationInMinutes == this.durationInMinutes &&
          other.note == this.note &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DbLessonsCompanion extends UpdateCompanion<DbLesson> {
  final Value<int> id;
  final Value<String> topic;
  final Value<DateTime> start;
  final Value<int> durationInMinutes;
  final Value<String?> note;
  final Value<LessonStatus> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DbLessonsCompanion({
    this.id = const Value.absent(),
    this.topic = const Value.absent(),
    this.start = const Value.absent(),
    this.durationInMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DbLessonsCompanion.insert({
    this.id = const Value.absent(),
    required String topic,
    required DateTime start,
    required int durationInMinutes,
    this.note = const Value.absent(),
    required LessonStatus status,
    required int createdAt,
    required int updatedAt,
  }) : topic = Value(topic),
       start = Value(start),
       durationInMinutes = Value(durationInMinutes),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DbLesson> custom({
    Expression<int>? id,
    Expression<String>? topic,
    Expression<DateTime>? start,
    Expression<int>? durationInMinutes,
    Expression<String>? note,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topic != null) 'topic': topic,
      if (start != null) 'start': start,
      if (durationInMinutes != null) 'duration_in_minutes': durationInMinutes,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DbLessonsCompanion copyWith({
    Value<int>? id,
    Value<String>? topic,
    Value<DateTime>? start,
    Value<int>? durationInMinutes,
    Value<String?>? note,
    Value<LessonStatus>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DbLessonsCompanion(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      start: start ?? this.start,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (durationInMinutes.present) {
      map['duration_in_minutes'] = Variable<int>(durationInMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DbLessonsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbLessonsCompanion(')
          ..write('id: $id, ')
          ..write('topic: $topic, ')
          ..write('start: $start, ')
          ..write('durationInMinutes: $durationInMinutes, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payRateMeta = const VerificationMeta(
    'payRate',
  );
  @override
  late final GeneratedColumn<double> payRate = GeneratedColumn<double>(
    'pay_rate',
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    contact,
    email,
    avatarPath,
    payRate,
    period,
    notes,
    createdAt,
    updatedAt,
  ];
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
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    } else if (isInserting) {
      context.missing(_contactMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('pay_rate')) {
      context.handle(
        _payRateMeta,
        payRate.isAcceptableOrUnknown(data['pay_rate']!, _payRateMeta),
      );
    } else if (isInserting) {
      context.missing(_payRateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      payRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pay_rate'],
      )!,
      period: $DbStudentsTable.$converterperiod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final String contact;
  final String? email;
  final String? avatarPath;
  final double payRate;
  final RatePeriod period;
  final String notes;
  final int createdAt;
  final int updatedAt;
  const DbStudent({
    required this.id,
    required this.name,
    required this.contact,
    this.email,
    this.avatarPath,
    required this.payRate,
    required this.period,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['contact'] = Variable<String>(contact);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['pay_rate'] = Variable<double>(payRate);
    {
      map['period'] = Variable<String>(
        $DbStudentsTable.$converterperiod.toSql(period),
      );
    }
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DbStudentsCompanion toCompanion(bool nullToAbsent) {
    return DbStudentsCompanion(
      id: Value(id),
      name: Value(name),
      contact: Value(contact),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      payRate: Value(payRate),
      period: Value(period),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      contact: serializer.fromJson<String>(json['contact']),
      email: serializer.fromJson<String?>(json['email']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      payRate: serializer.fromJson<double>(json['payRate']),
      period: $DbStudentsTable.$converterperiod.fromJson(
        serializer.fromJson<String>(json['period']),
      ),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'contact': serializer.toJson<String>(contact),
      'email': serializer.toJson<String?>(email),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'payRate': serializer.toJson<double>(payRate),
      'period': serializer.toJson<String>(
        $DbStudentsTable.$converterperiod.toJson(period),
      ),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DbStudent copyWith({
    int? id,
    String? name,
    String? contact,
    Value<String?> email = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
    double? payRate,
    RatePeriod? period,
    String? notes,
    int? createdAt,
    int? updatedAt,
  }) => DbStudent(
    id: id ?? this.id,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    email: email.present ? email.value : this.email,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    payRate: payRate ?? this.payRate,
    period: period ?? this.period,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbStudent copyWithCompanion(DbStudentsCompanion data) {
    return DbStudent(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contact: data.contact.present ? data.contact.value : this.contact,
      email: data.email.present ? data.email.value : this.email,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      payRate: data.payRate.present ? data.payRate.value : this.payRate,
      period: data.period.present ? data.period.value : this.period,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbStudent(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('email: $email, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('payRate: $payRate, ')
          ..write('period: $period, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    contact,
    email,
    avatarPath,
    payRate,
    period,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbStudent &&
          other.id == this.id &&
          other.name == this.name &&
          other.contact == this.contact &&
          other.email == this.email &&
          other.avatarPath == this.avatarPath &&
          other.payRate == this.payRate &&
          other.period == this.period &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DbStudentsCompanion extends UpdateCompanion<DbStudent> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> contact;
  final Value<String?> email;
  final Value<String?> avatarPath;
  final Value<double> payRate;
  final Value<RatePeriod> period;
  final Value<String> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DbStudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contact = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.payRate = const Value.absent(),
    this.period = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DbStudentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String contact,
    this.email = const Value.absent(),
    this.avatarPath = const Value.absent(),
    required double payRate,
    required RatePeriod period,
    required String notes,
    required int createdAt,
    required int updatedAt,
  }) : name = Value(name),
       contact = Value(contact),
       payRate = Value(payRate),
       period = Value(period),
       notes = Value(notes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DbStudent> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? contact,
    Expression<String>? email,
    Expression<String>? avatarPath,
    Expression<double>? payRate,
    Expression<String>? period,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contact != null) 'contact': contact,
      if (email != null) 'email': email,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (payRate != null) 'pay_rate': payRate,
      if (period != null) 'period': period,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DbStudentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? contact,
    Value<String?>? email,
    Value<String?>? avatarPath,
    Value<double>? payRate,
    Value<RatePeriod>? period,
    Value<String>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DbStudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      payRate: payRate ?? this.payRate,
      period: period ?? this.period,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (payRate.present) {
      map['pay_rate'] = Variable<double>(payRate.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(
        $DbStudentsTable.$converterperiod.toSql(period.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbStudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('email: $email, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('payRate: $payRate, ')
          ..write('period: $period, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DbGroupsTable extends DbGroups with TableInfo<$DbGroupsTable, DbGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbGroupsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payRateMeta = const VerificationMeta(
    'payRate',
  );
  @override
  late final GeneratedColumn<double> payRate = GeneratedColumn<double>(
    'pay_rate',
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
      ).withConverter<RatePeriod>($DbGroupsTable.$converterperiod);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    avatarPath,
    payRate,
    period,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbGroup> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('pay_rate')) {
      context.handle(
        _payRateMeta,
        payRate.isAcceptableOrUnknown(data['pay_rate']!, _payRateMeta),
      );
    } else if (isInserting) {
      context.missing(_payRateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      payRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pay_rate'],
      )!,
      period: $DbGroupsTable.$converterperiod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DbGroupsTable createAlias(String alias) {
    return $DbGroupsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RatePeriod, String, String> $converterperiod =
      const EnumNameConverter<RatePeriod>(RatePeriod.values);
}

class DbGroup extends DataClass implements Insertable<DbGroup> {
  final int id;
  final String name;
  final String? description;
  final String? avatarPath;
  final double payRate;
  final RatePeriod period;
  final int createdAt;
  final int updatedAt;
  const DbGroup({
    required this.id,
    required this.name,
    this.description,
    this.avatarPath,
    required this.payRate,
    required this.period,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['pay_rate'] = Variable<double>(payRate);
    {
      map['period'] = Variable<String>(
        $DbGroupsTable.$converterperiod.toSql(period),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DbGroupsCompanion toCompanion(bool nullToAbsent) {
    return DbGroupsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      payRate: Value(payRate),
      period: Value(period),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      payRate: serializer.fromJson<double>(json['payRate']),
      period: $DbGroupsTable.$converterperiod.fromJson(
        serializer.fromJson<String>(json['period']),
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'payRate': serializer.toJson<double>(payRate),
      'period': serializer.toJson<String>(
        $DbGroupsTable.$converterperiod.toJson(period),
      ),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DbGroup copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
    double? payRate,
    RatePeriod? period,
    int? createdAt,
    int? updatedAt,
  }) => DbGroup(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    payRate: payRate ?? this.payRate,
    period: period ?? this.period,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbGroup copyWithCompanion(DbGroupsCompanion data) {
    return DbGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      payRate: data.payRate.present ? data.payRate.value : this.payRate,
      period: data.period.present ? data.period.value : this.period,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('payRate: $payRate, ')
          ..write('period: $period, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    avatarPath,
    payRate,
    period,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.avatarPath == this.avatarPath &&
          other.payRate == this.payRate &&
          other.period == this.period &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DbGroupsCompanion extends UpdateCompanion<DbGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> avatarPath;
  final Value<double> payRate;
  final Value<RatePeriod> period;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DbGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.payRate = const Value.absent(),
    this.period = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DbGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.avatarPath = const Value.absent(),
    required double payRate,
    required RatePeriod period,
    required int createdAt,
    required int updatedAt,
  }) : name = Value(name),
       payRate = Value(payRate),
       period = Value(period),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DbGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? avatarPath,
    Expression<double>? payRate,
    Expression<String>? period,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (payRate != null) 'pay_rate': payRate,
      if (period != null) 'period': period,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DbGroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? avatarPath,
    Value<double>? payRate,
    Value<RatePeriod>? period,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DbGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarPath: avatarPath ?? this.avatarPath,
      payRate: payRate ?? this.payRate,
      period: period ?? this.period,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (payRate.present) {
      map['pay_rate'] = Variable<double>(payRate.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(
        $DbGroupsTable.$converterperiod.toSql(period.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('payRate: $payRate, ')
          ..write('period: $period, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GroupMembershipsTable extends GroupMemberships
    with TableInfo<$GroupMembershipsTable, GroupMembership> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembershipsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES db_groups (id) ON DELETE CASCADE',
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
      'REFERENCES db_students (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, studentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_memberships';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMembership> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, studentId},
  ];
  @override
  GroupMembership map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMembership(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
    );
  }

  @override
  $GroupMembershipsTable createAlias(String alias) {
    return $GroupMembershipsTable(attachedDatabase, alias);
  }
}

class GroupMembership extends DataClass implements Insertable<GroupMembership> {
  final int id;
  final int groupId;
  final int studentId;
  const GroupMembership({
    required this.id,
    required this.groupId,
    required this.studentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['student_id'] = Variable<int>(studentId);
    return map;
  }

  GroupMembershipsCompanion toCompanion(bool nullToAbsent) {
    return GroupMembershipsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      studentId: Value(studentId),
    );
  }

  factory GroupMembership.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMembership(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      studentId: serializer.fromJson<int>(json['studentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'studentId': serializer.toJson<int>(studentId),
    };
  }

  GroupMembership copyWith({int? id, int? groupId, int? studentId}) =>
      GroupMembership(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        studentId: studentId ?? this.studentId,
      );
  GroupMembership copyWithCompanion(GroupMembershipsCompanion data) {
    return GroupMembership(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembership(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('studentId: $studentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, studentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMembership &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.studentId == this.studentId);
}

class GroupMembershipsCompanion extends UpdateCompanion<GroupMembership> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> studentId;
  const GroupMembershipsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.studentId = const Value.absent(),
  });
  GroupMembershipsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int studentId,
  }) : groupId = Value(groupId),
       studentId = Value(studentId);
  static Insertable<GroupMembership> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? studentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (studentId != null) 'student_id': studentId,
    });
  }

  GroupMembershipsCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? studentId,
  }) {
    return GroupMembershipsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      studentId: studentId ?? this.studentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembershipsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('studentId: $studentId')
          ..write(')'))
        .toString();
  }
}

class $DbLessonParticipantsTable extends DbLessonParticipants
    with TableInfo<$DbLessonParticipantsTable, DbLessonParticipant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbLessonParticipantsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _attendedMeta = const VerificationMeta(
    'attended',
  );
  @override
  late final GeneratedColumn<bool> attended = GeneratedColumn<bool>(
    'attended',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("attended" IN (0, 1))',
    ),
  );
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES db_groups (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    studentId,
    isPaid,
    attended,
    groupId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_lesson_participants';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbLessonParticipant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    } else if (isInserting) {
      context.missing(_isPaidMeta);
    }
    if (data.containsKey('attended')) {
      context.handle(
        _attendedMeta,
        attended.isAcceptableOrUnknown(data['attended']!, _attendedMeta),
      );
    } else if (isInserting) {
      context.missing(_attendedMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {lessonId, studentId},
  ];
  @override
  DbLessonParticipant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbLessonParticipant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      attended: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}attended'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      ),
    );
  }

  @override
  $DbLessonParticipantsTable createAlias(String alias) {
    return $DbLessonParticipantsTable(attachedDatabase, alias);
  }
}

class DbLessonParticipant extends DataClass
    implements Insertable<DbLessonParticipant> {
  final int id;
  final int lessonId;
  final int studentId;
  final bool isPaid;
  final bool attended;
  final int? groupId;
  const DbLessonParticipant({
    required this.id,
    required this.lessonId,
    required this.studentId,
    required this.isPaid,
    required this.attended,
    this.groupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['student_id'] = Variable<int>(studentId);
    map['is_paid'] = Variable<bool>(isPaid);
    map['attended'] = Variable<bool>(attended);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    return map;
  }

  DbLessonParticipantsCompanion toCompanion(bool nullToAbsent) {
    return DbLessonParticipantsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      studentId: Value(studentId),
      isPaid: Value(isPaid),
      attended: Value(attended),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
    );
  }

  factory DbLessonParticipant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbLessonParticipant(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      studentId: serializer.fromJson<int>(json['studentId']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      attended: serializer.fromJson<bool>(json['attended']),
      groupId: serializer.fromJson<int?>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'studentId': serializer.toJson<int>(studentId),
      'isPaid': serializer.toJson<bool>(isPaid),
      'attended': serializer.toJson<bool>(attended),
      'groupId': serializer.toJson<int?>(groupId),
    };
  }

  DbLessonParticipant copyWith({
    int? id,
    int? lessonId,
    int? studentId,
    bool? isPaid,
    bool? attended,
    Value<int?> groupId = const Value.absent(),
  }) => DbLessonParticipant(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    studentId: studentId ?? this.studentId,
    isPaid: isPaid ?? this.isPaid,
    attended: attended ?? this.attended,
    groupId: groupId.present ? groupId.value : this.groupId,
  );
  DbLessonParticipant copyWithCompanion(DbLessonParticipantsCompanion data) {
    return DbLessonParticipant(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      attended: data.attended.present ? data.attended.value : this.attended,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbLessonParticipant(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('studentId: $studentId, ')
          ..write('isPaid: $isPaid, ')
          ..write('attended: $attended, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lessonId, studentId, isPaid, attended, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbLessonParticipant &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.studentId == this.studentId &&
          other.isPaid == this.isPaid &&
          other.attended == this.attended &&
          other.groupId == this.groupId);
}

class DbLessonParticipantsCompanion
    extends UpdateCompanion<DbLessonParticipant> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<int> studentId;
  final Value<bool> isPaid;
  final Value<bool> attended;
  final Value<int?> groupId;
  const DbLessonParticipantsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.attended = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  DbLessonParticipantsCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    required int studentId,
    required bool isPaid,
    required bool attended,
    this.groupId = const Value.absent(),
  }) : lessonId = Value(lessonId),
       studentId = Value(studentId),
       isPaid = Value(isPaid),
       attended = Value(attended);
  static Insertable<DbLessonParticipant> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<int>? studentId,
    Expression<bool>? isPaid,
    Expression<bool>? attended,
    Expression<int>? groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (studentId != null) 'student_id': studentId,
      if (isPaid != null) 'is_paid': isPaid,
      if (attended != null) 'attended': attended,
      if (groupId != null) 'group_id': groupId,
    });
  }

  DbLessonParticipantsCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<int>? studentId,
    Value<bool>? isPaid,
    Value<bool>? attended,
    Value<int?>? groupId,
  }) {
    return DbLessonParticipantsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      studentId: studentId ?? this.studentId,
      isPaid: isPaid ?? this.isPaid,
      attended: attended ?? this.attended,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (attended.present) {
      map['attended'] = Variable<bool>(attended.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbLessonParticipantsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('studentId: $studentId, ')
          ..write('isPaid: $isPaid, ')
          ..write('attended: $attended, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }
}

abstract class _$DbClient extends GeneratedDatabase {
  _$DbClient(QueryExecutor e) : super(e);
  $DbClientManager get managers => $DbClientManager(this);
  late final $DbLessonsTable dbLessons = $DbLessonsTable(this);
  late final $DbStudentsTable dbStudents = $DbStudentsTable(this);
  late final $DbGroupsTable dbGroups = $DbGroupsTable(this);
  late final $GroupMembershipsTable groupMemberships = $GroupMembershipsTable(
    this,
  );
  late final $DbLessonParticipantsTable dbLessonParticipants =
      $DbLessonParticipantsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dbLessons,
    dbStudents,
    dbGroups,
    groupMemberships,
    dbLessonParticipants,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_memberships', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_memberships', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('db_lesson_participants', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'db_students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('db_lesson_participants', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DbLessonsTableCreateCompanionBuilder =
    DbLessonsCompanion Function({
      Value<int> id,
      required String topic,
      required DateTime start,
      required int durationInMinutes,
      Value<String?> note,
      required LessonStatus status,
      required int createdAt,
      required int updatedAt,
    });
typedef $$DbLessonsTableUpdateCompanionBuilder =
    DbLessonsCompanion Function({
      Value<int> id,
      Value<String> topic,
      Value<DateTime> start,
      Value<int> durationInMinutes,
      Value<String?> note,
      Value<LessonStatus> status,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

final class $$DbLessonsTableReferences
    extends BaseReferences<_$DbClient, $DbLessonsTable, DbLesson> {
  $$DbLessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $DbLessonParticipantsTable,
    List<DbLessonParticipant>
  >
  _dbLessonParticipantsRefsTable(_$DbClient db) =>
      MultiTypedResultKey.fromTable(
        db.dbLessonParticipants,
        aliasName: $_aliasNameGenerator(
          db.dbLessons.id,
          db.dbLessonParticipants.lessonId,
        ),
      );

  $$DbLessonParticipantsTableProcessedTableManager
  get dbLessonParticipantsRefs {
    final manager = $$DbLessonParticipantsTableTableManager(
      $_db,
      $_db.dbLessonParticipants,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dbLessonParticipantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DbLessonsTableFilterComposer
    extends Composer<_$DbClient, $DbLessonsTable> {
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

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LessonStatus, LessonStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dbLessonParticipantsRefs(
    Expression<bool> Function($$DbLessonParticipantsTableFilterComposer f) f,
  ) {
    final $$DbLessonParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbLessonParticipants,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.dbLessonParticipants,
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
    extends Composer<_$DbClient, $DbLessonsTable> {
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

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbLessonsTableAnnotationComposer
    extends Composer<_$DbClient, $DbLessonsTable> {
  $$DbLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LessonStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dbLessonParticipantsRefs<T extends Object>(
    Expression<T> Function($$DbLessonParticipantsTableAnnotationComposer a) f,
  ) {
    final $$DbLessonParticipantsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dbLessonParticipants,
          getReferencedColumn: (t) => t.lessonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DbLessonParticipantsTableAnnotationComposer(
                $db: $db,
                $table: $db.dbLessonParticipants,
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
          _$DbClient,
          $DbLessonsTable,
          DbLesson,
          $$DbLessonsTableFilterComposer,
          $$DbLessonsTableOrderingComposer,
          $$DbLessonsTableAnnotationComposer,
          $$DbLessonsTableCreateCompanionBuilder,
          $$DbLessonsTableUpdateCompanionBuilder,
          (DbLesson, $$DbLessonsTableReferences),
          DbLesson,
          PrefetchHooks Function({bool dbLessonParticipantsRefs})
        > {
  $$DbLessonsTableTableManager(_$DbClient db, $DbLessonsTable table)
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
                Value<String> topic = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<int> durationInMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<LessonStatus> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => DbLessonsCompanion(
                id: id,
                topic: topic,
                start: start,
                durationInMinutes: durationInMinutes,
                note: note,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String topic,
                required DateTime start,
                required int durationInMinutes,
                Value<String?> note = const Value.absent(),
                required LessonStatus status,
                required int createdAt,
                required int updatedAt,
              }) => DbLessonsCompanion.insert(
                id: id,
                topic: topic,
                start: start,
                durationInMinutes: durationInMinutes,
                note: note,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbLessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dbLessonParticipantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dbLessonParticipantsRefs) db.dbLessonParticipants,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dbLessonParticipantsRefs)
                    await $_getPrefetchedData<
                      DbLesson,
                      $DbLessonsTable,
                      DbLessonParticipant
                    >(
                      currentTable: table,
                      referencedTable: $$DbLessonsTableReferences
                          ._dbLessonParticipantsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DbLessonsTableReferences(
                            db,
                            table,
                            p0,
                          ).dbLessonParticipantsRefs,
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

typedef $$DbLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $DbLessonsTable,
      DbLesson,
      $$DbLessonsTableFilterComposer,
      $$DbLessonsTableOrderingComposer,
      $$DbLessonsTableAnnotationComposer,
      $$DbLessonsTableCreateCompanionBuilder,
      $$DbLessonsTableUpdateCompanionBuilder,
      (DbLesson, $$DbLessonsTableReferences),
      DbLesson,
      PrefetchHooks Function({bool dbLessonParticipantsRefs})
    >;
typedef $$DbStudentsTableCreateCompanionBuilder =
    DbStudentsCompanion Function({
      Value<int> id,
      required String name,
      required String contact,
      Value<String?> email,
      Value<String?> avatarPath,
      required double payRate,
      required RatePeriod period,
      required String notes,
      required int createdAt,
      required int updatedAt,
    });
typedef $$DbStudentsTableUpdateCompanionBuilder =
    DbStudentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> contact,
      Value<String?> email,
      Value<String?> avatarPath,
      Value<double> payRate,
      Value<RatePeriod> period,
      Value<String> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

final class $$DbStudentsTableReferences
    extends BaseReferences<_$DbClient, $DbStudentsTable, DbStudent> {
  $$DbStudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupMembershipsTable, List<GroupMembership>>
  _groupMembershipsRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.groupMemberships,
    aliasName: $_aliasNameGenerator(
      db.dbStudents.id,
      db.groupMemberships.studentId,
    ),
  );

  $$GroupMembershipsTableProcessedTableManager get groupMembershipsRefs {
    final manager = $$GroupMembershipsTableTableManager(
      $_db,
      $_db.groupMemberships,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupMembershipsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DbLessonParticipantsTable,
    List<DbLessonParticipant>
  >
  _dbLessonParticipantsRefsTable(_$DbClient db) =>
      MultiTypedResultKey.fromTable(
        db.dbLessonParticipants,
        aliasName: $_aliasNameGenerator(
          db.dbStudents.id,
          db.dbLessonParticipants.studentId,
        ),
      );

  $$DbLessonParticipantsTableProcessedTableManager
  get dbLessonParticipantsRefs {
    final manager = $$DbLessonParticipantsTableTableManager(
      $_db,
      $_db.dbLessonParticipants,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dbLessonParticipantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DbStudentsTableFilterComposer
    extends Composer<_$DbClient, $DbStudentsTable> {
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

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payRate => $composableBuilder(
    column: $table.payRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RatePeriod, RatePeriod, String> get period =>
      $composableBuilder(
        column: $table.period,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupMembershipsRefs(
    Expression<bool> Function($$GroupMembershipsTableFilterComposer f) f,
  ) {
    final $$GroupMembershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMemberships,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembershipsTableFilterComposer(
            $db: $db,
            $table: $db.groupMemberships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dbLessonParticipantsRefs(
    Expression<bool> Function($$DbLessonParticipantsTableFilterComposer f) f,
  ) {
    final $$DbLessonParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbLessonParticipants,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.dbLessonParticipants,
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
    extends Composer<_$DbClient, $DbStudentsTable> {
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

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payRate => $composableBuilder(
    column: $table.payRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbStudentsTableAnnotationComposer
    extends Composer<_$DbClient, $DbStudentsTable> {
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

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get payRate =>
      $composableBuilder(column: $table.payRate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RatePeriod, String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> groupMembershipsRefs<T extends Object>(
    Expression<T> Function($$GroupMembershipsTableAnnotationComposer a) f,
  ) {
    final $$GroupMembershipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMemberships,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembershipsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMemberships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dbLessonParticipantsRefs<T extends Object>(
    Expression<T> Function($$DbLessonParticipantsTableAnnotationComposer a) f,
  ) {
    final $$DbLessonParticipantsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dbLessonParticipants,
          getReferencedColumn: (t) => t.studentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DbLessonParticipantsTableAnnotationComposer(
                $db: $db,
                $table: $db.dbLessonParticipants,
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
          _$DbClient,
          $DbStudentsTable,
          DbStudent,
          $$DbStudentsTableFilterComposer,
          $$DbStudentsTableOrderingComposer,
          $$DbStudentsTableAnnotationComposer,
          $$DbStudentsTableCreateCompanionBuilder,
          $$DbStudentsTableUpdateCompanionBuilder,
          (DbStudent, $$DbStudentsTableReferences),
          DbStudent,
          PrefetchHooks Function({
            bool groupMembershipsRefs,
            bool dbLessonParticipantsRefs,
          })
        > {
  $$DbStudentsTableTableManager(_$DbClient db, $DbStudentsTable table)
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
                Value<String> contact = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<double> payRate = const Value.absent(),
                Value<RatePeriod> period = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => DbStudentsCompanion(
                id: id,
                name: name,
                contact: contact,
                email: email,
                avatarPath: avatarPath,
                payRate: payRate,
                period: period,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String contact,
                Value<String?> email = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                required double payRate,
                required RatePeriod period,
                required String notes,
                required int createdAt,
                required int updatedAt,
              }) => DbStudentsCompanion.insert(
                id: id,
                name: name,
                contact: contact,
                email: email,
                avatarPath: avatarPath,
                payRate: payRate,
                period: period,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbStudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupMembershipsRefs = false,
                dbLessonParticipantsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (groupMembershipsRefs) db.groupMemberships,
                    if (dbLessonParticipantsRefs) db.dbLessonParticipants,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (groupMembershipsRefs)
                        await $_getPrefetchedData<
                          DbStudent,
                          $DbStudentsTable,
                          GroupMembership
                        >(
                          currentTable: table,
                          referencedTable: $$DbStudentsTableReferences
                              ._groupMembershipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DbStudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMembershipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dbLessonParticipantsRefs)
                        await $_getPrefetchedData<
                          DbStudent,
                          $DbStudentsTable,
                          DbLessonParticipant
                        >(
                          currentTable: table,
                          referencedTable: $$DbStudentsTableReferences
                              ._dbLessonParticipantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DbStudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).dbLessonParticipantsRefs,
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

typedef $$DbStudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $DbStudentsTable,
      DbStudent,
      $$DbStudentsTableFilterComposer,
      $$DbStudentsTableOrderingComposer,
      $$DbStudentsTableAnnotationComposer,
      $$DbStudentsTableCreateCompanionBuilder,
      $$DbStudentsTableUpdateCompanionBuilder,
      (DbStudent, $$DbStudentsTableReferences),
      DbStudent,
      PrefetchHooks Function({
        bool groupMembershipsRefs,
        bool dbLessonParticipantsRefs,
      })
    >;
typedef $$DbGroupsTableCreateCompanionBuilder =
    DbGroupsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> avatarPath,
      required double payRate,
      required RatePeriod period,
      required int createdAt,
      required int updatedAt,
    });
typedef $$DbGroupsTableUpdateCompanionBuilder =
    DbGroupsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> avatarPath,
      Value<double> payRate,
      Value<RatePeriod> period,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

final class $$DbGroupsTableReferences
    extends BaseReferences<_$DbClient, $DbGroupsTable, DbGroup> {
  $$DbGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupMembershipsTable, List<GroupMembership>>
  _groupMembershipsRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.groupMemberships,
    aliasName: $_aliasNameGenerator(
      db.dbGroups.id,
      db.groupMemberships.groupId,
    ),
  );

  $$GroupMembershipsTableProcessedTableManager get groupMembershipsRefs {
    final manager = $$GroupMembershipsTableTableManager(
      $_db,
      $_db.groupMemberships,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupMembershipsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DbLessonParticipantsTable,
    List<DbLessonParticipant>
  >
  _dbLessonParticipantsRefsTable(_$DbClient db) =>
      MultiTypedResultKey.fromTable(
        db.dbLessonParticipants,
        aliasName: $_aliasNameGenerator(
          db.dbGroups.id,
          db.dbLessonParticipants.groupId,
        ),
      );

  $$DbLessonParticipantsTableProcessedTableManager
  get dbLessonParticipantsRefs {
    final manager = $$DbLessonParticipantsTableTableManager(
      $_db,
      $_db.dbLessonParticipants,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dbLessonParticipantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DbGroupsTableFilterComposer
    extends Composer<_$DbClient, $DbGroupsTable> {
  $$DbGroupsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payRate => $composableBuilder(
    column: $table.payRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RatePeriod, RatePeriod, String> get period =>
      $composableBuilder(
        column: $table.period,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupMembershipsRefs(
    Expression<bool> Function($$GroupMembershipsTableFilterComposer f) f,
  ) {
    final $$GroupMembershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMemberships,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembershipsTableFilterComposer(
            $db: $db,
            $table: $db.groupMemberships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dbLessonParticipantsRefs(
    Expression<bool> Function($$DbLessonParticipantsTableFilterComposer f) f,
  ) {
    final $$DbLessonParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dbLessonParticipants,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbLessonParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.dbLessonParticipants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DbGroupsTableOrderingComposer
    extends Composer<_$DbClient, $DbGroupsTable> {
  $$DbGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payRate => $composableBuilder(
    column: $table.payRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbGroupsTableAnnotationComposer
    extends Composer<_$DbClient, $DbGroupsTable> {
  $$DbGroupsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get payRate =>
      $composableBuilder(column: $table.payRate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RatePeriod, String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> groupMembershipsRefs<T extends Object>(
    Expression<T> Function($$GroupMembershipsTableAnnotationComposer a) f,
  ) {
    final $$GroupMembershipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMemberships,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembershipsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMemberships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dbLessonParticipantsRefs<T extends Object>(
    Expression<T> Function($$DbLessonParticipantsTableAnnotationComposer a) f,
  ) {
    final $$DbLessonParticipantsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dbLessonParticipants,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DbLessonParticipantsTableAnnotationComposer(
                $db: $db,
                $table: $db.dbLessonParticipants,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DbGroupsTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $DbGroupsTable,
          DbGroup,
          $$DbGroupsTableFilterComposer,
          $$DbGroupsTableOrderingComposer,
          $$DbGroupsTableAnnotationComposer,
          $$DbGroupsTableCreateCompanionBuilder,
          $$DbGroupsTableUpdateCompanionBuilder,
          (DbGroup, $$DbGroupsTableReferences),
          DbGroup,
          PrefetchHooks Function({
            bool groupMembershipsRefs,
            bool dbLessonParticipantsRefs,
          })
        > {
  $$DbGroupsTableTableManager(_$DbClient db, $DbGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<double> payRate = const Value.absent(),
                Value<RatePeriod> period = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => DbGroupsCompanion(
                id: id,
                name: name,
                description: description,
                avatarPath: avatarPath,
                payRate: payRate,
                period: period,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                required double payRate,
                required RatePeriod period,
                required int createdAt,
                required int updatedAt,
              }) => DbGroupsCompanion.insert(
                id: id,
                name: name,
                description: description,
                avatarPath: avatarPath,
                payRate: payRate,
                period: period,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupMembershipsRefs = false,
                dbLessonParticipantsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (groupMembershipsRefs) db.groupMemberships,
                    if (dbLessonParticipantsRefs) db.dbLessonParticipants,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (groupMembershipsRefs)
                        await $_getPrefetchedData<
                          DbGroup,
                          $DbGroupsTable,
                          GroupMembership
                        >(
                          currentTable: table,
                          referencedTable: $$DbGroupsTableReferences
                              ._groupMembershipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DbGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMembershipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dbLessonParticipantsRefs)
                        await $_getPrefetchedData<
                          DbGroup,
                          $DbGroupsTable,
                          DbLessonParticipant
                        >(
                          currentTable: table,
                          referencedTable: $$DbGroupsTableReferences
                              ._dbLessonParticipantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DbGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).dbLessonParticipantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
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

typedef $$DbGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $DbGroupsTable,
      DbGroup,
      $$DbGroupsTableFilterComposer,
      $$DbGroupsTableOrderingComposer,
      $$DbGroupsTableAnnotationComposer,
      $$DbGroupsTableCreateCompanionBuilder,
      $$DbGroupsTableUpdateCompanionBuilder,
      (DbGroup, $$DbGroupsTableReferences),
      DbGroup,
      PrefetchHooks Function({
        bool groupMembershipsRefs,
        bool dbLessonParticipantsRefs,
      })
    >;
typedef $$GroupMembershipsTableCreateCompanionBuilder =
    GroupMembershipsCompanion Function({
      Value<int> id,
      required int groupId,
      required int studentId,
    });
typedef $$GroupMembershipsTableUpdateCompanionBuilder =
    GroupMembershipsCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> studentId,
    });

final class $$GroupMembershipsTableReferences
    extends
        BaseReferences<_$DbClient, $GroupMembershipsTable, GroupMembership> {
  $$GroupMembershipsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DbGroupsTable _groupIdTable(_$DbClient db) => db.dbGroups.createAlias(
    $_aliasNameGenerator(db.groupMemberships.groupId, db.dbGroups.id),
  );

  $$DbGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$DbGroupsTableTableManager(
      $_db,
      $_db.dbGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DbStudentsTable _studentIdTable(_$DbClient db) =>
      db.dbStudents.createAlias(
        $_aliasNameGenerator(db.groupMemberships.studentId, db.dbStudents.id),
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
}

class $$GroupMembershipsTableFilterComposer
    extends Composer<_$DbClient, $GroupMembershipsTable> {
  $$GroupMembershipsTableFilterComposer({
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

  $$DbGroupsTableFilterComposer get groupId {
    final $$DbGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.dbGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbGroupsTableFilterComposer(
            $db: $db,
            $table: $db.dbGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$GroupMembershipsTableOrderingComposer
    extends Composer<_$DbClient, $GroupMembershipsTable> {
  $$GroupMembershipsTableOrderingComposer({
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

  $$DbGroupsTableOrderingComposer get groupId {
    final $$DbGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.dbGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.dbGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$GroupMembershipsTableAnnotationComposer
    extends Composer<_$DbClient, $GroupMembershipsTable> {
  $$GroupMembershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$DbGroupsTableAnnotationComposer get groupId {
    final $$DbGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.dbGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.dbGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$GroupMembershipsTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $GroupMembershipsTable,
          GroupMembership,
          $$GroupMembershipsTableFilterComposer,
          $$GroupMembershipsTableOrderingComposer,
          $$GroupMembershipsTableAnnotationComposer,
          $$GroupMembershipsTableCreateCompanionBuilder,
          $$GroupMembershipsTableUpdateCompanionBuilder,
          (GroupMembership, $$GroupMembershipsTableReferences),
          GroupMembership,
          PrefetchHooks Function({bool groupId, bool studentId})
        > {
  $$GroupMembershipsTableTableManager(
    _$DbClient db,
    $GroupMembershipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembershipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembershipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> studentId = const Value.absent(),
              }) => GroupMembershipsCompanion(
                id: id,
                groupId: groupId,
                studentId: studentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int studentId,
              }) => GroupMembershipsCompanion.insert(
                id: id,
                groupId: groupId,
                studentId: studentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupMembershipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, studentId = false}) {
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
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$GroupMembershipsTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$GroupMembershipsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable:
                                    $$GroupMembershipsTableReferences
                                        ._studentIdTable(db),
                                referencedColumn:
                                    $$GroupMembershipsTableReferences
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

typedef $$GroupMembershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $GroupMembershipsTable,
      GroupMembership,
      $$GroupMembershipsTableFilterComposer,
      $$GroupMembershipsTableOrderingComposer,
      $$GroupMembershipsTableAnnotationComposer,
      $$GroupMembershipsTableCreateCompanionBuilder,
      $$GroupMembershipsTableUpdateCompanionBuilder,
      (GroupMembership, $$GroupMembershipsTableReferences),
      GroupMembership,
      PrefetchHooks Function({bool groupId, bool studentId})
    >;
typedef $$DbLessonParticipantsTableCreateCompanionBuilder =
    DbLessonParticipantsCompanion Function({
      Value<int> id,
      required int lessonId,
      required int studentId,
      required bool isPaid,
      required bool attended,
      Value<int?> groupId,
    });
typedef $$DbLessonParticipantsTableUpdateCompanionBuilder =
    DbLessonParticipantsCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<int> studentId,
      Value<bool> isPaid,
      Value<bool> attended,
      Value<int?> groupId,
    });

final class $$DbLessonParticipantsTableReferences
    extends
        BaseReferences<
          _$DbClient,
          $DbLessonParticipantsTable,
          DbLessonParticipant
        > {
  $$DbLessonParticipantsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DbLessonsTable _lessonIdTable(_$DbClient db) =>
      db.dbLessons.createAlias(
        $_aliasNameGenerator(db.dbLessonParticipants.lessonId, db.dbLessons.id),
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

  static $DbStudentsTable _studentIdTable(_$DbClient db) =>
      db.dbStudents.createAlias(
        $_aliasNameGenerator(
          db.dbLessonParticipants.studentId,
          db.dbStudents.id,
        ),
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

  static $DbGroupsTable _groupIdTable(_$DbClient db) => db.dbGroups.createAlias(
    $_aliasNameGenerator(db.dbLessonParticipants.groupId, db.dbGroups.id),
  );

  $$DbGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$DbGroupsTableTableManager(
      $_db,
      $_db.dbGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DbLessonParticipantsTableFilterComposer
    extends Composer<_$DbClient, $DbLessonParticipantsTable> {
  $$DbLessonParticipantsTableFilterComposer({
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

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get attended => $composableBuilder(
    column: $table.attended,
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

  $$DbGroupsTableFilterComposer get groupId {
    final $$DbGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.dbGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbGroupsTableFilterComposer(
            $db: $db,
            $table: $db.dbGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbLessonParticipantsTableOrderingComposer
    extends Composer<_$DbClient, $DbLessonParticipantsTable> {
  $$DbLessonParticipantsTableOrderingComposer({
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

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get attended => $composableBuilder(
    column: $table.attended,
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

  $$DbGroupsTableOrderingComposer get groupId {
    final $$DbGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.dbGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.dbGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbLessonParticipantsTableAnnotationComposer
    extends Composer<_$DbClient, $DbLessonParticipantsTable> {
  $$DbLessonParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<bool> get attended =>
      $composableBuilder(column: $table.attended, builder: (column) => column);

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

  $$DbGroupsTableAnnotationComposer get groupId {
    final $$DbGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.dbGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DbGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.dbGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DbLessonParticipantsTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $DbLessonParticipantsTable,
          DbLessonParticipant,
          $$DbLessonParticipantsTableFilterComposer,
          $$DbLessonParticipantsTableOrderingComposer,
          $$DbLessonParticipantsTableAnnotationComposer,
          $$DbLessonParticipantsTableCreateCompanionBuilder,
          $$DbLessonParticipantsTableUpdateCompanionBuilder,
          (DbLessonParticipant, $$DbLessonParticipantsTableReferences),
          DbLessonParticipant,
          PrefetchHooks Function({bool lessonId, bool studentId, bool groupId})
        > {
  $$DbLessonParticipantsTableTableManager(
    _$DbClient db,
    $DbLessonParticipantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbLessonParticipantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbLessonParticipantsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DbLessonParticipantsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<bool> attended = const Value.absent(),
                Value<int?> groupId = const Value.absent(),
              }) => DbLessonParticipantsCompanion(
                id: id,
                lessonId: lessonId,
                studentId: studentId,
                isPaid: isPaid,
                attended: attended,
                groupId: groupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                required int studentId,
                required bool isPaid,
                required bool attended,
                Value<int?> groupId = const Value.absent(),
              }) => DbLessonParticipantsCompanion.insert(
                id: id,
                lessonId: lessonId,
                studentId: studentId,
                isPaid: isPaid,
                attended: attended,
                groupId: groupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DbLessonParticipantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({lessonId = false, studentId = false, groupId = false}) {
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
                                    referencedTable:
                                        $$DbLessonParticipantsTableReferences
                                            ._lessonIdTable(db),
                                    referencedColumn:
                                        $$DbLessonParticipantsTableReferences
                                            ._lessonIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (studentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.studentId,
                                    referencedTable:
                                        $$DbLessonParticipantsTableReferences
                                            ._studentIdTable(db),
                                    referencedColumn:
                                        $$DbLessonParticipantsTableReferences
                                            ._studentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable:
                                        $$DbLessonParticipantsTableReferences
                                            ._groupIdTable(db),
                                    referencedColumn:
                                        $$DbLessonParticipantsTableReferences
                                            ._groupIdTable(db)
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

typedef $$DbLessonParticipantsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $DbLessonParticipantsTable,
      DbLessonParticipant,
      $$DbLessonParticipantsTableFilterComposer,
      $$DbLessonParticipantsTableOrderingComposer,
      $$DbLessonParticipantsTableAnnotationComposer,
      $$DbLessonParticipantsTableCreateCompanionBuilder,
      $$DbLessonParticipantsTableUpdateCompanionBuilder,
      (DbLessonParticipant, $$DbLessonParticipantsTableReferences),
      DbLessonParticipant,
      PrefetchHooks Function({bool lessonId, bool studentId, bool groupId})
    >;

class $DbClientManager {
  final _$DbClient _db;
  $DbClientManager(this._db);
  $$DbLessonsTableTableManager get dbLessons =>
      $$DbLessonsTableTableManager(_db, _db.dbLessons);
  $$DbStudentsTableTableManager get dbStudents =>
      $$DbStudentsTableTableManager(_db, _db.dbStudents);
  $$DbGroupsTableTableManager get dbGroups =>
      $$DbGroupsTableTableManager(_db, _db.dbGroups);
  $$GroupMembershipsTableTableManager get groupMemberships =>
      $$GroupMembershipsTableTableManager(_db, _db.groupMemberships);
  $$DbLessonParticipantsTableTableManager get dbLessonParticipants =>
      $$DbLessonParticipantsTableTableManager(_db, _db.dbLessonParticipants);
}
