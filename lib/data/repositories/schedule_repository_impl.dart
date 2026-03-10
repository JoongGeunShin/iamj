import 'package:drift/drift.dart';
import 'package:iamj/domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_state.dart';
import '../datasources/local_database.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final LocalDatabase db;

  ScheduleRepositoryImpl(this.db);

  @override
  Future<List<ScheduleState>> getSchedule() async {
    final rows = await db.select(db.scheduleTable).get();
    return _mapToEntity(rows);
  }

  @override
  Stream<List<ScheduleState>> watchSchedules() {
    return db.select(db.scheduleTable).watch().map((rows) => _mapToEntity(rows));
  }

  @override
  Future<void> saveSchedule(ScheduleState schedule) async {
    await db.into(db.scheduleTable).insert(
      ScheduleTableCompanion.insert(
        title: schedule.title,
        memo: schedule.memo,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        priority: schedule.priority,
        isCompleted: Value(schedule.isCompleted),
        isStared: Value(schedule.isStared),
      ),
    );
  }
  @override
  Future<void> updateSchedule(ScheduleState schedule) async {
    if (schedule.id == null) return; // ID가 없으면 수정 불가

    await (db.update(db.scheduleTable)..where((t) => t.id.equals(schedule.id!)))
        .write(
      ScheduleTableCompanion(
        title: Value(schedule.title),
        memo: Value(schedule.memo),
        startTime: Value(schedule.startTime),
        endTime: Value(schedule.endTime),
        priority: Value(schedule.priority),
        isCompleted: Value(schedule.isCompleted),
        isStared: Value(schedule.isStared),
      ),
    );
  }

  @override
  Future<void> deleteSchedule(int id) async {
    await (db.delete(db.scheduleTable)..where((t) => t.id.equals(id))).go();
  }

  List<ScheduleState> _mapToEntity(List<ScheduleTableData> rows) {
    return rows.map((row) => ScheduleState(
      id: row.id,
      title: row.title,
      memo: row.memo,
      startTime: row.startTime,
      endTime: row.endTime,
      priority: row.priority,
      isCompleted: row.isCompleted,
      isStared: row.isStared,
    )).toList();
  }
}