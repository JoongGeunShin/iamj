import 'package:flutter/material.dart';
import 'package:iamj/presentation/content/widgets/builders/content_build_time_info.dart';

import '../../../common/utils/time_utils.dart';

class ContentProgressCard extends StatelessWidget {
  final String startTime, endTime;
  final DateTime now;

  const ContentProgressCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final progress = TimeUtils.calculateProgress(now, startTime, endTime);
    final remainingText = TimeUtils.getTimeRemainingText(now, endTime);
    return Container(
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
              ContentBuildTimeInfo(label: "START", time: startTime),
              ContentBuildTimeInfo(label: "END", time: endTime),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
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
                      BoxShadow(
                        color: const Color(0xFFFFB138).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
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
              Text(
                "${(progress * 100).toInt()}% IN PROGRESS",
                style: const TextStyle(
                  color: Color(0xFFFFB138),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                remainingText,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
