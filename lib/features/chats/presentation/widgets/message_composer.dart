import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageComposer extends StatelessWidget {
  const MessageComposer({
    super.key,
    required this.controller,
    this.onSend,
    this.onMicrophonePressed,
  });

  final TextEditingController controller;
  final VoidCallback? onSend;
  final VoidCallback? onMicrophonePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: colors.primary,
      fontSize: 14.sp.clamp(14, 18).toDouble(),
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: colors.primary,
              style: textStyle,
              onSubmitted: (_) => onSend?.call(),
              decoration: InputDecoration(
                hintText: 'Hello chatGPT,how are you today?',
                hintStyle: textStyle,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Voice input',
            onPressed: onMicrophonePressed,
            color: colors.outlineVariant,
            disabledColor: colors.outlineVariant,
            iconSize: 28,
            icon: const Icon(Icons.mic_none_rounded),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) => IconButton(
              onPressed: value.text.trim().isEmpty ? null : onSend,
              color: colors.primary,
              disabledColor: colors.primary.withValues(alpha: 0.45),
              iconSize: 30,
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
