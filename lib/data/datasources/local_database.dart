import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'local_database.g.dart';

// 1. 테이블 정의 (Domain의 ScheduleState 속성을 반영)
class ScheduleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get memo => text()();
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
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}