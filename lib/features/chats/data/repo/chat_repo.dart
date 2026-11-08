import 'package:dartz/dartz.dart';
import 'package:flutter_testing/core/errors/failure.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';

abstract class ChatRepo {
  Future<Either<Failure, List<MessageModel>>> send(AiChatRequest message);
}
