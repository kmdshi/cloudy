import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

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
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: TColorTheme.scaffoldbg,
      titleTextStyle: TextStyle(
        fontFamily: 'Chillax',
        fontWeight: FontWeight.w600,
        color: TColorTheme.textGrey,
        fontSize: 20,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelPadding: EdgeInsets.all(16),
      dividerColor: TColorTheme.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: RectangularIndicator(
        horizontalPadding: 7,
        verticalPadding: 4,
        color: TColorTheme.textGrey,
        bottomRightRadius: 100,
        topLeftRadius: 100,
        topRightRadius: 100,
        bottomLeftRadius: 100,
      ),
      labelStyle: TTextTheme.textTheme.titleSmall!
          .copyWith(fontWeight: FontWeight.w200),
      unselectedLabelStyle: TTextTheme.textTheme.titleSmall!
          .copyWith(fontWeight: FontWeight.w200),
      labelColor: TColorTheme.white,
      unselectedLabelColor: TColorTheme.textGrey,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.focused)
              ? null
              : Colors.transparent;
        },
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
