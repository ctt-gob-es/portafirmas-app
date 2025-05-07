import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/authorization_list_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/authorization_remote_data_source.dart';

import '../../instruments/request_data_instruments.dart';
import 'authorization_remote_data_source_test.mocks.dart';

@GenerateMocks([AuthorizationsApiContract])
void main() {
  late MockAuthorizationsApiContract authorizationsApiContract;
  late AuthorizationRemoteDataSource remoteDataSource;

  setUp(() {
    authorizationsApiContract = MockAuthorizationsApiContract();
    remoteDataSource = AuthorizationRemoteDataSource(authorizationsApiContract);
  });

  test(
    'GIVEN a getAuthorizationsList WHEN  call to get authorization list THEN get the list',
    () async {
      when(authorizationsApiContract.getAuthorizationsList(
        sessionId: 'sessionId',
      )).thenAnswer(
        (_) => Future.value(
          givenAuthDataRemoteEntityList(),
        ),
      );

      final result =
          await remoteDataSource.getAuthorizationsList(sessionId: 'sessionId');

      verify(authorizationsApiContract.getAuthorizationsList(
        sessionId: 'sessionId',
      )).called(1);

      assert(
        result.isNotEmpty,
      );
    },
  );

  test(
    'GIVEN a addAuthorization WHEN  call to add an authorization THEN add to the list',
    () async {
      when(authorizationsApiContract.addAuthorization(
        sessionId: 'sessionId',
        user: newUserEntity(),
      )).thenAnswer(
        (_) => Future.value(
          getAddAuthorizationRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.addAuthorization(
        sessionId: 'sessionId',
        user: newUserEntity(),
      );

      verify(authorizationsApiContract.addAuthorization(
        sessionId: 'sessionId',
        user: newUserEntity(),
      )).called(1);

      assert(result == getAddAuthorizationRemoteEntity());
    },
  );

  test(
    'GIVEN a revokeAuthorization WHEN  call to revoke an authorization THEN delete from the list',
    () async {
      when(authorizationsApiContract.revokeAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
        operation: '1',
      )).thenAnswer(
        (_) => Future.value(
          getRevokeAuthRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.revokeAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
        operation: '1',
      );

      verify(authorizationsApiContract.revokeAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
        operation: '1',
      )).called(1);

      assert(result.result.value ==
          getAddAuthorizationRemoteEntity().result.value);
    },
  );

  test(
    'GIVEN a acceptAuthorization WHEN  call to accept an authorization THEN accept',
    () async {
      when(authorizationsApiContract.acceptAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
      )).thenAnswer(
        (_) => Future.value(
          getAcceptAuthRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.acceptAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
      );

      verify(authorizationsApiContract.acceptAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
      )).called(1);

      assert(result == getAcceptAuthRemoteEntity());
    },
  );
}
