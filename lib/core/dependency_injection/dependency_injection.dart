import 'package:dio/dio.dart';
import 'package:flutter_testing/core/networking/api_endpoints.dart';
import 'package:flutter_testing/core/networking/api_service_client.dart';
import 'package:flutter_testing/core/networking/dio_factroy.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo_imp.dart';
import 'package:flutter_testing/features/chats/presentation/cubits/cubit/chat_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final dio = await DioFactory().getDio(baseUrl: ApiEndpoints.baseUrl);
  getIt.registerSingleton<Dio>(dio, dispose: (dio) => dio.close());
  getIt.registerLazySingleton<ApiServiceClient>(
    () => ApiServiceClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ChatRepoImp>(
    () => ChatRepoImp(apiServiceClient: getIt<ApiServiceClient>()),
  );

  //cubits

  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(chatRepoImp: getIt<ChatRepoImp>()),
  );
}
