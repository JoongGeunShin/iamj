import '../entities/schedule_state.dart';

abstract class ScheduleRepository{
  Future<List<ScheduleState>> getSchedule();
  Stream<List<ScheduleState>> watchSchedules();

  Future<void> saveSchedule(ScheduleState schedule);

  Future<void> updateSchedule(ScheduleState schedule);
  Future<void> deleteSchedule(int id);
}