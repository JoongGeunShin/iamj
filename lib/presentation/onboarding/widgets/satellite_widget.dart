import 'package:flutter/material.dart';

class Satellite extends StatelessWidget {
  final int index;
  final bool done;
  final AnimationController pulseController;

  const Satellite({
    super.key,
    required this.index,
    required this.done,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    final Color themeColor =
        done ? Colors.greenAccent.shade700 : Colors.blueAccent;
    final Color rippleColor =
        done ? Colors.greenAccent : Colors.grey.shade300;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: pulseController,
          builder: (context, child) {
            return Container(
              width: 50 + (pulseController.value * 10),
              height: 50 + (pulseController.value * 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rippleColor.withOpacity(1.0 - pulseController.value),
                  width: 2,
                ),
              ),
            );
          },
        ),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: themeColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: themeColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ],
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

