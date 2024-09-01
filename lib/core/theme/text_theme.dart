import 'package:cryptome/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  TTextTheme._();

  static final textTheme = TextTheme(
      titleLarge: GoogleFonts.spaceGrotesk(
        color: TColorTheme.mainBlue,
        fontWeight: FontWeight.w600,
        fontSize: 32,
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        color: TColorTheme.textGrey,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleSmall: GoogleFonts.spaceGrotesk(
        color: TColorTheme.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        color: TColorTheme.secondryGrey,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        color: TColorTheme.greyLabel,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ));
}
