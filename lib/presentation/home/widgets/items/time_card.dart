import 'package:flutter/material.dart';

class TimeCard extends StatefulWidget {
  const TimeCard({super.key, required this.now});

  final DateTime now;

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _weekdayKo(int weekday) {
    return ['MON', 'TEW', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final timeText =
        '${_twoDigits(widget.now.hour)}:${_twoDigits(widget.now.minute)}:${_twoDigits(widget.now.second)}';
    final dateText =
        '${widget.now.year}.${_twoDigits(widget.now.month)}.${_twoDigits(widget.now.day)} (${_weekdayKo(widget.now.weekday)})';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 1.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24), // 좀 더 둥글게 수정
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedText(
                  timeText,
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'WantedSans',
                    letterSpacing: 0.5,
                  ),
                  0.3,
                ),
                const SizedBox(height: 6),
                _buildAnimatedText(
                  dateText,
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'WantedSans',
                  ),
                  0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(
    String text,
    TextStyle? style,
    double startInterval,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Interval(startInterval, 1.0, curve: Curves.easeIn),
      ),
      child: Text(text, style: style),
    );
  }
}
