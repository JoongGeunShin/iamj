import '../entities/schedule_state.dart';

abstract class ScheduleRepository{
  // 2026-03-17 added gemini api
  Future<ScheduleState> analyzeScheduleText(String text);

  Future<List<ScheduleState>> getSchedule();
  Stream<List<ScheduleState>> watchSchedules();

  Future<void> saveSchedule(ScheduleState schedule);

  Future<void> updateSchedule(ScheduleState schedule);
  Future<void> deleteSchedule(int id);
}