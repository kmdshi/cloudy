import 'package:cryptome/core/theme/color_theme.dart';
import 'package:cryptome/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class TCiphermeTheme {
  TCiphermeTheme._();

  static final lightTheme = ThemeData(
    textTheme: TTextTheme.textTheme,
    scaffoldBackgroundColor: TColorTheme.scaffoldbg,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(TTextTheme.textTheme.titleSmall),
        backgroundColor: const WidgetStatePropertyAll(TColorTheme.buttonBgBlue),
        foregroundColor: const WidgetStatePropertyAll(TColorTheme.white),
        fixedSize: const WidgetStatePropertyAll(Size(334, 44)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.zero),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    checkboxTheme: const CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(TColorTheme.mainBlue),
      fillColor: WidgetStatePropertyAll(TColorTheme.white),
      side: BorderSide.none,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: TColorTheme.transparent,
      selectedColor: TColorTheme.transparent,
      showCheckmark: false,
      labelStyle: TTextTheme.textTheme.headlineMedium!
          .copyWith(color: const ChipLabelColor()),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      side: const BorderSide(
        color: TColorTheme.darkLabel,
      ),
    ),
  );
}

class ChipLabelColor extends Color implements WidgetStateColor {
  const ChipLabelColor() : super(_default);

  static const int _default = 0xFF000000;

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.white.withOpacity(0.8);
    }
    return TColorTheme.darkLabel;
  }
}
