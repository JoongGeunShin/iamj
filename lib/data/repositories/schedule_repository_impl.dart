import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:iamj/data/datasources/gemini_data_source.dart';
import 'package:iamj/domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_state.dart';
import '../datasources/local_database.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final LocalDatabase db;
  final GeminiDataSource geminiDataSource;

  ScheduleRepositoryImpl(this.db, this.geminiDataSource);

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
        tasks: Value(schedule.tasks),
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
    if (schedule.id == null) return;

    await (db.update(db.scheduleTable)..where((t) => t.id.equals(schedule.id!)))
        .write(
      ScheduleTableCompanion(
        // 다른 필드들과 마찬가지로 Value()로 감싸야 합니다.
        title: Value(schedule.title),
        memo: Value(schedule.memo),
        tasks: Value(schedule.tasks), // 이 부분을 수정하세요!
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

  // Row 데이터를 Entity로 변환할 때 tasks 컬럼도 포함
  List<ScheduleState> _mapToEntity(List<ScheduleTableData> rows) {
    return rows.map((row) => ScheduleState(
      id: row.id,
      title: row.title,
      memo: row.memo,
      tasks: row.tasks, // TypeConverter에 의해 자동으로 List<TaskItem>으로 변환됨
      startTime: row.startTime,
      endTime: row.endTime,
      priority: row.priority,
      isCompleted: row.isCompleted,
      isStared: row.isStared,
    )).toList();
  }

  @override
  Future<ScheduleState> analyzeScheduleText(String text) async {
    final prompt = """
      사용자 입력: "$text"
      현재 기준 시간: ${DateTime.now().toIso8601String()}
      
      위 문장을 분석하여 상세한 일정 계획을 수립하고 JSON으로 출력해줘.
      
      ### 요구 조건:
      1. 'title': 핵심 목표.
      2. 'memo': 전체 일정에 대한 간단한 요약 한 줄.
      3. 'tasks': 활동별로 상세히 나누어 리스트로 작성할 것.
         - 'taskTitle': 활동의 이름.
         - 'detail': 해당 활동의 세부 단계(sequence)와 각 단계별 휴식 시간(restTime)을 리스트로 작성.
         - 'restTime': 해당 활동 전체가 끝난 후의 총 휴식 시간 (필요 시).
      4. 시간 정보는 현재 시간을 기준으로 정확한 ISO8601 형식을 사용할 것.
      
      ### 출력 JSON 형식:
      {
        "title": "가슴 운동",
        "memo": "90분간 진행되는 가슴 집중 루틴",
        "tasks": [
          {
            "taskTitle": "벤치 프레스",
            "detail": [
              { "sequence": "1세트 10회", "restTime": "90초" },
              { "sequence": "2세트 10회", "restTime": "90초" }
            ],
            "restTime": "2분"
          }
        ],
        "startTime": "2026-03-19T17:00:00",
        "endTime": "2026-03-19T18:30:00",
        "priority": "HIGH"
      }
      """;

    final json = await geminiDataSource.analyzeText(prompt);

    // JSON으로부터 TaskItem 리스트 생성
    final List<dynamic> tasksJson = json['tasks'] ?? [];
    final tasks = tasksJson.map((t) => TaskItem.fromJson(t)).toList();

    return ScheduleState(
      title: json['title'] ?? '제목 없음',
      memo: json['memo'] ?? '',
      tasks: tasks,
      startTime: json['startTime'] ?? DateTime.now().toIso8601String(),
      endTime: json['endTime'] ?? DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      priority: json['priority'] ?? 'MEDIUM',
      isCompleted: false,
      isStared: false,
    );
  }
}