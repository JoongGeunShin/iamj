import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class DraggableFab extends StatefulWidget {
  final Offset position;
  final ValueChanged<Offset> onPositionChanged;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final IconData iconData;

  const DraggableFab({
    super.key,
    required this.position,
    required this.onPositionChanged,
    required this.onPressed,
    this.onLongPress,
    this.iconData = Icons.question_mark,
  });

  @override
  State<DraggableFab> createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: widget.position.dx,
      bottom: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double verticalMove = sin(_controller.value * 2 * pi) * 6;
          double auraScale = 1.0 + (sin(_controller.value * 2 * pi).abs() * 0.15);
          double lightX = cos(_controller.value * 2 * pi) * 0.15 - 0.2;
          double lightY = sin(_controller.value * 2 * pi) * 0.15 - 0.3;

          return Transform.translate(
            offset: Offset(0, verticalMove),
            child: GestureDetector(
              onPanUpdate: (details) => widget.onPositionChanged(details.delta),
              onTap: widget.onPressed,
              onLongPress: widget.onLongPress,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 65 * auraScale,
                    height: 65 * auraScale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: Alignment(lightX, lightY),
                                  colors: [
                                    Colors.white.withValues(alpha: 0.5),
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.black.withValues(alpha: 0.1),
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 14,
                              child: Container(
                                width: 32,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.6),
                                      Colors.white.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onPressed,
                                onLongPress: widget.onLongPress,
                                child: Center(
                                  child: Icon(
                                    widget.iconData,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 28,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}