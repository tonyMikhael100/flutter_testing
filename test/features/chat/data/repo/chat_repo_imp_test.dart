import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/core/networking/api_service_client.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo.dart';
import 'package:flutter_testing/features/chats/data/repo/chat_repo_imp.dart';
import 'package:mocktail/mocktail.dart';

class ApiServiceClientMock extends Mock implements ApiServiceClient {}

void main() {
  late ChatRepoImp chatRepoImp;

  /* Initialize the ChatRepoImp instance before each test
  setup function is called before each test case to ensure
   a fresh instance of ChatRepoImp is created for every test, preventing any state leakage between tests and ensuring that each test runs in isolation.
  */
  setUp(() {
    chatRepoImp = ChatRepoImp(apiServiceClient: ApiServiceClientMock());
  });

  group(
    'validation of sendMessage method inside the apiservice clien where the message lenght should be <20',
    () {
      //first case
      test('message lenght >20 should the lenth be 5', () async {});
    },
  );
}
