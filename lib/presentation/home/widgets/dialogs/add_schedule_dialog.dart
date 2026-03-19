import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/presentation/common/widgets/buttons/speech_button.dart';

import '../../../../data/repositories/schedule_repository_provider.dart';
import '../../../../domain/entities/schedule_state.dart';
import 'add_schedule/add_schedule_time_utils.dart';
import 'add_schedule/widgets/add_schedule_actions.dart';
import 'add_schedule/widgets/add_schedule_header.dart';
import 'add_schedule/widgets/schedule_dialog_text_field.dart';
import 'add_schedule/widgets/schedule_time_adjust_column.dart';
import 'add_schedule/widgets/schedule_time_axis_labels.dart';
import 'add_schedule/widgets/schedule_time_range_slider.dart';

class AddScheduleDialog extends ConsumerStatefulWidget {
  const AddScheduleDialog({super.key, required this.now});

  final DateTime now;

  static Future<void> show(BuildContext context, DateTime now) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => AddScheduleDialog(now: now),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }

  @override
  ConsumerState<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends ConsumerState<AddScheduleDialog> {
  late double _startValue;
  late double _endValue;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  List<TaskItem> _currentTasks = [];

  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    final nowValue = dayFractionFromDateTime(widget.now);
    _startValue = nowValue;
    _endValue = (nowValue + 0.0416).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _updateTimeValue(bool isStart, {int? hours, int? minutes}) {
    setState(() {
      double change = 0;
      if (hours != null) change += hours / 24;
      if (minutes != null) change += minutes / (24 * 60);

      if (isStart) {
        double newValue = (_startValue + change).clamp(0.0, 1.0);
        if (newValue <= _endValue - 0.01) {
          _startValue = newValue;
        }
      } else {
        double newValue = (_endValue + change).clamp(0.0, 1.0);
        if (newValue >= _startValue + 0.01) {
          _endValue = newValue;
        }
      }
    });
  }

  String get _startTimeText => formatTimeFromDayFraction(_startValue);

  String get _endTimeText => formatTimeFromDayFraction(_endValue);

  String get _durationText => formatDurationFromDayFractions(
    startValue: _startValue,
    endValue: _endValue,
  );

  Future<void> _onSave() async {
    final newSchedule = ScheduleState(
      title: _titleController.text.trim().isEmpty
          ? 'non specified schedule'
          : _titleController.text.trim(),
      memo: _memoController.text.trim(),
      tasks: _currentTasks, // 수정: 보관 중인 tasks 리스트를 전달
      startTime: _startTimeText,
      endTime: _endTimeText,
      priority: 'Normal',
      isCompleted: false,
      isStared: false,
    );

    await ref.read(scheduleProvider.notifier).addSchedule(newSchedule);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddScheduleHeader(
                  durationText: _durationText,
                  onSpeechResult: (text) {
                    _memoController.text = text;
                  },
                ),
                const SizedBox(height: 24),
                ScheduleDialogTextField(
                  controller: _titleController,
                  hintText: 'Title',
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ScheduleTimeAdjustColumn(
                      label: "START",
                      timeText: _startTimeText,
                      onPlusHours: () => _updateTimeValue(true, hours: 1),
                      onPlusMinutes: () => _updateTimeValue(true, minutes: 1),
                      onMinusHours: () => _updateTimeValue(true, hours: -1),
                      onMinusMinutes: () => _updateTimeValue(true, minutes: -1),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 24,
                    ),
                    ScheduleTimeAdjustColumn(
                      label: "END",
                      timeText: _endTimeText,
                      onPlusHours: () => _updateTimeValue(false, hours: 1),
                      onPlusMinutes: () => _updateTimeValue(false, minutes: 1),
                      onMinusHours: () => _updateTimeValue(false, hours: -1),
                      onMinusMinutes: () =>
                          _updateTimeValue(false, minutes: -1),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ScheduleTimeRangeSlider(
                  startValue: _startValue,
                  endValue: _endValue,
                  onChanged: (values) {
                    setState(() {
                      _startValue = values.start;
                      _endValue = values.end;
                    });
                  },
                ),
                const ScheduleTimeAxisLabels(),
                const SizedBox(height: 48),
                Container(
                  alignment: Alignment.bottomRight,
                  child: _isAnalyzing
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : IconButton(
                    onPressed: () async {
                      final inputText = _memoController.text.trim();
                      if (inputText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("you need to write at least your goal")),
                        );
                        return;
                      }

                      setState(() => _isAnalyzing = true); // 로딩 시작

                      try {
                        final analyzed = await ref
                            .read(scheduleProvider.notifier)
                            .analyzeScheduleText(inputText);

                        setState(() {
                          _titleController.text = analyzed.title;
                          _memoController.text = analyzed.memo;
                          _currentTasks = analyzed.tasks;

                          final startDT = DateTime.parse(analyzed.startTime);
                          final endDT = DateTime.parse(analyzed.endTime);
                          _startValue = dayFractionFromDateTime(startDT);
                          _endValue = dayFractionFromDateTime(endDT);
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("AI가 일정을 분석하여 채워넣었습니다!")),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("분석 실패: $e")),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isAnalyzing = false); // 로딩 종료 (성공/실패 상관없이)
                        }
                      }
                    },
                    icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  ),
                ),
                ScheduleDialogTextField(
                  controller: _memoController,
                  hintText: 'Memo',
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),

                const SizedBox(height: 24),
                AddScheduleActions(
                  onCancel: () => Navigator.pop(context),
                  onSave: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
