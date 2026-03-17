import 'package:iamj/service/api_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/data/repositories/schedule_repository_impl.dart';
import 'package:iamj/domain/repositories/schedule_repository.dart';
import 'package:iamj/domain/entities/schedule_state.dart';
import '../datasources/gemini_data_source.dart';
import '../datasources/local_database.dart';

part 'schedule_repository_provider.g.dart';

@riverpod
LocalDatabase localDatabase(Ref ref) {
  final db = LocalDatabase();
  ref.onDispose(() => db.close()); // 앱 종료 시 DB 닫기
  return db;
}
@riverpod
GeminiDataSource geminiDataSource(Ref ref) {
  return GeminiDataSource(GeminiAPI.GEMINI_APIKEY);
}

@riverpod
ScheduleRepository scheduleRepository(Ref ref) {
  final db = ref.watch(localDatabaseProvider);
  final gemini = ref.watch(geminiDataSourceProvider); // gemini 감시
  return ScheduleRepositoryImpl(db, gemini); // 2개의 인자 전달
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

  Future<ScheduleState> analyzeAndAdd(String text) async {
    final repository = ref.read(scheduleRepositoryProvider);
    final analyzed = await repository.analyzeScheduleText(text);
    return analyzed;
  }

  Future<ScheduleState> analyzeScheduleText(String text) async {
    final repository = ref.read(scheduleRepositoryProvider);
    final analyzed = await repository.analyzeScheduleText(text);
    return analyzed;
  }

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