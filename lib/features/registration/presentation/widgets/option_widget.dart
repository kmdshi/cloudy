import 'package:cloudy/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool isTitle;
  final bool isInterests;
  final bool isKeyphrase;
  final TextEditingController fieldController;
  const OptionWidget({
    super.key,
    required this.title,
    required this.content,
    required this.fieldController,
    this.isInterests = false,
    this.isTitle = false,
    this.isKeyphrase = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        isKeyphrase
            ? Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: Theme.of(context).textButtonTheme.style,
                    child: Text(
                      'Copy',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: TColorTheme.mainBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  )
                ],
              )
            : Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
        const SizedBox(height: 5),
        Container(
          height: isKeyphrase ? 80 : 44,
          decoration: BoxDecoration(
            color: TColorTheme.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            cursorColor: TColorTheme.mainBlue,
            controller: fieldController,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: TColorTheme.textGrey),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: isKeyphrase ? 10 : 0,
                left: 15,
                bottom: 10,
                right: 10,
              ),
              hintText: content,
              hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 16,
                  ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
            ),
            maxLines: isKeyphrase ? null : 1,
          ),
        ),
        const SizedBox(height: 5),
        isTitle
            ? Text(
                'be careful, it will be IMPOSSIBLE to change your nickname afterwards.',
                style: Theme.of(context).textTheme.headlineSmall)
            : const SizedBox.shrink(),
        isInterests
            ? Text('e.g  Design, Photography, ... etc.',
                style: Theme.of(context).textTheme.headlineSmall)
            : const SizedBox.shrink(),
        isKeyphrase
            ? Text(
                'Save the key phrase to the safe place, this is the one and only access to your account. ',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: TColorTheme.red))
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
      ],
    );
  }
}
