import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/models/message_type.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo_imp.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required this.chatRepoImp}) : super(const ChatState());
  final ChatRepoImp chatRepoImp;

  Future<void> sendMessage(String text) async {
    if (state.isLoading || text.trim().isEmpty) return;

    await _requestReply(
      [
        ...state.messages,
        MessageModel(text: text, type: MessageType.user),
      ],
    );
  }

  /// Resends the conversation after a failed request. The unanswered user
  /// message is still the last one, so nothing has to be re-added.
  Future<void> retryLastMessage() async {
    if (!state.isFailure || !state.hasMessages) return;

    await _requestReply(state.messages);
  }

  Future<void> _requestReply(List<MessageModel> conversation) async {
    // Show the conversation right away instead of waiting for the reply.
    emit(state.copyWith(status: StateStatus.loading, messages: conversation));

    final result = await chatRepoImp.send(
      AiChatRequest(messages: conversation),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StateStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (replies) => emit(
        state.copyWith(
          status: StateStatus.success,
          messages: [...state.messages, ...replies],
        ),
      ),
    );
  }
}
