import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // Whitespace & Padding Standards
  static const double pagePaddingHorizontal = 20.0;
  static const double gapBetweenCards = 16.0;
  static const double cardPadding = 16.0;
  static const double buttonHeight = 54.0;
  static const double cardRadiusValue = 16.0;
  static const double pillRadiusValue = 28.0;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pagePaddingHorizontal,
    vertical: 12.0,
  );

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(cardRadiusValue));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(pillRadiusValue));

  // Soft Shadows (blur 12, y+4, black 6%)
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> heroShadow = [
    BoxShadow(
      color: AppColors.primaryGreen.withOpacity(0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // Standardized Typography Hierarchy
  static TextStyle get screenTitle => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.3,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textGrey,
      );

  static TextStyle get cardTitle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get cardBody => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textGrey,
      );

  static TextStyle get priceStyle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryGreen,
      );

  static TextStyle get buttonLabel => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.ctaYellow,
        surface: AppColors.whiteCard,
        surfaceContainerHighest: AppColors.lightGreenBg,
      ),
      scaffoldBackgroundColor: AppColors.mintTint,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.whiteCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ctaYellow,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: pillRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: buttonLabel,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: cardRadius,
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: cardRadius,
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: cardRadius,
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F1E16),
      primaryColor: AppColors.primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.ctaYellow,
        surface: Color(0xFF162B20),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    );
  }
}
