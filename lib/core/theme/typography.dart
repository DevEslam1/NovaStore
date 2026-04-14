import 'package:flutter/material.dart';

/// Typography tokens from the "Ethereal Commerce" / "The Curated Pavilion"
/// design system.
///
/// Headline / Display → Plus Jakarta Sans (tight tracking, editorial weight)
/// Body / Label       → Inter (neutral, high-legibility)
class AppTypography {
  static const String headlineFont = 'PlusJakartaSans';
  static const String bodyFont = 'Inter';

  static const TextTheme textTheme = TextTheme(
    // ─── Display ─────────────────────────────────────────
    displayLarge: TextStyle(
      fontFamily: headlineFont,
      fontSize: 56,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.12, // -0.02em
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontFamily: headlineFont,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.9, // -0.02em
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontFamily: headlineFont,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.72, // -0.02em
      height: 1.22,
    ),

    // ─── Headline ────────────────────────────────────────
    headlineLarge: TextStyle(
      fontFamily: headlineFont,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.32, // -0.01em
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontFamily: headlineFont,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.28, // -0.01em
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontFamily: headlineFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.33,
    ),

    // ─── Title ───────────────────────────────────────────
    titleLarge: TextStyle(
      fontFamily: headlineFont,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontFamily: bodyFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
    ),

    // ─── Body ────────────────────────────────────────────
    bodyLarge: TextStyle(
      fontFamily: bodyFont,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.16, // 0.01em
    ),
    bodyMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.14, // 0.01em
    ),
    bodySmall: TextStyle(
      fontFamily: bodyFont,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
    ),

    // ─── Label ───────────────────────────────────────────
    labelLarge: TextStyle(
      fontFamily: bodyFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.7, // 0.05em
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.6, // 0.05em
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: bodyFont,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.55, // 0.05em
      height: 1.45,
    ),
  );
}
