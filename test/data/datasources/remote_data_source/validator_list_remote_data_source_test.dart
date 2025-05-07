import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/validator_list_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/validator_list_remote_data_source.dart';

import '../../instruments/request_data_instruments.dart';
import 'validator_list_remote_data_source_test.mocks.dart';

@GenerateMocks([ValidatorListApiContract])
void main() {
  late ValidatorListRemoteDataSource remoteDataSource;
  late MockValidatorListApiContract apiContract;

  setUp(() {
    apiContract = MockValidatorListApiContract();
    remoteDataSource = ValidatorListRemoteDataSource(apiContract);
  });

  test(
    'GIVEN a getValidatorUserList WHEN call to api response THEN return the result',
    () async {
      when(apiContract.getValidatorUserList(
        sessionId: 'sessionId',
      )).thenAnswer(
        (_) => Future.value(
          getListValidatorRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.getValidatorUserList(
        sessionId: 'sessionId',
      );

      verify(
        apiContract.getValidatorUserList(
          sessionId: 'sessionId',
        ),
      ).called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a removeValidatorUser WHEN remove a validator user THEN return the result',
    () async {
      when(
        apiContract.removeValidatorUser(
          sessionId: 'sessionId',
          validatorId: 'validatorId',
        ),
      ).thenAnswer(
        (_) => Future.value(
          givenRemoveUserRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.removeValidatorUser(
        sessionId: 'sessionId',
        validatorId: 'validatorId',
      );

      verify(
        apiContract.removeValidatorUser(
          sessionId: 'sessionId',
          validatorId: 'validatorId',
        ),
      ).called(1);

      assert(result.result.value.isNotEmpty);
    },
  );

  test(
    'GIVEN a addValidatorUser WHEN add a validator user THEN return the result',
    () async {
      when(
        apiContract.addValidatorUser(
          sessionId: 'sessionId',
          dni: 'dni',
          id: 'id',
          name: 'name',
        ),
      ).thenAnswer(
        (_) => Future.value(
          givenAddUserRemoteEntity(),
        ),
      );

      final result = await remoteDataSource.addValidatorUser(
        sessionId: 'sessionId',
        dni: 'dni',
        id: 'id',
        name: 'name',
      );

      verify(
        apiContract.addValidatorUser(
          sessionId: 'sessionId',
          dni: 'dni',
          id: 'id',
          name: 'name',
        ),
      ).called(1);

      assert(result.result.value.isNotEmpty);
    },
  );
}
