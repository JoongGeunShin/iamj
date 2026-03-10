import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/data/repositories/schedule_repository_provider.dart';
import 'package:iamj/domain/entities/schedule_state.dart';

class ContentCard extends ConsumerStatefulWidget {
  final ScheduleState schedule; // 데이터 주입

  const ContentCard({super.key, required this.schedule});

  @override
  ConsumerState<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends ConsumerState<ContentCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late double _startValue;
  late double _endValue;

  @override
  void initState() {
    super.initState();
    // 시간 문자열(HH:mm)을 Slider용 double(0.0~1.0)로 변환
    _startValue = _timeStringToDouble(widget.schedule.startTime);
    _endValue = _timeStringToDouble(widget.schedule.endTime);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // 리스트에 나타날 때 애니메이션
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  // 헬퍼: "08:30" -> 0.354...
  double _timeStringToDouble(String time) {
    try {
      final parts = time.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      return (hours * 60 + minutes) / (24 * 60);
    } catch (e) {
      return 0.0;
    }
  }

  String _formatTime(double value) {
    int totalMinutes = (value * 24 * 60).toInt();
    int hours = (totalMinutes ~/ 60).clamp(0, 23);
    int minutes = (totalMinutes % 60).clamp(0, 59);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _deleteSchedule(){
    print(widget.schedule.id);
    ref.read(scheduleRepositoryProvider).deleteSchedule(widget.schedule.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4, height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB138),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.schedule.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: _deleteSchedule, icon: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.5), size: 20))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeDisplay("START", _formatTime(_startValue)),
                    Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.1), size: 16),
                    _buildTimeDisplay("END", _formatTime(_endValue)),
                  ],
                ),
                const SizedBox(height: 24),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    // 0 대신 아주 작은 값을 주거나,
                    // 혹은 투명한 색상을 사용하는 것이 안전합니다.
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 1.0, // 0 대신 최소한의 크기를 줌
                      elevation: 0,
                    ),
                    overlayShape: SliderComponentShape.noOverlay,
                    activeTrackColor: const Color(0xFFFFB138),
                    inactiveTrackColor: Colors.white.withOpacity(0.05),
                    // 손잡이를 안 보이게 하려면 색상을 투명하게 만듭니다.
                    thumbColor: Colors.transparent,
                  ),
                  child: RangeSlider(
                    values: RangeValues(_startValue, _endValue),
                    onChanged: null, // null로 두면 비활성화 상태가 되어 어차피 투명하게 보입니다.
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFFFB138).withOpacity(0.7),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24, // 리스트용으로 크기 조절
            fontWeight: FontWeight.w900,
            fontFamily: 'WantedSans',
          ),
        ),
      ],
    );
  }
}