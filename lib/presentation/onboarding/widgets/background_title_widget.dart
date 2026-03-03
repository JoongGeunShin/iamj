import 'package:flutter/material.dart';

class BackgroundTitleWidget extends StatelessWidget {
  final String title;
  final double top;
  final double left;

  const BackgroundTitleWidget({
    super.key,
    this.title = 'IamJ',
    this.top = 0,
    this.left = -60,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: RotatedBox(
        quarterTurns: 1,
        child: Text(
          'IamJ',
          style: TextStyle(
            fontSize: 170,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
