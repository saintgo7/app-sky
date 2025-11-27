import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Modern travel app theme
  static const Color primary = Color(0xFF0066CC); // Sky Blue
  static const Color primaryDark = Color(0xFF004C99);
  static const Color primaryLight = Color(0xFF3385DD);
  static const Color primaryVariant = Color(0xFF80B3FF);

  // Secondary colors - Warm accent
  static const Color secondary = Color(0xFFFF6B35); // Coral
  static const Color secondaryDark = Color(0xFFE55A2B);
  static const Color secondaryLight = Color(0xFFFF8A65);
  static const Color secondaryVariant = Color(0xFFFFB5A0);

  // Tertiary colors - Luxury touch
  static const Color tertiary = Color(0xFF8B5CF6); // Purple
  static const Color tertiaryDark = Color(0xFF7C3AED);
  static const Color tertiaryLight = Color(0xFFA78BFA);

  // Background colors
  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Error colors
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);

  // Success colors
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);

  // Warning colors
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF111827);

  // Status colors
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Border colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);

  // Travel specific colors
  static const Color flight = Color(0xFF0066CC);
  static const Color hotel = Color(0xFFFF6B35);
  static const Color activity = Color(0xFF8B5CF6);
  static const Color transport = Color(0xFF059669);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surface, surfaceVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowHeavy = Color(0x4D000000);
}