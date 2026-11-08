import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/chat_app_bar.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/chat_list.dart';
import 'package:flutter_testing/features/chats/presentation/widgets/send_message_footer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: ChatAppBar(),
      ),
      body: const SafeArea(
        child: ChatList(),
      ),
      bottomNavigationBar: SendMessageFooter(
        onSend: (value) {
          // Handle sending the message
          context.read<ChatCubit>().sendMessage(
              AiChatRequest(model: 'gemini-3.5-flash-lite', input: value));
        },
      ),
    );
  }
}
