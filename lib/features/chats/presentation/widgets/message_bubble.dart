import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum MessageType { user, model }

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.type,
  });

  final String message;
  final MessageType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isUser = type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;

          return Align(
            alignment: isUser
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: (availableWidth * 0.82).clamp(0, 640).toDouble(),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      isUser ? colors.primary : colors.surfaceContainerHighest,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(20),
                    topEnd: const Radius.circular(20),
                    bottomStart: Radius.circular(isUser ? 20 : 4),
                    bottomEnd: Radius.circular(isUser ? 4 : 20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Semantics(
                    container: true,
                    label: isUser ? 'You' : 'Assistant',
                    child: SelectableText(
                      message,
                      textAlign: TextAlign.start,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isUser ? colors.onPrimary : colors.onSurface,
                        fontSize: 14.sp.clamp(14, 18).toDouble(),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
