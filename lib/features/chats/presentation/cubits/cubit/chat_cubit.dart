import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/models/message_type.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required this.chatRepoImp}) : super(const ChatState());
  final ChatRepo chatRepoImp;

  Future<void> sendMessage(String text) async {
    if (isClosed || state.isLoading || text.trim().isEmpty) return;

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
    if (isClosed || !state.isFailure || !state.hasMessages) return;

    await _requestReply(state.messages);
  }

  Future<void> _requestReply(List<MessageModel> conversation) async {
    //to be visible not deleted in the ui but not sent to the api because of the limit of 20 messages in the api
    final visibleMessages = List<MessageModel>.unmodifiable(conversation);
    emit(
        state.copyWith(status: StateStatus.loading, messages: visibleMessages));

    final result = await chatRepoImp.send(visibleMessages);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StateStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),

      //evey conerstaion we append the old messages with the new replies and emit the new state
      //but the request to the api is only with the last 5 messages if the conversation is more than 20 messages
      (replies) => emit(
        state.copyWith(
          status: StateStatus.success,
          messages: List<MessageModel>.unmodifiable([
            ...visibleMessages,
            ...replies,
          ]),
        ),
      ),
    );
  }
}
