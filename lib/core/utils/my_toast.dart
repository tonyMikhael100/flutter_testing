import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/core/themes/app_colors.dart';
import 'package:flutter_testing/core/themes/app_fonts.dart';
import 'package:flutter_testing/core/themes/app_text_styles.dart';
import 'package:toastification/toastification.dart';

class MyToast {
  MyToast._();

  /// Displays a premium center popup dialog instead of a transient toast.
  static void show({
    required BuildContext context,
    required String title,
    String? description,
    ToastificationType type = ToastificationType.info,
    Duration? duration,
    Alignment alignment = Alignment.topCenter,
  }) {
    final scheme = _schemeFor(type);

    if (type == ToastificationType.error) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        builder: (context) =>
            _MessageDialog(title: title, description: description, type: type),
      );
    } else {
      toastification.show(
        context: context,
        type: type,
        style: ToastificationStyle.flat,
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.primary,
            fontSize: 14.sp,
          ),
        ),
        description: description != null
            ? Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  fontFamily: AppFonts.primary,
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                ),
              )
            : null,
        alignment: alignment,
        autoCloseDuration: duration ?? const Duration(seconds: 4),
        animationDuration: const Duration(milliseconds: 500),
        animationBuilder: (context, animation, alignment, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: scheme.accent.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        showProgressBar: true,
        progressBarTheme: ProgressIndicatorThemeData(
          color: scheme.accent,
          linearTrackColor: scheme.accent.withValues(alpha: 0.1),
        ),
        closeButton:
            const ToastCloseButton(showType: CloseButtonShowType.onHover),
        closeOnClick: true,
        pauseOnHover: true,
        dragToClose: true,
        applyBlurEffect: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.black,
        borderSide: BorderSide(
          color: scheme.accent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      );
    }
  }

  // ── Shortcuts ───────────────────────────────────────────────────────────────

  static void success(
    BuildContext context,
    String title, {
    String? description,
  }) =>
      show(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.success,
      );

  static void error(
    BuildContext context,
    String title, {
    String? description,
  }) =>
      show(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.error,
      );

  static void warning(
    BuildContext context,
    String title, {
    String? description,
  }) =>
      show(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.warning,
      );

  static void info(BuildContext context, String title, {String? description}) =>
      show(
        context: context,
        title: title,
        description: description,
        type: ToastificationType.info,
      );

  // ── Types ───────────────────────────────────────────────────

  static _ToastScheme _schemeFor(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const _ToastScheme(
          accent: AppColors.secondaryColor,
          icon: Icons.check_circle_rounded,
        );
      case ToastificationType.error:
        return const _ToastScheme(
          accent: Color(0xFFFF5252),
          icon: Icons.cancel_rounded,
        );
      case ToastificationType.warning:
        return const _ToastScheme(
          accent: Color(0xFFFFB300),
          icon: Icons.warning_rounded,
        );
      case ToastificationType.info:
      default:
        return const _ToastScheme(
          accent: Color(0xFF64B5F6),
          icon: Icons.info_rounded,
        );
    }
  }
}

class _MessageDialog extends StatefulWidget {
  final String title;
  final String? description;
  final ToastificationType type;

  const _MessageDialog({
    required this.title,
    this.description,
    required this.type,
  });

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = MyToast._schemeFor(widget.type);

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                    color: scheme.accent.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.accent.withValues(alpha: 0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 110.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                scheme.accent.withValues(alpha: 0.12),
                                scheme.accent.withValues(alpha: 0.03),
                              ],
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28.r),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(18.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.accent.withValues(alpha: 0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.accent.withValues(alpha: 0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            scheme.icon,
                            color: scheme.accent,
                            size: 44.r,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.lightBlack,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (widget.description != null) ...[
                            SizedBox(height: 12.h),
                            Text(
                              widget.description!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 13.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: 32.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.accent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Text(
                                'auth.common.done'.tr(),
                                style: AppTextStyles.button.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastScheme {
  final Color accent;
  final IconData icon;
  const _ToastScheme({required this.accent, required this.icon});
}
