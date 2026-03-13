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

  late String _title, _memo, _startTime, _endTime, _priority;
  late bool _isCompleted, _isStared;

  late double _startTimeValue, _endTimeValue;

  @override
  void initState() {
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
    return '${hours.toString().padLeft(2, '00')}:${minutes.toString().padLeft(2, '00')}';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _deleteSchedule() {
    print(widget.schedule.id);
    ref.read(scheduleRepositoryProvider).deleteSchedule(widget.schedule.id!);
  }

  @override
  Widget build(BuildContext context) {
    final timeAsync = ref.watch(watchTimeProvider);

    // 2. 남은 시간 텍스트 결정
    final String statusText = timeAsync.when(
      data: (now) => _calculateRemainingTime(now, widget.schedule.startTime),
      loading: () => "계산 중...",
      error: (_, __) => "오류",
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryAnimation) {
              return ContentScreen(schedule: widget.schedule);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
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
                            width: MediaQuery.of(context).size.width * 0.6,
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
                          color: const Color(0xFFFFB138).withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimeDisplay(
                            "START",
                            _formatTime(_startTimeValue),
                          ),
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
                          trackHeight: 12,
                          rangeThumbShape: const RoundRangeSliderThumbShape(
                            enabledThumbRadius: 1.0,
                            elevation: 0,
                          ),
                          overlayShape: SliderComponentShape.noThumb,
                          activeTrackColor: const Color(0xFFFFB138),
                          inactiveTrackColor: Colors.white,
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
              ),
            ),
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
            fontSize: 24,
            fontWeight: FontWeight.w900,
            fontFamily: 'WantedSans',
          ),
        ),
      ],
    );
  }
}
