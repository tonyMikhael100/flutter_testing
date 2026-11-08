import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/core/routing/app_router.dart';
import 'package:flutter_testing/core/themes/app_colors.dart';
import 'package:flutter_testing/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRouter.chatScreen);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsetsGeometry.all(40.w),
        child: Center(
          child: Assets.logo.image(),
        ),
      ).animate().fadeIn(
            duration: Duration(milliseconds: 1000),
          ),
    );
  }
}
