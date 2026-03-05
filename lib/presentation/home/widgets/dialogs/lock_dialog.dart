import 'dart:ui';
import 'package:flutter/material.dart';

class LockDialog {
  static Future<bool?> showLockDialog(BuildContext context) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.expand(); // 기본 페이지 빌더 (사용 안 함)
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * anim1.value),
          child: Opacity(
            opacity: anim1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // 배경 흐림 효과 (트렌디 포인트)
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'SCREEN LOCK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'WantedSans',
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                label: 'YES',
                                onTap: () => Navigator.of(context).pop(true),
                                isPrimary: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionButton(
                                label: 'NO',
                                onTap: () => Navigator.of(context).pop(false),
                                isPrimary: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 버튼 스타일 위젯
  static Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF1E1E1E) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(24),
          border: isPrimary ? null : Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: isPrimary
              ? [BoxShadow(color: const Color(0xFFFFB138).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'WantedSans',
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}