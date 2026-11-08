import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_testing/core/networking/api_endpoints.dart';

part 'api_service_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiServiceClient {
  factory ApiServiceClient(Dio dio, {String baseUrl}) = _ApiServiceClient;
}
