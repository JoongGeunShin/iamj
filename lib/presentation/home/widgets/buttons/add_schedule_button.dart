import 'package:flutter/material.dart';

class AddScheduleButton extends StatelessWidget {
  final VoidCallback onTab;

  const AddScheduleButton({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTab,
      icon: Icon(Icons.add_circle_rounded, size: 36),
    );
  }
}
