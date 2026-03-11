import 'package:flutter/material.dart';

class ScheduleTimeAdjustControls extends StatelessWidget {
  const ScheduleTimeAdjustControls({
    super.key,
    required this.isPlus,
    required this.onAdjustHours,
    required this.onAdjustMinutes,
  });

  final bool isPlus;
  final VoidCallback onAdjustHours;
  final VoidCallback onAdjustMinutes;

  @override
  Widget build(BuildContext context) {
    final sign = isPlus ? "+" : "-";
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SmallAdjustBtn(
          label: "${sign}1h",
          onTap: onAdjustHours,
          isPlus: isPlus,
        ),
        _SmallAdjustBtn(
          label: "${sign}1m",
          onTap: onAdjustMinutes,
          isPlus: isPlus,
        ),
      ],
    );
  }
}

class _SmallAdjustBtn extends StatelessWidget {
  const _SmallAdjustBtn({
    required this.label,
    required this.onTap,
    required this.isPlus,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPlus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: isPlus ? Colors.green : Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

