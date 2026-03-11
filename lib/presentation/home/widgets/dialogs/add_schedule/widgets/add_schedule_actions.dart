import 'package:flutter/material.dart';

class AddScheduleActions extends StatelessWidget {
  const AddScheduleActions({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel,
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
            onPressed: onSave,
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
    );
  }
}

