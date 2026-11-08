import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/core/themes/app_colors.dart';
import 'package:flutter_testing/core/themes/app_text_styles.dart';
import 'package:toastification/toastification.dart';

/// A compact notification that slides down from the top of the screen.
/// Tap it or swipe it up to dismiss.
class MyToast {
  MyToast._();

  static void show({
    required BuildContext context,
    required String title,
    String? description,
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final colors = Theme.of(context).colorScheme;
    final accent = _accentFor(type, colors);

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 350),
      animationBuilder: _slideFromTop,
      icon: _ToastIcon(icon: _iconFor(type), color: accent),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: colors.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: description == null
          ? null
          : Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
                fontSize: 12.sp,
              ),
            ),
      primaryColor: accent,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: colors.outlineVariant),
      boxShadow: [
        BoxShadow(
          color: colors.shadow.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      showProgressBar: false,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      closeOnClick: true,
      dragToClose: true,
      dismissDirection: DismissDirection.up,
      pauseOnHover: true,
      applyBlurEffect: false,
    );
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

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static Color _accentFor(ToastificationType type, ColorScheme colors) {
    return switch (type) {
      ToastificationType.success => AppColors.success,
      ToastificationType.warning => AppColors.warning,
      ToastificationType.error => colors.error,
      _ => colors.primary,
    };
  }

  static IconData _iconFor(ToastificationType type) {
    return switch (type) {
      ToastificationType.success => Icons.check_circle_rounded,
      ToastificationType.warning => Icons.warning_rounded,
      ToastificationType.error => Icons.error_rounded,
      _ => Icons.info_rounded,
    };
  }

  static Widget _slideFromTop(
    BuildContext context,
    Animation<double> animation,
    Alignment alignment,
    Widget child,
  ) {
    final curved =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(curved),
      child: FadeTransition(opacity: curved, child: child),
    );
  }
}

class _ToastIcon extends StatelessWidget {
  const _ToastIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(icon, color: color, size: 20.r),
    );
  }
}
