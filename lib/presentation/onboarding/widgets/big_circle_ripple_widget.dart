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
          width: orbitDiameter * (1 + pulseController.value * 0.2),
          height: orbitDiameter * (1 + pulseController.value * 0.2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue.withOpacity(1.0 - pulseController.value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}

