import 'package:flutter/material.dart';

class OnboardingHeroDetailScreen extends StatelessWidget {
  final String heroTag;
  final String backgroundAssetPath;

  const OnboardingHeroDetailScreen({
    super.key,
    required this.heroTag,
    required this.backgroundAssetPath,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white.withValues(alpha: 0.75 * curved.value),
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
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
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FadeTransition(
                    opacity: curved,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
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

