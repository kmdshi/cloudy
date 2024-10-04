import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isAddress;
  const InputWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.isAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: TColorTheme.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            cursorColor: TColorTheme.mainBlue,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: TColorTheme.textGrey),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 15,
                bottom: 10,
                right: 10,
                top: isAddress ? 8 : 4,
              ),
              hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 16,
                  ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              hintText: subtitle,
              suffixIcon: isAddress
                  ? IconButton(
                      onPressed: () {},
                      icon: Assets.icons.scanIcon.image(),
                    )
                  : null,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
