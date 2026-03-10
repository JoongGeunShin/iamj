import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/schedule_repository_provider.dart';
import '../../../../domain/entities/schedule_state.dart';

class AddScheduleDialog extends ConsumerStatefulWidget {
  const AddScheduleDialog({super.key, required this.now});

  final DateTime now;

  static Future<void> show(BuildContext context, DateTime now) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => AddScheduleDialog(now: now),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }

  @override
  ConsumerState<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends ConsumerState<AddScheduleDialog> {
  late double _startValue;
  late double _endValue;

  @override
  void initState() {
    super.initState();
    double nowValue = (widget.now.hour * 60 + widget.now.minute) / (24 * 60);
    _startValue = nowValue;
    _endValue = (nowValue + 0.0416).clamp(0.0, 1.0);
  }

  // 시간 조절 로직 (0.0 ~ 1.0 범위 계산)
  void _updateTimeValue(bool isStart, {int? hours, int? minutes}) {
    setState(() {
      double change = 0;
      if (hours != null) change += hours / 24;
      if (minutes != null) change += minutes / (24 * 60);

      if (isStart) {
        double newValue = (_startValue + change).clamp(0.0, 1.0);
        if (newValue <= _endValue - 0.01) {
          _startValue = newValue;
        }
      } else {
        double newValue = (_endValue + change).clamp(0.0, 1.0);
        if (newValue >= _startValue + 0.01) {
          _endValue = newValue;
        }
      }
    });
  }

  String _formatTime(double value) {
    int totalMinutes = (value * 24 * 60).toInt();
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    if (hours >= 24) hours = 23;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String _getDuration() {
    int diffMinutes = ((_endValue - _startValue) * 24 * 60).toInt();
    int h = diffMinutes ~/ 60;
    int m = diffMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  Future<void> _onSave() async {
    final newSchedule = ScheduleState(
      title: '',
      memo: '',
      startTime: _formatTime(_startValue),
      endTime: _formatTime(_endValue),
      priority: 'Normal',
      isCompleted: false,
      isStared: false,
    );
    await ref.read(scheduleProvider.notifier).addSchedule(newSchedule);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "ADD SCHEDULE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'WantedSans',
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB138),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getDuration(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _buildAdjustRow(isStart: true, isPlus: true),
                    _timeTextColumn("START", _formatTime(_startValue)),
                    _buildAdjustRow(isStart: true, isPlus: false),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 24,
                ),
                Column(
                  children: [
                    _buildAdjustRow(isStart: false, isPlus: true),
                    _timeTextColumn("END", _formatTime(_endValue)),
                    _buildAdjustRow(isStart: false, isPlus: false),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 12,
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 15,
                  elevation: 0,
                ),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
                thumbColor: Colors.white,
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
              ),
              child: RangeSlider(
                values: RangeValues(_startValue, _endValue),
                onChanged: (values) {
                  if (values.end - values.start >= 0.01) {
                    setState(() {
                      _startValue = values.start;
                      _endValue = values.end;
                    });
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "00:00",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Text(
                    "12:00",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Text(
                    "24:00",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Colors.white38,
                        fontFamily: 'WantedSans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onSave(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'WantedSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustRow({required bool isStart, required bool isPlus}) {
    int factor = isPlus ? 1 : -1;
    String sign = isPlus ? "+" : "-";
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _smallBtn(
          "${sign}1h",
          () => _updateTimeValue(isStart, hours: factor),
          sign,
        ),
        _smallBtn(
          "${sign}1m",
          () => _updateTimeValue(isStart, minutes: factor * 1),
          sign,
        ),
      ],
    );
  }

  Widget _smallBtn(String label, VoidCallback onTap, String sign) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: sign == '+' ? Colors.green : Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _timeTextColumn(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontFamily: 'WantedSans',
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}
