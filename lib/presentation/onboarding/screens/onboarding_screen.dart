import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iamj/presentation/onboarding/widgets/logo_image_widget.dart';
import '../widgets/big_circle_ripple_widget.dart';
import '../widgets/satellite_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  int currentStep = 0;
  List<bool> isCompleted = [false, false, false];
  final int totalSteps = 3;
  final double orbitRadius = 120.0;
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onScreenTapped() {
    if (currentStep < totalSteps) {
      setState(() {
        isCompleted[currentStep] = true;
        if (currentStep < totalSteps - 1) currentStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _onScreenTapped,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: LogoImageWidget(),
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    BigCircleRipple(
                      pulseController: _pulseController,
                      orbitDiameter: orbitRadius * 2,
                    ),
                    const Text(
                      'Setup First',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: Colors.black87,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: List.generate(totalSteps, (index) {
                            double angle = (index * (2 * pi / totalSteps)) +
                                (_rotationController.value * 2 * pi);

                            return Transform.translate(
                              offset: Offset(
                                orbitRadius * cos(angle),
                                orbitRadius * sin(angle),
                              ),
                              child: Satellite(
                                index: index,
                                done: isCompleted[index],
                                pulseController: _pulseController,
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}