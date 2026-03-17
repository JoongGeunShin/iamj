import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/data/repositories/clock_repository_provider.dart';
import 'package:iamj/data/repositories/geolocation_provider.dart';
import 'package:iamj/data/repositories/lock_repository_provider.dart';
import 'package:iamj/data/repositories/onboarding_repository_provider.dart';
import 'package:iamj/data/repositories/schedule_repository_provider.dart';
import 'package:iamj/data/repositories/weather_repository_provider.dart';
import 'package:iamj/domain/entities/weather_state.dart';
import 'package:iamj/presentation/home/widgets/backgrounds/weather_background.dart';
import 'package:iamj/presentation/home/widgets/buttons/add_schedule_button.dart';
import 'package:iamj/presentation/home/widgets/dialogs/add_schedule_dialog.dart';
import 'package:iamj/presentation/home/widgets/dialogs/lock_dialog.dart';
import 'package:iamj/presentation/home/widgets/items/content_card.dart';
import 'package:iamj/presentation/home/widgets/items/time_card.dart';
import '../../../domain/entities/schedule_state.dart';
import '../widgets/buttons/draggable_fab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Offset _fabPosition = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    // 1. 상태 및 노티파이어 구독 (Domain Logic Interface)
    final lockState = ref.watch(lockStateProvider);
    final isLocked = lockState.lockState;
    final lockNotifier = ref.read(lockStateProvider.notifier);

    // 2. 비동기 데이터 구독
    final timeAsync = ref.watch(watchTimeProvider);
    final purposeAsync = ref.watch(savedUserPurposeProvider);
    final gridAsync = ref.watch(currentGridProvider);
    final scheduleAsync = ref.watch(scheduleListStreamProvider);

    // 3. 위치 → 격자 → 날씨 타입 계산
    final weatherType = gridAsync.when<WeatherType>(
      data: (grid) {
        final weatherAsync = ref.watch(
          watchWeatherProvider(nx: grid.nx, ny: grid.ny),
        );
        return weatherAsync.maybeWhen(
          data: (weather) => weather.type,
          orElse: () => WeatherType.clear,
        );
      },
      loading: () => WeatherType.clear,
      error: (_, __) => WeatherType.clear,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WeatherBackground(
        type: weatherType,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // [레이어 1] 메인 콘텐츠 레이어 (상태에 따라 터치 차단)
                IgnorePointer(
                  ignoring: isLocked,
                  child: _buildMainBody(
                    timeAsync,
                    purposeAsync,
                    gridAsync,
                    scheduleAsync,
                  ),
                ),

                // [레이어 2] 잠금 전용 인터랙션 레이어 (잠금 시에만 활성화)
                if (isLocked) _buildLockOverlay(context),

                // [레이어 3] 조작 레이어 (최상단)
                DraggableFab(
                  position: _fabPosition,
                  onPositionChanged: isLocked ? (_) {} : _updateFabPosition,
                  onPressed: () =>
                      _handleFabPressed(context, isLocked, lockNotifier),
                  onLongPress: isLocked
                      ? () => _handleUnlock(context, lockNotifier)
                      : null,
                  iconData: isLocked ? Icons.lock : Icons.lock_outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainBody(
    AsyncValue timeAsync,
    AsyncValue purposeAsync,
    AsyncValue gridAsync,
    AsyncValue<List<ScheduleState>> scheduleAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. 고정 상단 영역 (시간 카드)
        timeAsync.when(
          data: (now) => TimeCard(now: now),
          loading: () => const SizedBox(height: 100),
          error: (err, _) => Center(child: Text('time load err: $err')),
        ),
        const SizedBox(height: 18),

        Expanded(
          child: scheduleAsync.when(
            data: (schedules) => ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              physics: const BouncingScrollPhysics(),
              itemCount: schedules.length + 1,
              itemBuilder: (context, index) {
                if (index == schedules.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AddScheduleButton(
                      onTab: () {
                        final DateTime now = timeAsync.value ?? DateTime.now();
                        AddScheduleDialog.show(context, now);
                      },
                    ),
                  );
                }
                // 일정 카드
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ContentCard(schedule: schedules[index], ),
                );
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (err, _) => Center(
              child: Text(
                'Schedule error: $err',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        // 위치 오류 메시지 등이 있을 경우 하단 표시
        if (gridAsync.hasError) _buildErrorMessage(gridAsync.error.toString()),
      ],
    );
  }

  Widget _buildLockOverlay(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'PAGE IS LOCKED\n LONG PRESS THE LOCK BUTTON TO UNLOCK',
              ),
              duration: Duration(milliseconds: 1000),
            ),
          );
        },
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '위치/날씨 로드 오류: $message',
        style: const TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _updateFabPosition(Offset delta) {
    setState(() {
      final size = MediaQuery.of(context).size;
      final padding = MediaQuery.of(context).padding;
      const double fabSize = 80.0;

      _fabPosition = Offset(
        (_fabPosition.dx - delta.dx).clamp(0.0, size.width - fabSize),
        (_fabPosition.dy - delta.dy).clamp(
          0.0,
          size.height - fabSize - padding.top - padding.bottom,
        ),
      );
    });
  }

  Future<void> _handleFabPressed(
    BuildContext context,
    bool isLocked,
    dynamic lockNotifier,
  ) async {
    if (isLocked) return;
    final bool? result = await LockDialog.showLockDialog(context);
    if (result == true) {
      await lockNotifier.lock();
    }
  }

  void _handleUnlock(BuildContext context, dynamic lockNotifier) {
    lockNotifier.unlock();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('PAGE IS UNLOCKED')));
  }
}
