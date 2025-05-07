import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/auth_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/auth_remote_data_source.dart';

import '../../instruments/request_data_instruments.dart';
import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([
  AuthApiContract,
])
void main() {
  late MockAuthApiContract authApiContract;
  late AuthRemoteDataSource authRemoteDataSource;

  setUp(() {
    authApiContract = MockAuthApiContract();

    authRemoteDataSource = AuthRemoteDataSource(
      authApiContract,
    );
  });

  test(
    'GIVEN a auth remote data source WHEN calling preLogin succeeds THEN I get a preLoginRemoteEntity',
    () async {
      when(authApiContract.preLogin())
          .thenAnswer((_) => Future.value(givenPreLoginRemoteEntity));

      final result = await authRemoteDataSource.preLogin();

      verify(authApiContract.preLogin()).called(1);

      assert(result == givenPreLoginRemoteEntity);
    },
  );

  test(
    'GIVEN a auth remote data source WHEN calling loginWithCertificate succeeds THEN I get the nif of the user',
    () async {
      when(authApiContract.loginWithCertificate(
        sessionId: 'sessionId',
        loginTokenSignedBase64: '',
        publicKeyBase64: '',
      )).thenAnswer((_) => Future.value('3953053V'));

      final result = await authRemoteDataSource.loginWithCertificate(
        sessionId: 'sessionId',
        loginTokenSignedBase64: '',
        publicKeyBase64: '',
      );

      verify(authApiContract.loginWithCertificate(
        sessionId: 'sessionId',
        loginTokenSignedBase64: '',
        publicKeyBase64: '',
      )).called(1);

      assert(result == '3953053V');
    },
  );

  test(
    'GIVEN a auth remote data source WHEN calling loginWithClave succeeds THEN I get a login url',
    () async {
      when(authApiContract.loginWithClave())
          .thenAnswer((_) => Future.value(givenLoginClaveRemoteEntity));

      final result = await authRemoteDataSource.loginWithClave();

      verify(authApiContract.loginWithClave()).called(1);

      assert(result == givenLoginClaveRemoteEntity);
    },
  );

  test(
    'GIVEN a auth remote data source WHEN calling logOut succeeds THEN I get a true',
    () async {
      when(authApiContract.logOut(
        sessionId: 'sessionId',
      )).thenAnswer((_) => Future.value(true));

      final result = await authRemoteDataSource.logOut(sessionId: 'sessionId');

      verify(authApiContract.logOut(sessionId: 'sessionId')).called(1);

      assert(result);
    },
  );
}
