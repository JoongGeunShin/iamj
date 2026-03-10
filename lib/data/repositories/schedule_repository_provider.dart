import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/data/repositories/schedule_repository_impl.dart';
import 'package:iamj/domain/repositories/schedule_repository.dart';
import 'package:iamj/domain/entities/schedule_state.dart';
import '../datasources/local_database.dart';

part 'schedule_repository_provider.g.dart';

@riverpod
LocalDatabase localDatabase(Ref ref) {
  final db = LocalDatabase();
  ref.onDispose(() => db.close()); // 앱 종료 시 DB 닫기
  return db;
}

@riverpod
ScheduleRepository scheduleRepository(Ref ref) {
  final db = ref.watch(localDatabaseProvider);
  return ScheduleRepositoryImpl(db);
}

@riverpod
Stream<List<ScheduleState>> scheduleListStream(Ref ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return repository.watchSchedules();
}

@riverpod
class ScheduleNotifier extends _$ScheduleNotifier {
  @override
  void build() {}

  Future<void> addSchedule(ScheduleState schedule) async {
    await ref.read(scheduleRepositoryProvider).saveSchedule(schedule);
  }

  Future<void> updateSchedule(ScheduleState schedule) async {
    await ref.read(scheduleRepositoryProvider).updateSchedule(schedule);
  }

  Future<void> deleteSchedule(int id) async {
    await ref.read(scheduleRepositoryProvider).deleteSchedule(id);
  }
}