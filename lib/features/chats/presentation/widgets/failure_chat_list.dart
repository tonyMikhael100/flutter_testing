//center icon with text and a button to retry the request

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';

class FailureChatList extends StatelessWidget {
  const FailureChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.error_outline,
          size: 64,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        const Text(
          'Failed to load messages',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            context.read<ChatCubit>().retryLastMessage();
          },
          child: const Text('Retry'),
        ),
        const Spacer(),
      ],
    );
  }
}
