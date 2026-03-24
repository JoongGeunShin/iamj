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
  late String _startTime, _endTime;
  late double _startTimeValue, _endTimeValue;

  @override
  void initState() {
    super.initState();
    _startTime = widget.schedule.startTime;
    _startTimeValue = _timeStringToDouble(_startTime);
    _endTime = widget.schedule.endTime;
    _endTimeValue = _timeStringToDouble(_endTime);
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

  double _calculateProgress(DateTime now, String startStr, String endStr) {
    final start = _timeToDateTime(now, startStr);
    final end = _timeToDateTime(now, endStr);
    if (now.isBefore(start)) return 0.0;
    if (now.isAfter(end)) return 1.0;
    final total = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  DateTime _timeToDateTime(DateTime now, String timeStr) {
    final parts = timeStr.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    final timeAsync = ref.watch(watchTimeProvider);
    final now = timeAsync.value ?? DateTime.now();
    final progress = _calculateProgress(now, _startTime, _endTime);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar (Modern Minimalist)
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Schedule Title (Huge Fintech Style)
                  Text(
                    "Balance of Time",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Hero(
                    tag: 'content_${widget.schedule.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.schedule.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'WantedSans',
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. Status Action Buttons (Image 1 Style)
                  Row(
                    children: [
                      _buildActionButton("Edit Task", const Color(0xFFFFB138), Colors.black),
                      const SizedBox(width: 12),
                      _buildActionButton("Complete", const Color(0xFF1A1A1A), Colors.white),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // 4. Progress Card
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D0D),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeInfo("START", _startTime),
                            _buildTimeInfo("END", _endTime),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Custom Progress Bar
                        Stack(
                          children: [
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB138),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: const Color(0xFFFFB138).withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${(progress * 100).toInt()}% COMPLETED",
                                style: const TextStyle(color: Color(0xFFFFB138), fontSize: 10, fontWeight: FontWeight.w900)),
                            Text(_getTimeRemainingText(now),
                                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TASKS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      Text("View History", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (widget.schedule.tasks.isEmpty)
                    _buildEmptyTask()
                  else
                    ...widget.schedule.tasks.map((task) => _buildTaskCard(task)).toList(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'WantedSans')),
      ],
    );
  }

  Widget _buildTaskCard(dynamic task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Color(0xFFFFB138), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              task.taskTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.1), size: 14),
        ],
      ),
    );
  }

  Widget _buildEmptyTask() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Center(
        child: Text("Focus on your main goal.", style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 14)),
      ),
    );
  }

  String _getTimeRemainingText(DateTime now) {
    final end = _timeToDateTime(now, _endTime);
    final diff = end.difference(now);
    if (diff.isNegative) return "ENDED";
    return "${diff.inHours}H ${diff.inMinutes % 60}M LEFT";
  }
}