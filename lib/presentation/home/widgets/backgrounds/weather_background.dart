import 'dart:math';
import 'package:flutter/material.dart';

enum WeatherType { clear, rainy, cloudy, snowy }

class WeatherBackground extends StatelessWidget {
  final WeatherType type;
  final Widget child;

  const WeatherBackground({super.key, required this.type, required this.child});

  @override
  Widget build(BuildContext context) {
    List<Color> bgColors;
    switch (type) {
      case WeatherType.clear:
        bgColors = [const Color(0xFF4FACFE), const Color(0xFF00F2FE)];
        break;
      case WeatherType.rainy:
        bgColors = [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)];
        break;
      case WeatherType.cloudy:
        bgColors = [const Color(0xFFD7D2CC), const Color(0xFF304352)];
        break;
      case WeatherType.snowy:
        bgColors = [const Color(0xFFE6E9F0), const Color(0xFFEEF1F5)];
        break;
    }

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgColors,
        ),
      ),
      child: Stack(
        children: [
          if (type == WeatherType.rainy) const WeatherEffectPainter(type: WeatherType.rainy),
          if (type == WeatherType.snowy) const WeatherEffectPainter(type: WeatherType.snowy),
          if (type == WeatherType.clear) _buildSunGlow(),
          child,
        ],
      ),
    );
  }

  Widget _buildSunGlow() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.2),
              blurRadius: 100,
              spreadRadius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherEffectPainter extends StatefulWidget {
  final WeatherType type;
  const WeatherEffectPainter({super.key, required this.type});

  @override
  State<WeatherEffectPainter> createState() => _WeatherEffectPainterState();
}

class _WeatherEffectPainterState extends State<WeatherEffectPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(widget.type, _controller.value),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final WeatherType type;
  final double progress;
  _ParticlePainter(this.type, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    final random = Random(42); // 일정한 패턴 유지

    for (int i = 0; i < 30; i++) {
      double x = random.nextDouble() * size.width;
      double y = (random.nextDouble() * size.height + (progress * size.height)) % size.height;

      if (type == WeatherType.rainy) {
        canvas.drawLine(Offset(x, y), Offset(x - 5, y + 15), paint..strokeWidth = 1.5);
      } else if (type == WeatherType.snowy) {
        canvas.drawCircle(Offset(x, y), random.nextDouble() * 3 + 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}