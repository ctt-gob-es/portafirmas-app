import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/sign_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/sign_remote_data_source.dart';

import '../../instruments/request_data_instruments.dart';
import 'sign_remote_data_source_test.mocks.dart';

@GenerateMocks([SignApiContract])
void main() {
  late MockSignApiContract apiContract;
  late SignRemoteDataSource signRemote;

  setUp(() {
    apiContract = MockSignApiContract();
    signRemote = SignRemoteDataSource(apiContract);
  });

  test(
    'GIVEN a preSignWithCert WHEN call to api response THEN return the result',
    () async {
      when(apiContract.preSignWithCert(sessionId: 'sessionId', signReqs: []))
          .thenAnswer(
        (_) => Future.value(
          givenPreSignRemoteEntity(),
        ),
      );

      final result = await signRemote.preSignWithCert(
        sessionId: 'sessionId',
        signReqs: [],
      );

      verify(
        apiContract.preSignWithCert(
          sessionId: 'sessionId',
          signReqs: [],
        ),
      ).called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a postSignWithCert WHEN call to api response THEN return the result',
    () async {
      when(apiContract.postSignWithCert(
        sessionId: 'sessionId',
        signedReqs: getSignRequestPetitionRemoteEntity(),
      )).thenAnswer(
        (_) => Future.value(
          getPostSignRemoteEntity(),
        ),
      );

      final result = await signRemote.postSignWithCert(
        sessionId: 'sessionId',
        signedReqs: getSignRequestPetitionRemoteEntity(),
      );

      verify(
        apiContract.postSignWithCert(
          sessionId: 'sessionId',
          signedReqs: getSignRequestPetitionRemoteEntity(),
        ),
      ).called(1);

      assert(result.first.requestId ==
          getPostSignRemoteEntity().signedRequests.first.requestId);
    },
  );

  test(
    'GIVEN a preSignWithClave WHEN call to api response THEN return the result',
    () async {
      when(apiContract.preSignWithClave(
        sessionId: 'sessionId',
        requestIds: ['1', '2'],
      )).thenAnswer(
        (_) => Future.value(
          getPreSignClaveRemoteEntity(),
        ),
      );

      final result = await signRemote.preSignWithClave(
        sessionId: 'sessionId',
        requestIds: ['1', '2'],
      );

      verify(
        apiContract.preSignWithClave(
          sessionId: 'sessionId',
          requestIds: ['1', '2'],
        ),
      ).called(1);

      assert(result.status);
    },
  );

  test(
    'GIVEN a postSignWithClave WHEN call to api response THEN return the result',
    () async {
      when(apiContract.postSignWithClave(
        sessionId: 'sessionId',
      )).thenAnswer(
        (_) => Future.value(
          givenPostSignClaveRemoteEntity(),
        ),
      );

      final result = await signRemote.postSignWithClave(
        sessionId: 'sessionId',
      );

      verify(
        apiContract.postSignWithClave(
          sessionId: 'sessionId',
        ),
      ).called(1);

      assert(result.status);
    },
  );
}
