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

  ScheduleState copyWith({
    int? id,
    String? title,
    String? memo,
    List<TaskItem>? tasks,
    String? startTime, endTime,
    String? priority,
    bool? isCompleted,
    bool? isStared,
  }) {
    return ScheduleState(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      tasks: tasks ?? this.tasks,
      memo: memo?? this.memo,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      isStared: isStared ?? this.isStared,
    );
  }

}

class TaskItem {
  final String taskTitle;
  final List<TaskItemDetail>? detail;
  final String? restTime;
  final bool isCompleted;

  TaskItem({
    required this.taskTitle,
    this.detail,
    this.restTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'taskTitle': taskTitle,
    'detail': detail?.map((e) => e.toJson()).toList(),
    'restTime': restTime,
    'isCompleted': isCompleted,
  };

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      taskTitle: json['taskTitle'] ?? '',
      detail: (json['detail'] as List?)
          ?.map((e) => TaskItemDetail.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      restTime: json['restTime'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class TaskItemDetail {
  final String sequence;
  final String restTime;
  final bool isCompleted;

  TaskItemDetail({required this.sequence, required this.restTime, required this.isCompleted});

  Map<String, dynamic> toJson() => {
    'sequence': sequence,
    'restTime': restTime,
    'isCompleted' : isCompleted,
  };
  factory TaskItemDetail.fromJson(Map<String, dynamic> json) {
    return TaskItemDetail(
      sequence: json['sequence'] ?? '',
      restTime: json['restTime'] ?? '',
      isCompleted: json['isCompleted'] is bool
          ? json['isCompleted']
          : (json['isCompleted'].toString().toLowerCase() == 'true'),
    );
  }
}
