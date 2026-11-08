import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/core/dependency_injection/dependency_injection.dart';
import 'package:flutter_testing/core/networking/api_service_client.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo_imp.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('startup resolves shared networking and the chat repository', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'en'});
    addTearDown(() => getIt.reset());

    await setupGetIt();

    final dio = getIt<Dio>();
    final client = getIt<ApiServiceClient>();
    final repository = getIt<ChatRepo>();

    expect(dio.options.headers['Accept-Language'], 'en');
    expect(repository, isA<ChatRepoImp>());
    expect((repository as ChatRepoImp).apiServiceClient, same(client));
    expect(getIt<Dio>(), same(dio));
    expect(getIt<ApiServiceClient>(), same(client));
    expect(getIt<ChatRepo>(), same(repository));
  });
}
