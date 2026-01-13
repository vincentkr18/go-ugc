import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global Design System for UGC Video Creation App
/// Calm, editorial, premium, minimal, writing-first aesthetic
/// Garamond for headers, Figtree for UI
class AppTheme {
  // ============ COLORS ============
  
  /// Main Backgrounds
  static const Color backgroundMain = Color(0xFFFAF7F3); // Full screen background
  static const Color backgroundSidebar = Color(0xFFF0ECE8); // Sidebar/drawer
  
  /// Card Backgrounds
  static const Color cardNeutral = Color(0xFFF5F2EE); // Soft cream
  static const Color cardYellow = Color(0xFFFFF9E5); // Gentle warm yellow
  static const Color cardHighlight = Color(0xFFFFF4C3); // Hover/tap feedback
  
  /// Text Colors
  static const Color textPrimary = Color(0xFF2C2C2C); // Main text
  static const Color textSecondary = Color(0xFF5C5C5C); // Muted labels
  
  /// Primary Accent (CTAs, active states)
  static const Color accentPrimary = Color(0xFF7C5DF0); // Purple
  static const Color accentHover = Color(0xFFA187F7); // Lighter purple for hover
  
  /// Status Colors
  static const Color statusProcessing = Color(0xFFFFA726); // Orange
  static const Color statusComplete = Color(0xFF51CF66); // Green
  static const Color statusError = Color(0xFFFF6B6B); // Red
  
  /// UI Elements
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x0D000000); // rgba(0,0,0,0.05)
  
  // ============ DIMENSIONS ============
  
  /// Touch Targets (Mobile-first)
  static const double minTouchTarget = 44.0;
  static const double buttonHeight = 48.0;
  
  /// Bottom Navigation Bar
  static const double bottomNavHeight = 64.0;
  static const double bottomNavIconSize = 24.0;
  
  /// Cards and Containers
  static const double cardRadius = 12.0;
  static const double cardRadiusSmall = 8.0;
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 24.0;
  
  /// Spacing (Mobile-optimized)
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  
  /// Content Width
  static const double maxContentWidth = 600.0; // Max width for main content
  static const double sidePadding = 16.0; // Screen edge padding
  
  /// Avatar & Icons
  static const double avatarSize = 48.0;
  static const double avatarSizeLarge = 80.0;
  
  // ============ TYPOGRAPHY ============
  
  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      // H1 - Garamond, Editorial, Large
      displayLarge: GoogleFonts.ebGaramond(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.ebGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),
      
      // H2, H3 - Figtree, Clean
      headlineLarge: GoogleFonts.figtree(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.figtree(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.figtree(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      
      // Body - Figtree
      bodyLarge: GoogleFonts.figtree(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.figtree(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.figtree(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
        height: 1.5,
      ),
      
      // Labels - Figtree
      labelLarge: GoogleFonts.figtree(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.figtree(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.figtree(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
    );
  }
  
  // ============ THEME DATA ============
  
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: accentPrimary,
        secondary: accentPrimary,
        surface: cardNeutral,
        background: backgroundMain,
        error: statusError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundMain,
      useMaterial3: true,
      textTheme: textTheme(context),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundMain,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: accentPrimary),
        titleTextStyle: GoogleFonts.figtree(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: cardNeutral,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: EdgeInsets.zero,
        shadowColor: shadowColor,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          elevation: 0,
          textStyle: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(0, buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          side: const BorderSide(color: borderLight, width: 1),
          textStyle: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPrimary,
          minimumSize: const Size(0, buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: spacingMd),
          textStyle: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundSidebar,
        selectedItemColor: accentPrimary,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.figtree(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.figtree(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardNeutral,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: const BorderSide(color: accentPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: const BorderSide(color: statusError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
        hintStyle: GoogleFonts.figtree(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentPrimary,
        linearTrackColor: borderLight,
        circularTrackColor: borderLight,
      ),
    );
  }
  
  // ============ SHADOWS ============
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // ============ ANIMATIONS ============
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration microDuration = Duration(milliseconds: 150);
  static const Duration slowDuration = Duration(milliseconds: 500);
}
