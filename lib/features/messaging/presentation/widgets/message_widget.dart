import 'package:flutter/material.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final DateTime date;
  final bool isFromInitiator;

  const MessageWidget({
    super.key,
    required this.message,
    required this.date,
    required this.isFromInitiator,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    String time = DateFormat('hh:mm a').format(date);

    return Column(
      crossAxisAlignment:
          isFromInitiator ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isFromInitiator ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 50,
                maxWidth: width / 2,
              ),
              decoration: BoxDecoration(
                  color: isFromInitiator
                      ? TColorTheme.darkLabel
                      : TColorTheme.white,
                  borderRadius: isFromInitiator
                      ? const BorderRadius.only(
                          topRight: Radius.zero,
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: isFromInitiator
                              ? Colors.white
                              : TColorTheme.textGrey,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(time,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 12)),
      ],
    );
  }
}
