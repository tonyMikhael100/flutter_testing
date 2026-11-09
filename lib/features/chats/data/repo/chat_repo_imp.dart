import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_testing/core/errors/failure.dart';
import 'package:flutter_testing/core/networking/api_service_client.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:flutter_testing/features/chats/data/models/message_model.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo.dart';

class ChatRepoImp implements ChatRepo {
  final ApiServiceClient apiServiceClient;

  ChatRepoImp({required this.apiServiceClient});

  @override
  Future<Either<Failure, List<MessageModel>>> send(
    List<MessageModel> conversation,
  ) async {
    try {
      // Limit API context without changing the caller's visible conversation.
      final requestMessages = List<MessageModel>.unmodifiable(
        conversation.length >= 20
            ? conversation.sublist(conversation.length - 5)
            : conversation,
      );
      final request = AiChatRequest(messages: requestMessages);
      final response = await apiServiceClient.sendMessage(request: request);
      return Right(MessageModel.listFromJson(response));
    } on DioException catch (error) {
      return Left(ServerFailure.dioErrorHandler(error));
    } catch (_) {
      return Left(
        ServerFailure(
          errorMessage: 'Unexpected error occurred, please try again later.',
        ),
      );
    }
  }
}
