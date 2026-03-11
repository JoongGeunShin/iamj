String formatTimeFromDayFraction(double value) {
  final totalMinutes = (value * 24 * 60).toInt();
  var hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours >= 24) hours = 23;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

String formatDurationFromDayFractions({
  required double startValue,
  required double endValue,
}) {
  final diffMinutes = ((endValue - startValue) * 24 * 60).toInt();
  final h = diffMinutes ~/ 60;
  final m = diffMinutes % 60;
  return h > 0 ? '${h}h ${m}m' : '${m}m';
}

double dayFractionFromDateTime(DateTime now) {
  return (now.hour * 60 + now.minute) / (24 * 60);
}

