import 'package:flutter/material.dart';
import '../../../../domain/entities/schedule_state.dart';

class ContentTaskCard extends StatelessWidget {
  final TaskItem task;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ContentTaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

  bool get _isAllCompleted {
    final List<TaskItemDetail> details = task.detail ?? [];
    if (details.isEmpty) return false;
    return details.every((d) => d.isCompleted == "true");
  }

  @override
  Widget build(BuildContext context) {
    final bool isDone = _isAllCompleted;

    return Dismissible(
      key: ValueKey('${task.taskTitle}_$index'),
      background: _buildSwipeBg(
        Alignment.centerLeft,
        const Color(0xFFFFB138),
        Icons.edit_rounded,
        "EDIT",
      ),
      secondaryBackground: _buildSwipeBg(
        Alignment.centerRight,
        Colors.redAccent,
        Icons.delete_outline_rounded,
        "DELETE",
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        } else {
          onDelete();
          return true;
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDone
                ? const Color(0xFFFFB138).withOpacity(0.5)
                : Colors.white.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: isDone
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB138).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            iconColor: const Color(0xFFFFB138),
            collapsedIconColor: Colors.white.withOpacity(0.2),
            shape: const Border(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusChip(isDone),
                const SizedBox(height: 8),
                Text(
                  task.taskTitle,
                  style: TextStyle(
                    color: isDone
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Rest: ${task.restTime ?? '0초'} • ${task.detail?.length ?? 0} Steps",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 12,
                ),
              ),
            ),
            trailing: ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_indicator_rounded,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  children: [
                    Divider(color: Colors.white.withOpacity(0.05)),
                    const SizedBox(height: 12),
                    if (task.detail != null)
                      ...task.detail!
                          .map<Widget>((d) => _buildDetailRow(d))
                          .toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStatusChip(bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFFFFB138)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isDone ? "ALL DONE" : "IN PROGRESS",
        style: TextStyle(
          color: isDone ? Colors.black : Colors.white.withOpacity(0.4),
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailRow(TaskItemDetail d) {
    final bool itemDone = d.isCompleted == "true";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            itemDone ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: itemDone
                ? const Color(0xFFFFB138)
                : Colors.white.withOpacity(0.1),
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              d.sequence,
              style: TextStyle(
                color: itemDone
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (d.restTime != "0초")
            Text(
              d.restTime,
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildSwipeBg(
    Alignment alignment,
    Color color,
    IconData icon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 28),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
