import 'dart:math';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 현재 진행 중인 단계 (0, 1, 2...)
  int currentStep = 0;
  // 각 단계의 완료 여부
  List<bool> isCompleted = [false, false, false];
  final int totalSteps = 3;

  @override
  void initState() {
    super.initState();
    // 천천히 회전하는 애니메이션
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 설정 페이지로 이동 후 돌아오면 상태 업데이트
  void _navigateToSetup() async {
    if (currentStep >= totalSteps) return;

    // TODO: 실제 설정 페이지로 Navigator.push
    // final result = await Navigator.push(context, ...);

    // 예시를 위해 1초 후 완료된 것으로 가정
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      isCompleted[currentStep] = true;
      if (currentStep < totalSteps - 1) {
        currentStep++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _navigateToSetup,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. 큰 원 (궤도)
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black12, width: 2),
                ),
              ),

              // 2. 중앙 문구
              const Text(
                'IamJ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // 3. 회전하는 파란 원들
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    children: List.generate(totalSteps, (index) {
                      // 각 원의 각도 계산 (회전 애니메이션 포함)
                      double angle = (index * (2 * pi / totalSteps)) + (_controller.value * 2 * pi);
                      double radius = 125.0; // 큰 원의 반지름

                      return Transform.translate(
                        offset: Offset(
                          radius * cos(angle),
                          radius * sin(angle),
                        ),
                        child: _buildStepCircle(index),
                      );
                    }),
                  );
                },
              ),

              // 하단 안내 메시지
              Positioned(
                bottom: 100,
                child: Text(
                  currentStep < totalSteps
                      ? "화면을 탭하여 ${currentStep + 1}번째 단계를 설정하세요"
                      : "모든 설정이 완료되었습니다!",
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 각 단계별 파란 원 위젯
  Widget _buildStepCircle(int index) {
    bool done = isCompleted[index];
    bool isCurrent = index == currentStep;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: done ? Colors.blue.shade700 : Colors.blue.shade300,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
        border: isCurrent
            ? Border.all(color: Colors.orange, width: 3) // 현재 단계 강조
            : null,
      ),
      child: Center(
        child: done
            ? const Icon(Icons.check, color: Colors.white)
            : Text(
          "${index + 1}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}