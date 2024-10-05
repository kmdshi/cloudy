import 'package:cloudy/core/services/extensions.dart';
import 'package:intl/intl.dart';

class DateManipualtions {
  String formatMessageDate(DateTime dateTime) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    if (dateTime.isAfter(startOfWeek) && dateTime.isBefore(endOfWeek)) {
      if (dateTime.isToday()) {
        return DateFormat.Hm().format(dateTime);
      } else {
        return DateFormat.EEEE().format(dateTime);
      }
    } else {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
  }
}
