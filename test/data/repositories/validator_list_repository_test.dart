import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/validator_list_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/data/repositories/validator_list_repository.dart';

import '../instruments/app_version_instruments.dart';
import '../instruments/request_data_instruments.dart';
import 'validator_list_repository_test.mocks.dart';

@GenerateMocks([
  ValidatorListRemoteDataSourceContract,
  AuthLocalDataSourceContract,
])
void main() {
  late MockValidatorListRemoteDataSourceContract validatorListRemoteC;
  late MockAuthLocalDataSourceContract authLocalC;
  late ValidatorListRepository repository;

  setUp(() {
    validatorListRemoteC = MockValidatorListRemoteDataSourceContract();
    authLocalC = MockAuthLocalDataSourceContract();
    repository = ValidatorListRepository(
      validatorListRemoteC,
      authLocalC,
    );
  });

  group('Get Validator User List', () {
    test(
      'GIVEN a getValidatorUserList WHEN call to ValidatorListRepository THEN return Result.success',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(validatorListRemoteC.getValidatorUserList(
          sessionId: LiteralsPushVersion.sessionId,
        )).thenAnswer(
          (_) async => givenValidatorEntityList(),
        );

        final res = await repository.getValidatorUserList();

        verify(authLocalC.retrieveSessionId()).called(1);
        verify(validatorListRemoteC.getValidatorUserList(
          sessionId: LiteralsPushVersion.sessionId,
        )).called(1);
        assert(
          res.when(
            failure: (e) => false,
            success: (data) => true,
          ),
        );
      },
    );
    test(
      'GIVEN a getValidatorUserList WHEN call to ValidatorListRepository THEN return Result.failure',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);

        final res = await repository.getValidatorUserList();

        assert(
          res.when(
            failure: (e) => e == const RepositoryError.serverError(),
            success: (data) => false,
          ),
        );
      },
    );
  });
  group('Add Validator User', () {
    test(
      'GIVEN a removeValidatorUser WHEN call to ValidatorListRepository THEN return Result.success',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(validatorListRemoteC.removeValidatorUser(
          sessionId: LiteralsPushVersion.sessionId,
          validatorId: 'id',
        )).thenAnswer(
          (_) async => givenRemoveUserRemoteEntity(),
        );

        final res = await repository.removeValidatorUser('id');

        verify(authLocalC.retrieveSessionId()).called(1);
        verify(validatorListRemoteC.removeValidatorUser(
          sessionId: LiteralsPushVersion.sessionId,
          validatorId: 'id',
        )).called(1);
        assert(
          res.when(
            failure: (e) => false,
            success: (data) => true,
          ),
        );
      },
    );
    test(
      'GIVEN a removeValidatorUser WHEN call to ValidatorListRepository THEN return Result.failure',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);

        final res = await repository.removeValidatorUser('');

        assert(
          res.when(
            failure: (e) => e == const RepositoryError.serverError(),
            success: (data) => false,
          ),
        );
      },
    );
  });
  group('remove Validator User', () {
    test(
      'GIVEN a addValidatorUser WHEN call to ValidatorListRepository THEN return Result.success',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(
          validatorListRemoteC.addValidatorUser(
            sessionId: LiteralsPushVersion.sessionId,
            dni: LiteralsPushVersion.dni,
            id: LiteralsPushVersion.id,
            name: LiteralsPushVersion.name,
          ),
        ).thenAnswer(
          (_) async => givenAddUserRemoteEntity(),
        );

        final res = await repository.addValidatorUser(
          LiteralsPushVersion.dni,
          LiteralsPushVersion.id,
          LiteralsPushVersion.name,
        );

        verify(authLocalC.retrieveSessionId()).called(1);
        verify(validatorListRemoteC.addValidatorUser(
          sessionId: LiteralsPushVersion.sessionId,
          dni: LiteralsPushVersion.dni,
          id: LiteralsPushVersion.id,
          name: LiteralsPushVersion.name,
        )).called(1);
        assert(
          res.when(
            failure: (e) => false,
            success: (data) => true,
          ),
        );
      },
    );
    test(
      'GIVEN a addValidatorUser WHEN call to ValidatorListRepository THEN return Result.failure',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);

        final res = await repository.addValidatorUser(
          '',
          '',
          '',
        );

        assert(
          res.when(
            failure: (e) => e == const RepositoryError.serverError(),
            success: (data) => false,
          ),
        );
      },
    );
  });
}
