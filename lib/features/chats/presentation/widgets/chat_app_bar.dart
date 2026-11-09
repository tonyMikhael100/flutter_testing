import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/gen/assets.gen.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 16),
                Assets.logo.image(
                  width: 30,
                  height: 30,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    'online chat',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 26.sp.clamp(20, 32).toDouble(),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
        ],
      ),
    );
  }
}
