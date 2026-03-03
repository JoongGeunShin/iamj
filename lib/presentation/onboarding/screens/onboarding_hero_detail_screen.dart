import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/onboarding_repository_provider.dart';
import '../../home/screens/home_screen.dart';

class OnboardingHeroDetailScreen extends ConsumerWidget {
  final String heroTag;
  final String backgroundAssetPath;

  const OnboardingHeroDetailScreen({
    super.key,
    required this.heroTag,
    required this.backgroundAssetPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ModalRoute.of(context);
    final animation = route?.animation;
    final screenSize = MediaQuery.sizeOf(context);
    final heroWidth = screenSize.width * 0.12;
    final heroHeight = screenSize.height * 0.22;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: animation ?? kAlwaysDismissedAnimation,
        builder: (context, child) {
          final curved = CurvedAnimation(
            parent: animation ?? kAlwaysDismissedAnimation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  // color: Colors.white.withValues(alpha: 0.75 * curved.value),
                  color: Colors.white,
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: heroWidth,
                      height: heroHeight,
                      child: Hero(
                        tag: heroTag,
                        placeholderBuilder: (context, heroSize, child) =>
                            SizedBox(
                              width: heroSize.width,
                              height: heroSize.height,
                            ),
                        child: ClipOval(
                          child: Image.asset(
                            backgroundAssetPath,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment(0, -0.2),
                  child: Container(
                    alignment: Alignment.center,
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'PLANNING FOR ${heroTag.split('-').last.toUpperCase()}?',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'WantedSans',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Align(
                  alignment: const Alignment(0, 0.2),
                  child: Container(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              await ref.read(onboardingProvider.notifier).selectPurpose(heroTag.split('-').last.toUpperCase());
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                                    (route) => false,
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'YES',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'WantedSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'NO',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'WantedSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
