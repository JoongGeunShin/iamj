import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/presentation/content/widgets/content_app_bar.dart';
import 'package:iamj/presentation/content/widgets/items/content_empty_task_card.dart';
import 'package:iamj/presentation/content/widgets/items/content_progress_card.dart';
import 'package:iamj/presentation/content/widgets/items/content_task_card.dart';

import '../../../data/repositories/clock_repository_provider.dart';
import '../../../data/repositories/schedule_repository_provider.dart';
import '../../../domain/entities/schedule_state.dart';
import '../widgets/buttons/content_action_button.dart';

class ContentScreen extends ConsumerStatefulWidget {
  final ScheduleState schedule;

  const ContentScreen({super.key, required this.schedule});

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
  late String _startTime, _endTime;
  late double _startTimeValue, _endTimeValue;

  @override
  void initState() {
    super.initState();
    _startTime = widget.schedule.startTime;
    _endTime = widget.schedule.endTime;
  }

  @override
  Widget build(BuildContext context) {
    final timeAsync = ref.watch(watchTimeProvider);
    final scheduleAsync = ref.watch(scheduleRepositoryProvider);
    final now = timeAsync.value ?? DateTime.now();
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          ContentAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance of Time",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Hero(
                    tag: 'content_${widget.schedule.id}',
                    flightShuttleBuilder: (
                        flightContext,
                        animation,
                        flightDirection,
                        fromHeroContext,
                        toHeroContext,
                        ) {
                      return DefaultTextStyle(
                        style: DefaultTextStyle.of(toHeroContext).style,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Material(
                            type: MaterialType.transparency,
                            child: toHeroContext.widget,
                          ),
                        ),
                      );
                    },
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.schedule.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'WantedSans',
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: ContentActionButton(
                          label: "Complete Schedule",
                          bgColor: const Color(0xFFFFB138),
                          textColor: Colors.black,
                          onTap: () async {
                            await ref
                                .read(scheduleRepositoryProvider)
                                .updateSchedule(
                              widget.schedule.copyWith(isCompleted: true),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ContentActionButton(
                          label: "Restart Schedule",
                          bgColor: const Color(0xFF1A1A1A),
                          textColor: Colors.white,
                          onTap: () async {
                            await ref
                                .read(scheduleRepositoryProvider)
                                .updateSchedule(
                              widget.schedule.copyWith(isCompleted: false),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  ContentProgressCard(
                    startTime: _startTime,
                    endTime: _endTime,
                    now: now,
                  ),
                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TASKS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'WantedSans'
                        ),
                      ),
                      Text(
                        "View History",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (widget.schedule.tasks.isEmpty)
                    const EmptyTaskCard()
                  else
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.schedule.tasks.length,
                      proxyDecorator: (Widget child, int index, Animation<double> animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            final double animValue = Curves.easeInOut.transform(animation.value);
                            final double elevationAngle = animValue * 0.035;

                            return Material(
                              color: Colors.transparent,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..scale(1 + (0.05 * animValue))
                                  ..rotateZ(elevationAngle),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: Color.lerp(
                                          Colors.white.withValues(alpha: 0.1),
                                          const Color(0xFFFFB138).withValues(alpha: 0.8),
                                          animValue
                                      )!,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: animValue * 0.4),
                                        blurRadius: 20 * animValue,
                                        offset: Offset(0, 10 * animValue),
                                        spreadRadius: 2 * animValue,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFFFFB138).withValues(alpha: animValue * 0.15),
                                        blurRadius: 30 * animValue,
                                        spreadRadius: 5 * animValue,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Container(
                                      color: const Color(0xFF0D0D0D).withValues(alpha: animValue * 0.1),
                                      child: child,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: child,
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) newIndex -= 1;
                          final task = widget.schedule.tasks.removeAt(oldIndex);
                          widget.schedule.tasks.insert(newIndex, task);
                        });
                      },
                      itemBuilder: (context, index) {
                        final task = widget.schedule.tasks[index];

                        return ContentTaskCard(
                          key: ValueKey('${task.taskTitle}_$index'),
                          task: task,
                          index: index,
                          onDelete: () {
                            setState(() => widget.schedule.tasks.removeAt(index));
                          },
                          onEdit: () {
                            // 수정 dialog 만들어야됨
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
