import 'package:flutter/material.dart';

class EmptyTaskCard extends StatelessWidget {
  final String message;

  const EmptyTaskCard({
    super.key,
    this.message = "Focus on your main goal.",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}