import 'package:flutter/material.dart';

class ContentBuildTimeInfo extends StatelessWidget {
  final String label, time;

  const ContentBuildTimeInfo({
    super.key,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            fontFamily: 'WantedSans',
            letterSpacing: 1.5,
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
