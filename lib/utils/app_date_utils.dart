List<DateTime> generateSurroundingDates({
  required DateTime anchor,
  int total = 5,
  int centerIndex = 2,
}) {
  return List.generate(
    total,
    (i) => anchor.add(Duration(days: i - centerIndex)),
  );
}

String shortMonth(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

String weekdayShort(int weekday) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[(weekday - 1) % 7];
}

