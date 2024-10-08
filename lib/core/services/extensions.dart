extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year &&
        month == now.month &&
        day == now.day;
  }
}

