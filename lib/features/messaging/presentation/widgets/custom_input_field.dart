import 'package:cloudy/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  const CustomInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: TColorTheme.mainBlue,
      decoration: InputDecoration(
        filled: true,
        fillColor: TColorTheme.white,
        hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: TColorTheme.secondryGrey.withOpacity(.5),
              fontSize: 16,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(48),
          borderSide: BorderSide.none,
        ),
        hintText: 'Type here...',
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}
