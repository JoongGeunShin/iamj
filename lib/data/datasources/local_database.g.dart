// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $ScheduleTableTable extends ScheduleTable
    with TableInfo<$ScheduleTableTable, ScheduleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<TaskItem>, String> tasks =
      GeneratedColumn<String>(
        'tasks',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<TaskItem>>($ScheduleTableTable.$convertertasks);
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isStaredMeta = const VerificationMeta(
    'isStared',
  );
  @override
  late final GeneratedColumn<bool> isStared = GeneratedColumn<bool>(
    'is_stared',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_stared" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    memo,
    tasks,
    startTime,
    endTime,
    priority,
    isCompleted,
    isStared,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    } else if (isInserting) {
      context.missing(_memoMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('is_stared')) {
      context.handle(
        _isStaredMeta,
        isStared.isAcceptableOrUnknown(data['is_stared']!, _isStaredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      )!,
      tasks: $ScheduleTableTable.$convertertasks.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tasks'],
        )!,
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      isStared: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_stared'],
      )!,
    );
  }

  @override
  $ScheduleTableTable createAlias(String alias) {
    return $ScheduleTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<TaskItem>, String> $convertertasks =
      const TaskListConverter();
}

class ScheduleTableData extends DataClass
    implements Insertable<ScheduleTableData> {
  final int id;
  final String title;
  final String memo;
  final List<TaskItem> tasks;
  final String startTime;
  final String endTime;
  final String priority;
  final bool isCompleted;
  final bool isStared;
  const ScheduleTableData({
    required this.id,
    required this.title,
    required this.memo,
    required this.tasks,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.isCompleted,
    required this.isStared,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['memo'] = Variable<String>(memo);
    {
      map['tasks'] = Variable<String>(
        $ScheduleTableTable.$convertertasks.toSql(tasks),
      );
    }
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['priority'] = Variable<String>(priority);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_stared'] = Variable<bool>(isStared);
    return map;
  }

  ScheduleTableCompanion toCompanion(bool nullToAbsent) {
    return ScheduleTableCompanion(
      id: Value(id),
      title: Value(title),
      memo: Value(memo),
      tasks: Value(tasks),
      startTime: Value(startTime),
      endTime: Value(endTime),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      isStared: Value(isStared),
    );
  }

  factory ScheduleTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      memo: serializer.fromJson<String>(json['memo']),
      tasks: serializer.fromJson<List<TaskItem>>(json['tasks']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      priority: serializer.fromJson<String>(json['priority']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isStared: serializer.fromJson<bool>(json['isStared']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'memo': serializer.toJson<String>(memo),
      'tasks': serializer.toJson<List<TaskItem>>(tasks),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'priority': serializer.toJson<String>(priority),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isStared': serializer.toJson<bool>(isStared),
    };
  }

  ScheduleTableData copyWith({
    int? id,
    String? title,
    String? memo,
    List<TaskItem>? tasks,
    String? startTime,
    String? endTime,
    String? priority,
    bool? isCompleted,
    bool? isStared,
  }) => ScheduleTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    memo: memo ?? this.memo,
    tasks: tasks ?? this.tasks,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    isStared: isStared ?? this.isStared,
  );
  ScheduleTableData copyWithCompanion(ScheduleTableCompanion data) {
    return ScheduleTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      memo: data.memo.present ? data.memo.value : this.memo,
      tasks: data.tasks.present ? data.tasks.value : this.tasks,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      isStared: data.isStared.present ? data.isStared.value : this.isStared,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('memo: $memo, ')
          ..write('tasks: $tasks, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isStared: $isStared')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    memo,
    tasks,
    startTime,
    endTime,
    priority,
    isCompleted,
    isStared,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.memo == this.memo &&
          other.tasks == this.tasks &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.priority == this.priority &&
          other.isCompleted == this.isCompleted &&
          other.isStared == this.isStared);
}

class ScheduleTableCompanion extends UpdateCompanion<ScheduleTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> memo;
  final Value<List<TaskItem>> tasks;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String> priority;
  final Value<bool> isCompleted;
  final Value<bool> isStared;
  const ScheduleTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.memo = const Value.absent(),
    this.tasks = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isStared = const Value.absent(),
  });
  ScheduleTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String memo,
    this.tasks = const Value.absent(),
    required String startTime,
    required String endTime,
    required String priority,
    this.isCompleted = const Value.absent(),
    this.isStared = const Value.absent(),
  }) : title = Value(title),
       memo = Value(memo),
       startTime = Value(startTime),
       endTime = Value(endTime),
       priority = Value(priority);
  static Insertable<ScheduleTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? memo,
    Expression<String>? tasks,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? priority,
    Expression<bool>? isCompleted,
    Expression<bool>? isStared,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (memo != null) 'memo': memo,
      if (tasks != null) 'tasks': tasks,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (priority != null) 'priority': priority,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isStared != null) 'is_stared': isStared,
    });
  }

  ScheduleTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? memo,
    Value<List<TaskItem>>? tasks,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<String>? priority,
    Value<bool>? isCompleted,
    Value<bool>? isStared,
  }) {
    return ScheduleTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: memo ?? this.memo,
      tasks: tasks ?? this.tasks,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isStared: isStared ?? this.isStared,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (tasks.present) {
      map['tasks'] = Variable<String>(
        $ScheduleTableTable.$convertertasks.toSql(tasks.value),
      );
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isStared.present) {
      map['is_stared'] = Variable<bool>(isStared.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('memo: $memo, ')
          ..write('tasks: $tasks, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isStared: $isStared')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $ScheduleTableTable scheduleTable = $ScheduleTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [scheduleTable];
}

typedef $$ScheduleTableTableCreateCompanionBuilder =
    ScheduleTableCompanion Function({
      Value<int> id,
      required String title,
      required String memo,
      Value<List<TaskItem>> tasks,
      required String startTime,
      required String endTime,
      required String priority,
      Value<bool> isCompleted,
      Value<bool> isStared,
    });
typedef $$ScheduleTableTableUpdateCompanionBuilder =
    ScheduleTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> memo,
      Value<List<TaskItem>> tasks,
      Value<String> startTime,
      Value<String> endTime,
      Value<String> priority,
      Value<bool> isCompleted,
      Value<bool> isStared,
    });

class $$ScheduleTableTableFilterComposer
    extends Composer<_$LocalDatabase, $ScheduleTableTable> {
  $$ScheduleTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<TaskItem>, List<TaskItem>, String>
  get tasks => $composableBuilder(
    column: $table.tasks,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStared => $composableBuilder(
    column: $table.isStared,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduleTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $ScheduleTableTable> {
  $$ScheduleTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tasks => $composableBuilder(
    column: $table.tasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStared => $composableBuilder(
    column: $table.isStared,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduleTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ScheduleTableTable> {
  $$ScheduleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<TaskItem>, String> get tasks =>
      $composableBuilder(column: $table.tasks, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStared =>
      $composableBuilder(column: $table.isStared, builder: (column) => column);
}

class $$ScheduleTableTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $ScheduleTableTable,
          ScheduleTableData,
          $$ScheduleTableTableFilterComposer,
          $$ScheduleTableTableOrderingComposer,
          $$ScheduleTableTableAnnotationComposer,
          $$ScheduleTableTableCreateCompanionBuilder,
          $$ScheduleTableTableUpdateCompanionBuilder,
          (
            ScheduleTableData,
            BaseReferences<
              _$LocalDatabase,
              $ScheduleTableTable,
              ScheduleTableData
            >,
          ),
          ScheduleTableData,
          PrefetchHooks Function()
        > {
  $$ScheduleTableTableTableManager(
    _$LocalDatabase db,
    $ScheduleTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> memo = const Value.absent(),
                Value<List<TaskItem>> tasks = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isStared = const Value.absent(),
              }) => ScheduleTableCompanion(
                id: id,
                title: title,
                memo: memo,
                tasks: tasks,
                startTime: startTime,
                endTime: endTime,
                priority: priority,
                isCompleted: isCompleted,
                isStared: isStared,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String memo,
                Value<List<TaskItem>> tasks = const Value.absent(),
                required String startTime,
                required String endTime,
                required String priority,
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isStared = const Value.absent(),
              }) => ScheduleTableCompanion.insert(
                id: id,
                title: title,
                memo: memo,
                tasks: tasks,
                startTime: startTime,
                endTime: endTime,
                priority: priority,
                isCompleted: isCompleted,
                isStared: isStared,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduleTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $ScheduleTableTable,
      ScheduleTableData,
      $$ScheduleTableTableFilterComposer,
      $$ScheduleTableTableOrderingComposer,
      $$ScheduleTableTableAnnotationComposer,
      $$ScheduleTableTableCreateCompanionBuilder,
      $$ScheduleTableTableUpdateCompanionBuilder,
      (
        ScheduleTableData,
        BaseReferences<_$LocalDatabase, $ScheduleTableTable, ScheduleTableData>,
      ),
      ScheduleTableData,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$ScheduleTableTableTableManager get scheduleTable =>
      $$ScheduleTableTableTableManager(_db, _db.scheduleTable);
}
