import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/core/themes/app_fonts.dart';

class AppTheme {
  // الألوان الأساسية - Dark Mode
  static const Color darkBackground =
      Color.fromARGB(255, 24, 24, 24); // أسود أعمق من الـ Obsidian
  static const Color darkSurface =
      Color(0xFF1A1A1A); // لون الـ Cards في الوضع الليلي
  static const Color darkAccent = Color(0xFF5A9A78); // أخضر ساج مضيء قليلاً
  static const Color darkText = Color(0xFFECECEC); // أبيض مريح للعين

  // الألوان الأساسية - Light Mode
  static const Color obsidianBlack = Color(0xFF1A1A1A);
  static const Color sageGreen = Color(0xFF427D5D);
  static const Color softWhite = Color(0xFFFBFBFD);

  // --- Dark Theme ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppFonts.primary,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: darkAccent,
      colorScheme: const ColorScheme.dark(
        primary: darkAccent,
        onPrimary: Colors.white,
        surface: darkSurface,
        secondary: darkAccent,
      ),

      // AppBar Dark
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.primary,
          color: darkText,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Typography Dark
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 32.sp,
          fontWeight: FontWeight.w800,
          color: darkText,
          letterSpacing: -1,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 16.sp,
          color: darkText.withValues(alpha: 0.9),
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 14.sp,
          color: darkText.withValues(alpha: 0.6),
        ),
      ),

      // Inputs Dark
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        border: _buildBorder(Colors.transparent),
        enabledBorder: _buildBorder(Colors.transparent),
        focusedBorder: _buildBorder(darkAccent.withValues(alpha: 0.5)),
        hintStyle: TextStyle(
          fontFamily: AppFonts.primary,
          color: Colors.white24,
          fontSize: 14.sp,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAccent,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
          textStyle: TextStyle(fontFamily: AppFonts.primary),
        ),
      ),
    );
  }

  // --- Light Theme ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppFonts.primary,
      scaffoldBackgroundColor: softWhite,
      primaryColor: sageGreen,
      colorScheme: const ColorScheme.light(
        primary: sageGreen,
        surface: Colors.white,
      ),
    );
  }

  static OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }
}
