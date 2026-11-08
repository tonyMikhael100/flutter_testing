import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/core/themes/app_colors.dart';
import 'package:flutter_testing/core/themes/app_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ────────────────────────────────────────────────
  static TextStyle get displayLarge => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  // ── Headings ───────────────────────────────────────────────
  static TextStyle get headingLarge => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get headingMedium => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get headingSmall => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  // ── Body ───────────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.lightBlack,
      );

  // ── Label / Caption ───────────────────────────────────────
  static TextStyle get label => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.lightBlack,
      );

  // ── Button ────────────────────────────────────────────────
  static TextStyle get button => TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );
}
