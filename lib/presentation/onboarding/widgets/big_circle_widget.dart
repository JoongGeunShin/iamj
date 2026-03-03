import 'package:flutter/material.dart';

class BigCircleRipple extends StatelessWidget {
  final AnimationController pulseController;
  final double orbitDiameter;

  const BigCircleRipple({
    super.key,
    required this.pulseController,
    required this.orbitDiameter,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Container(
          width: orbitDiameter,
          height: orbitDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 1-pulseController.value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}

