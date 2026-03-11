import 'package:flutter/material.dart';

class ScheduleTimeAxisLabels extends StatelessWidget {
  const ScheduleTimeAxisLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("00:00", style: TextStyle(color: Colors.white, fontSize: 10)),
          Text("12:00", style: TextStyle(color: Colors.white, fontSize: 10)),
          Text("24:00", style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}

