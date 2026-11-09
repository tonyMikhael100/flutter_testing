import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';

class FailureChatList extends StatelessWidget {
  const FailureChatList({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Semantics(
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Failed to send message',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            TextButton(
              onPressed: () => context.read<ChatCubit>().retryLastMessage(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
