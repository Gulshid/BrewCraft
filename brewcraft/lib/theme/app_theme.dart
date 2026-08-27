import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized design tokens for the app. Keeping every color, radius and
/// duration here means the animation code below never hardcodes a "magic"
/// value inline.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF120D0A);
  static const Color surface = Color(0xFF1C1512);
  static const Color surfaceElevated = Color(0xFF241A15);
  static const Color espresso = Color(0xFF3E2723);
  static const Color coffeeBrown = Color(0xFF6F4E37);
  static const Color latte = Color(0xFFD7B899);
  static const Color cream = Color(0xFFF3E5D8);
  static const Color caramel = Color(0xFFC9873A);
  static const Color accent = Color(0xFFE8A548);
  static const Color accentDeep = Color(0xFFB6742A);
  static const Color success = Color(0xFF6FCF97);
  static const Color danger = Color(0xFFE57373);
  static const Color textMuted = Color(0xFF9C8B80);

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDeep],
  );

  static const LinearGradient crema = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEBCFA0), Color(0xFFC9873A), Color(0xFF6F4E37)],
  );
}

class AppRadii {
  AppRadii._();
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;
  static const double xl = 36;
}

class AppDurations {
  AppDurations._();
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 420);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration brew = Duration(milliseconds: 2600);
}

class AppCurves {
  AppCurves._();
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve overshoot = Cubic(0.34, 1.56, 0.64, 1.0);
  static const Curve smooth = Curves.easeInOutCubic;
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: AppColors.cream,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.cream,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.accent,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accent,
      secondary: AppColors.caramel,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    textTheme: textTheme,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}
