import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/clock_repository_provider.dart';
import '../../../data/repositories/schedule_repository_provider.dart';
import '../../../domain/entities/schedule_state.dart';

class ContentScreen extends ConsumerStatefulWidget {
  final ScheduleState schedule;

  const ContentScreen({super.key, required this.schedule});

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
  late String _title, _memo, _startTime, _endTime, _priority;
  late bool _isCompleted, _isStared;

  late double _startTimeValue, _endTimeValue;

  @override
  void initState() {
    super.initState();
    super.initState();
    _startTime = widget.schedule.startTime;
    _startTimeValue = _timeStringToDouble(_startTime);
    _endTime = widget.schedule.endTime;
    _endTimeValue = _timeStringToDouble(_endTime);
    _title = widget.schedule.title;
    _memo = widget.schedule.memo;
    _priority = widget.schedule.priority;

    _isCompleted = widget.schedule.isCompleted;
    _isStared = widget.schedule.isStared;
  }

  double _timeStringToDouble(String time) {
    try {
      final parts = time.split(':');
      int hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      if (hours == 24) return 1.0;

      final double fraction = (hours * 60 + minutes) / (24 * 60);
      return fraction;
    } catch (e) {
      return 0.0;
    }
  }

  String _formatTime(double value) {
    int totalMinutes = (value * 24 * 60).toInt();
    int hours = (totalMinutes ~/ 60).clamp(0, 23);
    int minutes = (totalMinutes % 60).clamp(0, 59);
    return '${hours.toString().padLeft(2, '00')}:${minutes.toString().padLeft(
        2, '00')}';
  }

  String _calculateRemainingTime(DateTime now, String startTimeStr) {
    try {
      final parts = startTimeStr.split(':');
      final targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final difference = targetTime.difference(now);
      if (difference.isNegative) {
        return "진행 중 또는 종료됨";
      }
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      return '$hours:$minutes:$seconds';
    } catch (e) {
      return "시간 계산 오류";
    }
  }

  void _deleteSchedule() {
    print(widget.schedule.id);
    ref.read(scheduleRepositoryProvider).deleteSchedule(widget.schedule.id!);
  }

  @override
  Widget build(BuildContext context) {
    final timeAsync = ref.watch(watchTimeProvider);

    final String statusText = timeAsync.when(
      data: (now) => _calculateRemainingTime(now, widget.schedule.startTime),
      loading: () => "계산 중...",
      error: (_, __) => "오류",
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // 이전 화면과 일치하는 배경색
        body: Hero(
          tag: 'content_${widget.schedule.id}', // 출발지와 동일한 태그
          child: Material(
              type: MaterialType.transparency,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.black.withValues(alpha: 1.0),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.schedule.title.toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'WantedSans',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _deleteSchedule,
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.white.withOpacity(0.5),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: Colors.yellowAccent.withValues(alpha: 0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeDisplay(
                                "START", _formatTime(_startTimeValue)),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white.withOpacity(0.1),
                              size: 16,
                            ),
                            _buildTimeDisplay("END", _formatTime(_endTimeValue)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            rangeThumbShape: const RoundRangeSliderThumbShape(
                              enabledThumbRadius: 1.0,
                              elevation: 0,
                            ),
                            overlayShape: SliderComponentShape.noOverlay,
                            activeTrackColor: const Color(0xFFFFB138),
                            inactiveTrackColor: Colors.white.withOpacity(0.05),
                            thumbColor: Colors.white,
                          ),
                          child: RangeSlider(
                            values: RangeValues(_startTimeValue, _endTimeValue),
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFFFB138).withOpacity(0.7),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24, // 리스트용으로 크기 조절
            fontWeight: FontWeight.w900,
            fontFamily: 'WantedSans',
          ),
        ),
      ],
    );
  }
}