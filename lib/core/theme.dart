import 'package:flutter/material.dart';

class AppColors {
  // Primary palette - Deep navy emergency theme
  static const Color primary = Color(0xFF1A1F3A);
  static const Color primaryLight = Color(0xFF252B4A);
  static const Color accent = Color(0xFFFF4757);
  static const Color accentLight = Color(0xFFFF6B7A);

  // Background
  static const Color background = Color(0xFF0F1220);
  static const Color surface = Color(0xFF1E2340);
  static const Color surfaceLight = Color(0xFF252B4A);
  static const Color cardBg = Color(0xFF1A2035);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B7C3);
  static const Color textMuted = Color(0xFF6B7280);

  // Priority colors
  static const Color critical = Color(0xFFFF1744);
  static const Color criticalBg = Color(0x26FF1744);
  static const Color high = Color(0xFFFF6D00);
  static const Color highBg = Color(0x26FF6D00);
  static const Color medium = Color(0xFFFFD600);
  static const Color mediumBg = Color(0x26FFD600);
  static const Color low = Color(0xFF00E676);
  static const Color lowBg = Color(0x2600E676);

  // Status colors
  static const Color reported = Color(0xFF2979FF);
  static const Color reportedBg = Color(0x262979FF);
  static const Color inProgress = Color(0xFFFF9100);
  static const Color inProgressBg = Color(0x26FF9100);
  static const Color resolved = Color(0xFF00E676);
  static const Color resolvedBg = Color(0x2600E676);

  // Category colors
  static const Color medical = Color(0xFFE040FB);
  static const Color fire = Color(0xFFFF3D00);
  static const Color security = Color(0xFF0091EA);
  static const Color natural = Color(0xFF00BFA5);
  static const Color infrastructure = Color(0xFFFFAB00);
  static const Color other = Color(0xFF78909C);

  // Border
  static const Color border = Color(0xFF2A3050);
  static const Color borderLight = Color(0xFF3A4060);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1F3A), Color(0xFF0F1220)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF4757), Color(0xFFFF1744)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E2340), Color(0xFF1A2035)],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentLight,
        surface: AppColors.surface,
        error: AppColors.critical,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.critical),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleMedium: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    );
  }
}
