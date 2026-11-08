import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/core/themes/app_colors.dart';
import 'package:flutter_testing/core/themes/app_text_styles.dart';
import 'package:flutter_testing/core/utils/spacing.dart';
import 'package:flutter_testing/gen/assets.gen.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              horizontalSpace(16),
              Assets.logo.image(
                width: 30.w,
                color: AppColors.primaryColor,
              ),
              horizontalSpace(16),
              Text(
                'online chat',
                style: AppTextStyles.displayMedium,
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
