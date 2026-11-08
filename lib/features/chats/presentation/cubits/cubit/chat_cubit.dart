import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/models/message_type.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo_imp.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required this.chatRepoImp}) : super(const ChatState());
  final ChatRepoImp chatRepoImp;

  Future<void> sendMessage(AiChatRequest chatRequest) async {
    if (state.isLoading) return;

    final userMessage = MessageModel(
      text: chatRequest.input,
      type: MessageType.user,
    );

    // Show the user's message right away instead of waiting for the reply.
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        messages: [...state.messages, userMessage],
      ),
    );

    final result = await chatRepoImp.send(chatRequest);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (replies) => emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: [...state.messages, ...replies],
        ),
      ),
    );
  }
}
