import 'package:flutter/material.dart';

class ScheduleDialogTextField extends StatelessWidget {
  const ScheduleDialogTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.cursorColor,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withValues(alpha: 0.3),
          selectionHandleColor: Colors.white,
        ),
      ),
      child: TextField(
        controller: controller,
        cursorColor: cursorColor,

        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: textInputAction,
      ),
    );
  }
}
