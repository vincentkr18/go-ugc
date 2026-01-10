import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global Design System for the Health & Fitness App
/// Based on clean, calm, health-focused modern design principles
class AppTheme {
  // ============ COLORS ============
  
  /// Primary dark charcoal / near-black
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color nearBlack = Color(0xFF111111);
  
  /// Accent colors - Mint green / teal
  static const Color accentMint = Color(0xFF8FD5C8);
  static const Color accentTeal = Color(0xFF6EC5B8);
  static const Color accentMintLight = Color(0xFFB8E6DD);
  static const Color accentMintPastel = Color(0xFFD4F1E9);
  
  /// Background colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundOffWhite = Color(0xFFF8F9FA);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  
  /// Text colors
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textMuted = Color(0xFF999999);
  static const Color textLight = Color(0xFFBBBBBB);
  
  /// UI Element colors
  static const Color chipInactiveBg = Color(0xFFE8E8E8);
  static const Color chipInactiveText = Color(0xFF333333);
  static const Color iconGray = Color(0xFF7A7A7A);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x10000000);
  
  // ============ DIMENSIONS ============
  
  /// Bottom Navigation Bar
  static const double bottomNavHeight = 60.0;
  static const double bottomNavPillRadius = 30.0;
  static const double bottomNavElevation = 8.0;
  static const double bottomNavIconSize = 24.0;
  static const double bottomNavActiveIndicatorSize = 48.0;
  
  /// App Bar
  static const double appBarHeight = 56.0;
  static const double appBarIconContainerSize = 40.0;
  static const double appBarIconSize = 20.0;
  
  /// Card and Container
  static const double cardRadius = 18.0;
  static const double cardRadiusLarge = 20.0;
  static const double cardElevation = 2.0;
  static const double cardPadding = 16.0;
  
  /// Filter Chips
  static const double chipHeight = 36.0;
  static const double chipRadius = 18.0;
  static const double chipPaddingHorizontal = 18.0;
  
  /// Touch Targets
  static const double minTouchTarget = 44.0;
  
  /// Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  
  /// Profile
  static const double profileAvatarSize = 100.0;
  static const double profileAvatarBorderWidth = 4.0;
  static const double profileEditIconSize = 32.0;
  
  // ============ TYPOGRAPHY ============
  
  static TextTheme textTheme(BuildContext context) {
    return GoogleFonts.interTextTheme(
      Theme.of(context).textTheme,
    ).copyWith(
      // Display - Page Titles
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.3,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.3,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),
      
      // Headlines
      headlineLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      
      // Body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
        height: 1.5,
      ),
      
      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textMuted,
      ),
    );
  }
  
  // ============ THEME DATA ============
  
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryDark,
        secondary: accentTeal,
        surface: backgroundWhite,
        background: backgroundOffWhite,
        error: Colors.red[400]!,
      ),
      scaffoldBackgroundColor: backgroundOffWhite,
      useMaterial3: true,
      textTheme: textTheme(context),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryDark),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: backgroundWhite,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: const EdgeInsets.all(0),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: chipInactiveBg,
        selectedColor: primaryDark,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: chipPaddingHorizontal,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(chipRadius),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: iconGray,
        size: 24,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: backgroundWhite,
        foregroundColor: primaryDark,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // ============ SHADOWS ============
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get bottomNavShadow => [
    BoxShadow(
      color: const Color(0x15000000),
      blurRadius: 12,
      offset: const Offset(0, -2),
    ),
  ];
  
  // ============ ANIMATIONS ============
  
  /// Smooth ease-in-out curve for all interactions
  static const Curve defaultCurve = Curves.easeInOut;
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration microDuration = Duration(milliseconds: 150);
  static const Duration chartAnimationDuration = Duration(milliseconds: 800);
}
