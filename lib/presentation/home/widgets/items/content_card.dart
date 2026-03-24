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
      return ((hours * 60 + minutes) / (24 * 60)).clamp(0.0, 1.0);
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

  String _calculateRemainingTime(DateTime now, String startTimeStr, String endTimeStr) {
    try {
      final startParts = startTimeStr.split(':');
      final endParts = endTimeStr.split(':');

      final startTime = DateTime(now.year, now.month, now.day, int.parse(startParts[0]), int.parse(startParts[1]));
      final endTime = DateTime(now.year, now.month, now.day, int.parse(endParts[0]), int.parse(endParts[1]));

      if (now.isBefore(startTime)) {
        final difference = startTime.difference(now);
        final h = difference.inHours;
        final m = difference.inMinutes % 60;
        final s = difference.inSeconds % 60;
        return 'STARTS IN ${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      }
      if (now.isBefore(endTime)) {
        return "IN PROGRESS";
      }
      return "COMPLETED";
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
    if (widget.schedule.id != null) {
      ref.read(scheduleRepositoryProvider).deleteSchedule(widget.schedule.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeAsync = ref.watch(watchTimeProvider);
    final now = timeAsync.value ?? DateTime.now();
    final double nowValue = ((now.hour * 60 + now.minute) / (24 * 60)).clamp(0.0, 1.0);
    final String statusText = _calculateRemainingTime(now, widget.schedule.startTime, widget.schedule.endTime);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, anim, _) => ContentScreen(schedule: widget.schedule),
          transitionsBuilder: (context, anim, _, child) => FadeTransition(opacity: anim, child: child),
        ));
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
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D0D),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // 중요: 자식 크기만큼만 차지
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.schedule.title.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
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
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _deleteSchedule,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.close, color: Colors.white.withValues(alpha: 0.2), size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimeDisplay("START", _formatTime(_startTimeValue)),

                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          _buildTimeDisplay("END", _formatTime(_endTimeValue)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          double rangeWidth = (width * (_endTimeValue - _startTimeValue)).clamp(0.0, width);

                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 6,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Positioned(
                                    left: width * _startTimeValue,
                                    child: Container(
                                      height: 6,
                                      width: rangeWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(10),
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFFB138).withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _subText("00:00"),
                                  _subText("12:00"),
                                  _subText("24:00"),
                                ],
                              ),
                            ],
                          );
                        },
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
    style: const TextStyle(
      color: Color(0xFFFFB138),
      fontSize: 9,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildTimeDisplay(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFFFB138).withValues(alpha: 0.8),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
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