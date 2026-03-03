import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iamj/presentation/onboarding/widgets/background_title_widget.dart';
import 'package:iamj/presentation/onboarding/screens/onboarding_hero_detail_screen.dart';
import '../widgets/big_circle_widget.dart';
import '../widgets/onboarding_bottom_sheet.dart';
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
  late AnimationController _fadeController;

  List<bool> isSelected = [false, false, false];
  late final List<bool> _isPushing;
  List<String> satelliteImages = ['exercise', 'study', 'yoga'];
  final int totalSteps = 3;
  final double orbitRadius = 120.0;
  final double _satelliteTapDiameter = 120.0;

  @override
  void initState() {
    super.initState();
    _isPushing = List<bool>.filled(totalSteps, false);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _onSatelliteTapped(int index) async {
    if (kDebugMode) {
      debugPrint('${satelliteImages[index]} 클릭됨');
    }
    if (index < 0 || index >= totalSteps) return;
    if (_isPushing[index]) return;

    final imageDir = satelliteImages[index];
    final heroTag = 'onboarding-satellite-$imageDir';
    final backgroundAssetPath = 'assets/icon/${imageDir}_filled.png';

    setState(() => _isPushing[index] = true);
    try {
      await Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.transparent,
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnboardingHeroDetailScreen(
              heroTag: heroTag,
              backgroundAssetPath: backgroundAssetPath,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isPushing[index] = false);
    }

    if (!mounted) return;
    setState(() => isSelected[index] = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: SafeArea(
        child: Stack(
          children: [
            const OnboardingBottomSheet(),
            const BackgroundTitleWidget(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BigCircleRipple(
                    pulseController: _pulseController,
                    orbitDiameter: orbitRadius * 2,
                  ),
                  SizedBox.square(
                    dimension: (orbitRadius * 2) + _satelliteTapDiameter,
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: List.generate(totalSteps, (index) {
                            final double angle =
                                (index * (2 * pi / totalSteps)) +
                                    (_rotationController.value * 2 * pi);

                            return Transform.translate(
                              offset: Offset(
                                orbitRadius * cos(angle),
                                orbitRadius * sin(angle),
                              ),
                              child: Satellite(
                                index: index,
                                done: isSelected[index],
                                pulseController: _pulseController,
                                imageDir: satelliteImages[index],
                                onTap: () => _onSatelliteTapped(index),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
