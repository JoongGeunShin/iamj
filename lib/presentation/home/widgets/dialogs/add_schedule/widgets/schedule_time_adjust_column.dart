import 'package:flutter/material.dart';

import 'schedule_time_adjust_controls.dart';
import 'schedule_time_text_column.dart';

class ScheduleTimeAdjustColumn extends StatelessWidget {
  const ScheduleTimeAdjustColumn({
    super.key,
    required this.label,
    required this.timeText,
    required this.onPlusHours,
    required this.onPlusMinutes,
    required this.onMinusHours,
    required this.onMinusMinutes,
  });

  final String label;
  final String timeText;
  final VoidCallback onPlusHours;
  final VoidCallback onPlusMinutes;
  final VoidCallback onMinusHours;
  final VoidCallback onMinusMinutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScheduleTimeAdjustControls(
          isPlus: true,
          onAdjustHours: onPlusHours,
          onAdjustMinutes: onPlusMinutes,
        ),
        ScheduleTimeTextColumn(label: label, time: timeText),
        ScheduleTimeAdjustControls(
          isPlus: false,
          onAdjustHours: onMinusHours,
          onAdjustMinutes: onMinusMinutes,
        ),
      ],
    );
  }
}

