class ScheduleState {
  final int? id;
  final String title;
  final String memo;
  final List<TaskItem> tasks;
  final String startTime, endTime;
  final String priority;
  final bool isCompleted;
  final bool isStared;

  ScheduleState({
    this.id,
    required this.title,
    required this.memo,
    required this.tasks,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.isCompleted,
    required this.isStared,
  });
}

class TaskItem {
  final String taskTitle;
  final List<TaskItemDetail>? detail;
  final String? restTime;
  final bool isDone;

  TaskItem({
    required this.taskTitle,
    this.detail,
    this.restTime,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'taskTitle': taskTitle,
    'detail': detail?.map((e) => e.toJson()).toList(),
    'restTime': restTime,
    'isDone': isDone,
  };

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      taskTitle: json['taskTitle'] ?? '',
      detail: (json['detail'] as List?)
          ?.map((e) => TaskItemDetail.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      restTime: json['restTime'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }
}

class TaskItemDetail {
  final String sequence;
  final String restTime;

  TaskItemDetail({required this.sequence, required this.restTime});

  Map<String, dynamic> toJson() => {
    'sequence': sequence,
    'restTime': restTime,
  };
  factory TaskItemDetail.fromJson(Map<String, dynamic> json) {
    return TaskItemDetail(
      sequence: json['sequence'] ?? '',
      restTime: json['restTime'] ?? '',
    );
  }
}
