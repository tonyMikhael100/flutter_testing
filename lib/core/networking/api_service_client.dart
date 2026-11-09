import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_testing/core/networking/api_keys.dart';
import 'package:flutter_testing/features/chats/data/models/ai_chat_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_testing/core/networking/api_endpoints.dart';

part 'api_service_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiServiceClient {
  factory ApiServiceClient(Dio dio, {String? baseUrl}) = _ApiServiceClient;

  @POST(ApiEndpoints.gemini)
  @Headers({'Content-Type': 'application/json'})
  Future<Map<String, Object>> sendMessage({
    @Header('x-goog-api-key') String apiKey = ApiKeys.gemini,
    @Body() required AiChatRequest request,
  });
}
