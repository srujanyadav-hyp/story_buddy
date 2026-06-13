import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ========== brand colours taken from the wireframe style guide ==========
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6F2BC2);
  static const Color deep = Color(0xFF36165E);

  static const Color scaffold = Color(0xFFF7F6FB);
  static const Color card = Colors.white;
  static const Color storyCard = Color(0xFFF1EEFA);
  static const Color textDark = Color(0xFF2B2440);
  static const Color textMuted = Color(0xFF8A86A1);

  static const Color correct = Color(0xFF2BAE66);
  static const Color wrong = Color(0xFFE0567A);
}

// ========== app theme, poppins font like the wireframe asks ==========
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
      ),
      scaffoldBackgroundColor: AppColors.scaffold,
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
    );
  }
}
