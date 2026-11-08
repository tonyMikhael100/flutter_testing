import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/empty_chat.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/message_bubble.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        } else if (state.messages.isEmpty) {
          return const Center(child: EmptyChat());
        } else {
          return ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              return MessageBubble(
                message: message.text,
                type: message.type,
              );
            },
          );
        }
      },
    );
  }
}
