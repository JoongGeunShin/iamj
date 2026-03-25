import 'package:flutter/material.dart';

class ContentActionButton extends StatelessWidget {
  final Color bgColor, textColor;
  final String label;
  final VoidCallback? onTap;

  const ContentActionButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: textColor.withValues(alpha: 0.4),
        highlightColor: textColor.withValues(alpha: 0.05),
        child: Container( // 투명한 컨테이너로 패딩과 텍스트 유지
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
