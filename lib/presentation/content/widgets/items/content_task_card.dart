import 'package:flutter/material.dart';

class ContentTaskCard extends StatefulWidget {
  final dynamic task;
  const ContentTaskCard({super.key, required this.task});

  @override
  State<ContentTaskCard> createState() => _ContentTaskCardState();
}

class _ContentTaskCardState extends State<ContentTaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isExpanded
                ? const Color(0xFFFFB138).withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.check,
                      color: const Color(0xFFFFB138),
                      size: 18
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.task.taskTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withValues(alpha: 0.1),
                    size: 14,
                  ),
                ),
              ],
            ),

            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 12),
                  ...widget.task.detail.map<Widget>((d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.subdirectory_arrow_right, color: Colors.white24, size: 16),
                        const SizedBox(width: 12),
                        Text(
                          "${d.sequence} (${d.restTime})",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}