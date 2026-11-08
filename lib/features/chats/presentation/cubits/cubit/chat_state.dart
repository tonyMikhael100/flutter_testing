part of 'chat_cubit.dart';

enum StateStatus { initial, loading, success, failure }

class ChatState {
  final StateStatus status;
  final List<MessageModel> messages;
  final String? errorMessage;

  const ChatState({
    this.status = StateStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  bool get isInitial => status == StateStatus.initial;
  bool get isLoading => status == StateStatus.loading;
  bool get isSuccess => status == StateStatus.success;
  bool get isFailure => status == StateStatus.failure;
  bool get hasMessages => messages.isNotEmpty;

  // errorMessage is intentionally not carried over, so a stale error
  // disappears as soon as the chat moves to any other status.
  ChatState copyWith({
    StateStatus? status,
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
