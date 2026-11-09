import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/empty_chat.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/failure_chat_list.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/message_bubble.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoading) {
          return ListView.builder(
            itemCount: state.messages.length + 1,
            //index =0 hi
            //index =1 how can i help you
            //index=2 i wanna know about flutter
            //index=2
            //if (2==2 stat.messages.length) true so show the loading bubble
            itemBuilder: (context, index) {
              if (index == state.messages.length) {
                return const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: LoadingBubble(),
                );
              }

              final message = state.messages[index];
              return MessageBubble(
                message: message.text,
                type: message.type,
              );
            },
          );
        }

        if (state.isFailure) {
          return ListView.builder(
            itemCount: state.messages.length + 1,
            itemBuilder: (context, index) {
              if (index == state.messages.length) {
                return FailureChatList(errorMessage: state.errorMessage);
              }

              final message = state.messages[index];
              return MessageBubble(
                message: message.text,
                type: message.type,
              );
            },
          );
        }

        if (state.isSuccess) {
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

        return const Center(child: EmptyChat());
      },
    );
  }
}
