import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';

import '../../domain/entities/schedule_state.dart';

part 'local_database.g.dart';


class TaskListConverter extends TypeConverter<List<TaskItem>, String> {
  const TaskListConverter();

  @override
  List<TaskItem> fromSql(String fromDb) {
    final List<dynamic> decoded = jsonDecode(fromDb);
    return decoded.map((item) => TaskItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  String toSql(List<TaskItem> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}

class ScheduleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get memo => text()();

  // .withDefault(const Constant('[]')) 를 추가하세요.
  TextColumn get tasks => text()
      .map(const TaskListConverter())
      .withDefault(const Constant('[]'))();

  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get priority => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isStared => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [ScheduleTable])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(scheduleTable, scheduleTable.tasks);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}