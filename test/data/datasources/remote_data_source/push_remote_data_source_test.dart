import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/push_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/push_remote_data_source.dart';

import '../../instruments/request_data_instruments.dart';
import 'push_remote_data_source_test.mocks.dart';

@GenerateMocks([PushApiContract])
void main() {
  late MockPushApiContract apiContract;
  late PushRemoteDataSource remoteDataSource;
  setUp(() {
    apiContract = MockPushApiContract();
    remoteDataSource = PushRemoteDataSource(apiContract);
  });

  test(
    'GIVEN a registerPush WHEN call to api response THEN return the result',
    () async {
      when(apiContract.registerPush(
        sessionId: 'sessionId',
        petition: givenPushPetitionRemoteEntity(),
      )).thenAnswer(
        (_) => Future.value(
          givenRegisterPushRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.registerPush(
        sessionId: 'sessionId',
        petition: givenPushPetitionRemoteEntity(),
      );

      verify(
        apiContract.registerPush(
          sessionId: 'sessionId',
          petition: givenPushPetitionRemoteEntity(),
        ),
      ).called(1);

      assert(!result);
    },
  );

  test(
    'GIVEN a updatePush WHEN call to api response THEN return the result',
    () async {
      when(apiContract.updatePush(
        sessionId: 'sessionId',
        status: true,
      )).thenAnswer(
        (_) => Future.value(
          givenUpdatePushRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.updatePush(
        sessionId: 'sessionId',
        status: true,
      );

      verify(
        apiContract.updatePush(sessionId: 'sessionId', status: true),
      ).called(1);

      assert(!result);
    },
  );
}
