part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState {
  final ChatStatus status;
  final List<MessageModel> messages;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  bool get isInitial => status == ChatStatus.initial;
  bool get isLoading => status == ChatStatus.loading;
  bool get isSuccess => status == ChatStatus.success;
  bool get isFailure => status == ChatStatus.failure;
  bool get hasMessages => messages.isNotEmpty;

  // errorMessage is intentionally not carried over, so a stale error
  // disappears as soon as the chat moves to any other status.
  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }
}
