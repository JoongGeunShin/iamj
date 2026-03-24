import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/data/repositories/clock_repository_provider.dart';
import 'package:iamj/data/repositories/schedule_repository_provider.dart';
import 'package:iamj/domain/entities/schedule_state.dart';
import 'package:iamj/presentation/content/screens/content_screen.dart';

class ContentCard extends ConsumerStatefulWidget {
  final ScheduleState schedule;

  const ContentCard({super.key, required this.schedule});

  @override
  ConsumerState<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends ConsumerState<ContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late double _startTimeValue, _endTimeValue;

  @override
  void initState() {
    super.initState();
    _startTimeValue = _timeStringToDouble(widget.schedule.startTime);
    _endTimeValue = _timeStringToDouble(widget.schedule.endTime);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  double _timeStringToDouble(String time) {
    try {
      final parts = time.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      return (hours * 60 + minutes) / (24 * 60);
    } catch (e) {
      return 0.0;
    }
  }

  String _formatTime(double value) {
    int totalMinutes = (value * 24 * 60).toInt();
    int hours = (totalMinutes ~/ 60).clamp(0, 23);
    int minutes = (totalMinutes % 60).clamp(0, 59);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String _calculateRemainingTime(DateTime now, String startTimeStr) {
    try {
      final parts = startTimeStr.split(':');
      final targetTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      final difference = targetTime.difference(now);
      if (difference.isNegative) return "IN PROGRESS";

      final h = difference.inHours;
      final m = difference.inMinutes % 60;
      final s = difference.inSeconds % 60;
      return 'STARTS IN ${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } catch (e) {
      return "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _deleteSchedule() {
    ref.read(scheduleRepositoryProvider).deleteSchedule(widget.schedule.id!);
  }

  @override
  Widget build(BuildContext context) {
    final timeAsync = ref.watch(watchTimeProvider);
    final now = timeAsync.value ?? DateTime.now();
    final double nowValue = (now.hour * 60 + now.minute) / (24 * 60);
    final String statusText = _calculateRemainingTime(now, widget.schedule.startTime);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, anim, _) => ContentScreen(schedule: widget.schedule),
          transitionsBuilder: (context, anim, _, child) => FadeTransition(opacity: anim, child: child),
        ));
      },
      onLongPress: () {
        final s = widget.schedule;

        // 전체 스케줄 기본 정보 출력
        print('=========================================');
        print('           SCHEDULE DETAILS              ');
        print('=========================================');
        print('ID        : ${s.id}');
        print('Title     : ${s.title}');
        print('Time      : ${s.startTime} ~ ${s.endTime}');
        print('Priority  : ${s.priority}');
        print('Completed : ${s.isCompleted}');
        print('Stared    : ${s.isStared}');
        print('Memo      : ${s.memo}');
        print('-----------------------------------------');

        // Task 리스트 상세 출력
        print('TASKS (${s.tasks.length} items):');

        if (s.tasks.isEmpty) {
          print('  (No tasks available)');
        } else {
          for (var i = 0; i < s.tasks.length; i++) {
            final task = s.tasks[i];
            print('  [${i + 1}] ${task.taskTitle} ${task.isDone ? "✅" : "❌"}');

            // 세부 단계(Detail)가 있다면 출력
            if (task.detail != null && task.detail!.isNotEmpty) {
              for (var d in task.detail!) {
                print('      - Sequence: ${d.sequence}');
                print('        RestTime: ${d.restTime}');
              }
            }

            // 해당 태스크 뒤에 전체 휴식 시간이 있다면 출력
            if (task.restTime != null && task.restTime!.isNotEmpty) {
              print('      * Total Rest: ${task.restTime}');
            }
          }
        }
        print('=========================================');
      },
      child: Hero(
        tag: 'content_${widget.schedule.id}',
        child: Material(
          type: MaterialType.transparency,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D0D),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.schedule.title.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'WantedSans',
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  statusText,
                                  style: const TextStyle(
                                    color: Color(0xFFFFB138),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _deleteSchedule,
                            icon: Icon(Icons.close, color: Colors.white.withOpacity(0.2), size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimeDisplay("START", _formatTime(_startTimeValue)),
                          Container(
                            height: 1,
                            width: 30,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          _buildTimeDisplay("END", _formatTime(_endTimeValue)),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double width = constraints.maxWidth;
                              return Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 6,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Positioned(
                                    left: width * _startTimeValue,
                                    child: Container(
                                      height: 6,
                                      width: width * (_endTimeValue - _startTimeValue),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.2),
                                            blurRadius: 8,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: (width * nowValue) - 4,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFB138),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 1.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFFB138).withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _subText("00:00"),
                              _subText("12:00"),
                              _subText("24:00"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _subText(String text) => Text(
    text,
    style: TextStyle(color: Color(0xFFFFB138), fontSize: 9, fontWeight: FontWeight.bold),
  );

  Widget _buildTimeDisplay(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFFFB138),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontFamily: 'WantedSans',
          ),
        ),
      ],
    );
  }
}