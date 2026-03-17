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

  @override
  Future<ScheduleState> analyzeScheduleText(String text) async {
    final prompt = """
      사용자 입력: "$text"
      현재 기준 시간: ${DateTime.now().toIso8601String()}
      
      위 문장을 분석하여 목적에 맞게 저장할 JSON 데이터를 생성해줘.
      
      ### 요구 조건:
      0. 시작시간이나 종료시간이 문장에 있다면 그 값이 디폴트가 되어야할 것.
      1. 'memo' 필드에는 사용자가 요구한 조건과 적절한 쉬는 시간을 상세히 포함할 것.
      2. 모든 시간 데이터(startTime, endTime)는 제공된 '현재 기준 시간'을 바탕으로 정확한 ISO8601 형식으로 계산할 것.
      3. 사용자가 시간을 명시하지 않았다면 기본 1시간으로 설정할 것.
      4. 응답은 반드시 마크다운 코드 블록 없이 순수 JSON 객체 하나만 출력할 것.
      
      ### 출력 JSON 형식:
      {
        "title": "목적과 가장 관련 있는 제목 (예: 가슴 운동 루틴, 공부, 잠자기)",
        "memo": "추천 루틴 및 쉬는 시간 설명",
        "startTime": "YYYY-MM-DDTHH:mm:ss",
        "endTime": "YYYY-MM-DDTHH:mm:ss",
        "priority": "HIGH/MEDIUM/LOW"
      }
      """;

    final json = await geminiDataSource.analyzeText(prompt);

    return ScheduleState(
      title: json['title'] ?? '제목 없음',
      memo: json['memo'] ?? '',
      startTime: json['startTime'] ?? DateTime.now().toIso8601String(),
      endTime: json['endTime'] ?? DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      priority: json['priority'] ?? 'MEDIUM',
      isCompleted: false,
      isStared: false,
    );
  }
}