import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        return FadeTransition(opacity: anim1, child: ScaleTransition(scale: anim1, child: child));
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
  final TextEditingController _taskEntryController = TextEditingController();



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
    _taskEntryController.dispose();
    super.dispose();
  }

  void _updateTimeValue(bool isStart, {int? hours, int? minutes}) {
    setState(() {
      double change = 0;
      if (hours != null) change += hours / 24;
      if (minutes != null) change += minutes / (24 * 60);
      if (isStart) {
        double newValue = (_startValue + change).clamp(0.0, 1.0);
        if (newValue <= _endValue - 0.01) _startValue = newValue;
      } else {
        double newValue = (_endValue + change).clamp(0.0, 1.0);
        if (newValue >= _startValue + 0.01) _endValue = newValue;
      }
    });
  }

  String get _startTimeText => formatTimeFromDayFraction(_startValue);
  String get _endTimeText => formatTimeFromDayFraction(_endValue);
  String get _durationText => formatDurationFromDayFractions(startValue: _startValue, endValue: _endValue);

  Future<void> _onSave() async {
    final newSchedule = ScheduleState(
      title: _titleController.text.trim().isEmpty ? 'Untitled Schedule' : _titleController.text.trim(),
      memo: _memoController.text.trim(),
      tasks: _currentTasks,
      startTime: _startTimeText,
      endTime: _endTimeText,
      priority: 'Normal',
      isCompleted: false,
      isStared: false,
    );
    await ref.read(scheduleProvider.notifier).addSchedule(newSchedule);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(40), // 더 둥글게 트렌디하게
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddScheduleHeader(
                  durationText: _durationText,
                  onSpeechResult: (text) => _memoController.text = text,
                ),
                const SizedBox(height: 24),
                ScheduleDialogTextField(
                  controller: _titleController,
                  hintText: 'What is your goal?',
                  cursorColor: Colors.white,
                ),
                const SizedBox(height: 16),

                // --- Time Adjustment Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ScheduleTimeAdjustColumn(
                      label: "START",
                      timeText: _startTimeText,
                      onPlusHours: () => _updateTimeValue(true, hours: 1),
                      onPlusMinutes: () => _updateTimeValue(true, minutes: 1),
                      onMinusHours: () => _updateTimeValue(true, hours: -1),
                      onMinusMinutes: () => _updateTimeValue(true, minutes: -1),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.2), size: 24),
                    ScheduleTimeAdjustColumn(
                      label: "END",
                      timeText: _endTimeText,
                      onPlusHours: () => _updateTimeValue(false, hours: 1),
                      onPlusMinutes: () => _updateTimeValue(false, minutes: 1),
                      onMinusHours: () => _updateTimeValue(false, hours: -1),
                      onMinusMinutes: () => _updateTimeValue(false, minutes: -1),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ScheduleTimeRangeSlider(
                  startValue: _startValue,
                  endValue: _endValue,
                  onChanged: (values) => setState(() { _startValue = values.start; _endValue = values.end; }),
                ),
                const ScheduleTimeAxisLabels(),

                const SizedBox(height: 40),

                // --- AI TASK REVIEW SECTION ---
                _buildTaskSection(),

                const SizedBox(height: 24),

                // --- AI Analysis Memo & Trigger ---
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ScheduleDialogTextField(
                      controller: _memoController,
                      hintText: 'Describe your schedule details...',
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, right: 8),
                      child: _isAnalyzing
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFB138)))
                          : IconButton(
                        onPressed: _analyzeText,
                        icon: const Icon(Icons.auto_awesome, color: Color(0xFFFFB138)),
                        tooltip: "AI Analysis",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                AddScheduleActions(onCancel: () => Navigator.pop(context), onSave: _onSave),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 추가된 태스크 섹션 위젯 ---
  Widget _buildTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TASKS ${_currentTasks.isEmpty ? '' : '(${_currentTasks.length})'}",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
            if (_currentTasks.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _currentTasks.clear()),
                child: Text("CLEAR ALL", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_currentTasks.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
            ),
            child: Center(
              child: Text("No tasks generated yet.", style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 12)),
            ),
          )
        else
          ..._currentTasks.asMap().entries.map((entry) {
            int idx = entry.key;
            TaskItem task = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFFFB138), shape: BoxShape.circle)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(task.taskTitle, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _currentTasks.removeAt(idx)),
                    icon: Icon(Icons.close, color: Colors.white.withOpacity(0.2), size: 18),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Future<void> _analyzeText() async {
    final inputText = _memoController.text.trim();
    if (inputText.isEmpty) return;

    setState(() => _isAnalyzing = true);
    try {
      final analyzed = await ref.read(scheduleProvider.notifier).analyzeScheduleText(inputText);
      setState(() {
        _titleController.text = analyzed.title;
        _memoController.text = analyzed.memo;
        _currentTasks = analyzed.tasks;
        _startValue = dayFractionFromDateTime(DateTime.parse(analyzed.startTime));
        _endValue = dayFractionFromDateTime(DateTime.parse(analyzed.endTime));
      });
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }
}