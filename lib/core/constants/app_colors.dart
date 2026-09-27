import 'package:flutter/material.dart';

/// Centralized Color Tokens - Zero inline hex outside this file
class AppColors {
  AppColors._();

  // Brand Greens
  static const Color primaryGreen = Color(0xFF2E7D32); // brand green, dark
  static const Color primaryDark = Color(0xFF1B3A2B);  // dark forest green
  static const Color primaryDeep = Color(0xFF132B1B);  // deepest header green
  static const Color accentGreen = Color(0xFF4CAF50);  // gradients, icons
  static const Color accentGreenLight = Color(0xFF66BB6A);
  static const Color lightGreenBg = Color(0xFFE8F5E9); // cards, info strips
  static const Color mintTint = Color(0xFFF6FBF3);     // page background wash
  static const Color mintTintAlt = Color(0xFFF1F8E9);
  static const Color mintBorder = Color(0xFFE2EFE0);

  // Brand CTAs & Accents
  static const Color ctaYellow = Color(0xFFFFC107);    // primary buttons, "days" in logo
  static const Color ctaYellowHover = Color(0xFFFFA000);
  static const Color ctaYellowLight = Color(0xFFFFFDE7);
  static const Color accentOrange = Color(0xFFE65100);

  // Typography & Neutrals
  static const Color textDark = Color(0xFF1B3A2B);
  static const Color textGrey = Color(0xFF6B7A71);
  static const Color textLight = Color(0xFF9EABA3);

  // Cards & Surfaces
  static const Color whiteCard = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE6EFE8);
  static const Color dividerColor = Color(0xFFE6EFE8);
  static const Color disabledGrey = Color(0xFFE0E5E2);

  // Status Colors
  static const Color statusRed = Color(0xFFE53935);    // logout/delete only, badge dots
  static const Color statusRedLight = Color(0xFFFFEBEE);
  static const Color statusRedBorder = Color(0xFFFFCDD2);
  static const Color statusSuccess = Color(0xFF2E7D32);
  static const Color statusPending = Color(0xFFFF9800);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF4CAF50),
    ],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B3A2B),
      Color(0xFF2E7D32),
    ],
  );

  static const LinearGradient leafGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F5E9),
      Color(0xFFF6FBF3),
    ],
  );
}
