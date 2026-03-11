import 'package:flutter/material.dart';

class ScheduleTimeRangeSlider extends StatelessWidget {
  const ScheduleTimeRangeSlider({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.onChanged,
    this.minGap = 0.01,
  });

  final double startValue;
  final double endValue;
  final ValueChanged<RangeValues> onChanged;
  final double minGap;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 12,
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 8,
          elevation: 0,
        ),
        activeTrackColor: Colors.white,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
        thumbColor: Colors.white,
        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
      ),
      child: RangeSlider(
        values: RangeValues(startValue, endValue),
        onChanged: (values) {
          if (values.end - values.start >= minGap) {
            onChanged(values);
          }
        },
      ),
    );
  }
}

