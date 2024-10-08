import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSeparatorWidget extends StatelessWidget {
  final DateTime date;

  const TimeSeparatorWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final formatteDate = _formatDate(date);
    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: 20),
        Text(
          isToday ? 'TODAY, $formatteDate' : formatteDate,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(width: 20),
        const Expanded(child: Divider()),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date).toUpperCase();
  }
}
