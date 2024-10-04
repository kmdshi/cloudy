import 'package:cloudy/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class AgreementWidget extends StatefulWidget {
  const AgreementWidget({super.key});

  @override
  State<AgreementWidget> createState() => _AgreementWidgetState();
}

class _AgreementWidgetState extends State<AgreementWidget> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CheckboxTheme(
          data: Theme.of(context).checkboxTheme,
          child: Checkbox(
            value: agree,
            onChanged: (val) => setState(() {
              agree = val!;
            }),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'By registering an account, you are agreeing\n',
                  style: Theme.of(context).textTheme.headlineSmall),
              TextSpan(
                  text: 'Terms and Agreement',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: TColorTheme.mainBlue)),
              WidgetSpan(
                child: SizedBox(height: 20),
              ),
              TextSpan(
                  text: ' of Cipherme',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        )
      ],
    );
  }
}
