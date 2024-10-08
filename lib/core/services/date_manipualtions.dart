import 'package:intl/intl.dart';

class DateManipulations {
  String formatMessageDate(DateTime dateTime) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    if (isSameDay(now, dateTime)) {
      return DateFormat.Hm().format(dateTime);
    } else if (dateTime.isAfter(startOfWeek) && dateTime.isBefore(endOfWeek)) {
      return DateFormat.EEEE().format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
