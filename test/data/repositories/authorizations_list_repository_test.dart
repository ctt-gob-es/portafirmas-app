import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/repositories/authorizations_list_repository.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/authorization_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

import '../instruments/app_version_instruments.dart';
import '../instruments/request_data_instruments.dart';
import 'authorizations_list_repository_test.mocks.dart';

@GenerateMocks([
  AuthLocalDataSourceContract,
  AuthorizationRemoteDataSourceContract,
])
void main() {
  late MockAuthLocalDataSourceContract authLocalContract;
  late MockAuthorizationRemoteDataSourceContract authRemoteContract;
  late AuthorizationsRepository authRepo;

  setUp(() {
    authLocalContract = MockAuthLocalDataSourceContract();
    authRemoteContract = MockAuthorizationRemoteDataSourceContract();
    authRepo = AuthorizationsRepository(
      authLocalContract,
      authRemoteContract,
    );
  });

  test(
    'GIVEN getAuthorizationsList WHEN call to repository THEN verify the results',
    () async {
      when(authLocalContract.retrieveSessionId())
          .thenAnswer((_) async => 'sessionId');
      when(authRemoteContract.getAuthorizationsList(sessionId: 'sessionId'))
          .thenAnswer((_) => Future.value(getListAuthDataEntity()));

      final result = await authRepo.getAuthorizationsList();

      verify(authLocalContract.retrieveSessionId()).called(1);

      verify(authRemoteContract.getAuthorizationsList(sessionId: 'sessionId'))
          .called(1);

      assert(
        result.when(
          failure: (e) => false,
          success: (d) => true,
        ),
      );
    },
  );

  test(
    'GIVEN getAuthorizationsList WHEN call to repository THEN return the Failure error',
    () async {
      when(authRemoteContract.getAuthorizationsList(sessionId: 'sessionId'))
          .thenThrow(Exception('Unexpected error'));

      final result = await authRepo.getAuthorizationsList();

      assert(
        result.when(
          failure: (e) => true,
          success: (d) => false,
        ),
      );
    },
  );

  test(
    'GIVEN addAuthorization WHEN call to repository THEN verify the results',
    () async {
      when(authLocalContract.retrieveSessionId())
          .thenAnswer((_) async => 'sessionId');

      when(authRemoteContract.addAuthorization(
        sessionId: 'sessionId',
        user: newUserEntity(),
      )).thenAnswer((_) => Future.value(getAddAuthorizationRemoteEntity()));

      final result = await authRepo.addAuthorization(newUserEntity());

      verify(authLocalContract.retrieveSessionId()).called(1);

      verify(authRemoteContract.addAuthorization(
        sessionId: 'sessionId',
        user: newUserEntity(),
      )).called(1);

      result.when(
        failure: (e) => Result.failure(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
        success: (data) => Result.success(data),
      );
    },
  );
  test(
    'GIVEN addAuthorization WHEN call to repository THEN return the Failure error',
    () async {
      when(authRemoteContract.addAuthorization(
        sessionId: 'sessionId',
        user: newUserEntity(),
      )).thenThrow(Exception('Unexpected error'));

      final result = await authRepo.addAuthorization(newUserEntity());

      assert(
        result.when(
          failure: (e) => true,
          success: (d) => false,
        ),
      );
    },
  );

  test(
    'GIVEN revokeAuthorization WHEN call to repository THEN verify the results',
    () async {
      when(authLocalContract.retrieveSessionId())
          .thenAnswer((_) async => 'sessionId');

      when(authRemoteContract.revokeAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
        operation: 'operation',
      )).thenAnswer((_) => Future.value(getRevokeAuthRemoteEntity()));

      final result = await authRepo.revokeAuthorization(
        'authId',
        'operation',
      );

      verify(authLocalContract.retrieveSessionId()).called(1);

      verify(authRemoteContract.revokeAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
        operation: 'operation',
      )).called(1);

      assert(
        result.when(
          failure: (e) => false,
          success: (d) => true,
        ),
      );
    },
  );

  test(
    'GIVEN revokeAuthorization WHEN call to repository THEN return the Failure error',
    () async {
      when(authRemoteContract.revokeAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
        operation: 'operation',
      )).thenThrow(Exception('Unexpected error'));

      final result = await authRepo.revokeAuthorization(
        'authId',
        'operation',
      );

      assert(
        result.when(
          failure: (e) => true,
          success: (d) => false,
        ),
      );
    },
  );

  test(
    'GIVEN acceptedAuthorization WHEN call to repository THEN verify the results',
    () async {
      when(authLocalContract.retrieveSessionId())
          .thenAnswer((_) async => 'sessionId');

      when(authRemoteContract.acceptAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
      )).thenAnswer((_) => Future.value(getAcceptAuthRemoteEntity()));

      final result = await authRepo.acceptedAuthorization('authId');

      verify(authLocalContract.retrieveSessionId()).called(1);

      verify(authRemoteContract.acceptAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
      )).called(1);

      assert(
        result.when(
          failure: (e) => false,
          success: (d) => true,
        ),
      );
    },
  );
  test(
    'GIVEN acceptedAuthorization WHEN call to repository THEN return the Failure error',
    () async {
      when(authRemoteContract.acceptAuthorization(
        sessionId: 'sessionId',
        authId: 'authId',
      )).thenThrow(Exception('Unexpected error'));

      final result = await authRepo.acceptedAuthorization('authId');

      assert(
        result.when(
          failure: (e) => true,
          success: (d) => false,
        ),
      );
    },
  );
}
