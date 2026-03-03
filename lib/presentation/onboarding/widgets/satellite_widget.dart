import 'package:flutter/material.dart';

class Satellite extends StatelessWidget {
  final int index;
  final bool done;
  final String imageDir;
  final VoidCallback onTap;
  final AnimationController pulseController;

  const Satellite({
    super.key,
    required this.index,
    required this.done,
    required this.pulseController,
    required this.imageDir,
    required this.onTap,
  });

  String get heroTag => 'onboarding-satellite-$imageDir';

  @override
  Widget build(BuildContext context) {
    // final String normalAssetPath = 'assets/icon/$imageDir.png';
    // final String fillAssetPath = 'assets/icon/${imageDir}_filled.png';
    final String assetPath = 'assets/icon/$imageDir.png';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Container(
                width: 100 + (pulseController.value * 10),
                height: 100 + (pulseController.value * 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 1.0 - pulseController.value),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Hero(
                  tag: heroTag,
                  placeholderBuilder: (context, heroSize, child) => SizedBox(
                    width: heroSize.width,
                    height: heroSize.height,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        if (done) {
                          return const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          );
                        }
                        return Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

