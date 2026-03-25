class TimeUtils {
  static double timeStringToDouble(String time) {
    try {
      final parts = time.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      return (hours * 60 + minutes) / (24 * 60);
    } catch (e) {
      return 0.0;
    }
  }

  static DateTime timeToDateTime(DateTime now, String timeStr) {
    try {
      final parts = timeStr.split(':');
      return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    } catch (e) {
      return now;
    }
  }

  static double calculateProgress(DateTime now, String startStr, String endStr) {
    final start = timeToDateTime(now, startStr);
    final end = timeToDateTime(now, endStr);

    if (now.isBefore(start)) return 0.0;
    if (now.isAfter(end)) return 1.0;

    final total = end.difference(start).inSeconds;
    if (total <= 0) return 0.0;

    final elapsed = now.difference(start).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }
  static String getTimeRemainingText(DateTime now, String endTimeStr) {
    final end = timeToDateTime(now, endTimeStr);
    final diff = end.difference(now);
    if (diff.isNegative) return "ENDED";
    return "${diff.inHours}H ${diff.inMinutes % 60}M LEFT";
  }
}