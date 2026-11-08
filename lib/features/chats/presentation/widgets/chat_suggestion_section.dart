import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_suggestion_tile.dart';

class ChatSuggestionSection extends StatelessWidget {
  const ChatSuggestionSection({
    super.key,
    required this.icon,
    required this.title,
    required this.prompts,
    this.onPromptSelected,
  });

  final IconData icon;
  final String title;
  final List<String> prompts;
  final ValueChanged<String>? onPromptSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, size: 28, color: theme.colorScheme.onSurface),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp.clamp(16, 20).toDouble(),
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        for (var index = 0; index < prompts.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          ChatSuggestionTile(
            prompt: prompts[index],
            onSelected: onPromptSelected,
          ),
        ],
      ],
    );
  }
}
