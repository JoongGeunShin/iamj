class ScheduleState {
  final int? id;
  final String title, memo;
  final String startTime, endTime;

  final String priority;

  final bool isCompleted;
  final bool isStared;

  ScheduleState({
    this.id,
    required this.title,
    required this.memo,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.isCompleted,
    required this.isStared,
  });
}
