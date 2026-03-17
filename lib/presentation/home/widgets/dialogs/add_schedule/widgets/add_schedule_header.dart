import 'package:flutter/material.dart';

import '../../../../../common/widgets/buttons/speech_button.dart';

class AddScheduleHeader extends StatelessWidget {
  const AddScheduleHeader({
    super.key,
    required this.durationText,
    required this.onSpeechResult,
  });

  final String durationText;
  final Function(String) onSpeechResult;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Row(
          children: [
            SpeechButton(
              onResult: onSpeechResult,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB138),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                durationText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
