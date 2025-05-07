import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/request_api_contract.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/request_remote_data_source.dart';
import 'package:portafirmas_app/data/models/request_petition_remote_entity.dart';

import '../../instruments/request_data_instruments.dart';
import 'request_remote_data_source_test.mocks.dart';

@GenerateMocks([
  RequestApiContract,
])
void main() {
  late MockRequestApiContract requestApiContract;
  late RequestRemoteDataSource remoteDataSource;

  setUp(() {
    requestApiContract = MockRequestApiContract();
    remoteDataSource = RequestRemoteDataSource(
      requestApiContract,
    );
  });

  test(
    'GIVEN a remote data source WHEN call to get requests success THEN I get a list of requests',
    () async {
      when(requestApiContract.getRequests(
        sessionId: anyNamed('sessionId'),
        petition: anyNamed('petition'),
      )).thenAnswer((_) => Future.value(givenRequestListRemoteEntity()));

      final result = await remoteDataSource.getRequests(
        sessionId: 'sessionId',
        petition: const RequestPetitionRemoteEntity(page: 1, pageSize: 5),
      );

      verify(requestApiContract.getRequests(
        sessionId: anyNamed('sessionId'),
        petition: anyNamed('petition'),
      )).called(1);

      assert(
        result == givenRequestListRemoteEntity(),
      );
    },
  );

  test(
    'GIVEN a remote data source WHEN call to getUserRequestApps THEN I get a list of Users requests',
    () async {
      when(requestApiContract.getUserRequestApps(
        sessionId: anyNamed('sessionId'),
      )).thenAnswer((_) => Future.value(givenUserAppListRemoteEntity()));
//UserAppListRemoteEntity
      final result =
          await remoteDataSource.getUserRequestApps(sessionId: 'sessionId');
//RequestAppEntity
      verify(requestApiContract.getUserRequestApps(sessionId: 'sessionId'))
          .called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to getAllRequestApps THEN I get the list of apps requests',
    () async {
      when(requestApiContract.getRequestApps(
        sessionId: anyNamed('sessionId'),
        publicKeyBase64: 'publicKeyBase64',
      )).thenAnswer((_) => Future.value(getAppListRemoteEntity()));

      final result = await remoteDataSource.getAllRequestApps(
        sessionId: 'sessionId',
        publicKeyBase64: 'publicKeyBase64',
      );

      verify(requestApiContract.getRequestApps(
        sessionId: anyNamed('sessionId'),
        publicKeyBase64: 'publicKeyBase64',
      )).called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to detailRequest THEN I get the detail of a request',
    () async {
      when(requestApiContract.detailRequest(
        sessionId: 'sessionId',
        requestId: 'requestId',
      )).thenAnswer((_) => Future.value(givenRequestRemoteEntity()));

      final result = await remoteDataSource.detailRequest(
        sessionId: 'sessionId',
        requestId: 'requestId',
      );

      verify(requestApiContract.detailRequest(
        sessionId: 'sessionId',
        requestId: 'requestId',
      )).called(1);

      assert(result.id == givenRequestRemoteEntity().id);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to getUserRoles THEN I get the role of the user',
    () async {
      when(requestApiContract.getUserRoles(
        sessionId: 'sessionId',
      )).thenAnswer((_) => Future.value(getUserRoleRemoteEntityList()));

      final result = await remoteDataSource.getUserRoles(
        sessionId: 'sessionId',
      );

      verify(requestApiContract.getUserRoles(sessionId: 'sessionId')).called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to getUsersBySearch THEN I get the user when search it',
    () async {
      when(requestApiContract.getUsersBySearch(
        sessionId: 'sessionId',
        name: 'name',
        mode: 'mode',
      )).thenAnswer((_) => Future.value(getUsersSearchRemoteEntityList()));

      final result = await remoteDataSource.getUsersBySearch(
        sessionId: 'sessionId',
        name: 'name',
        mode: 'mode',
      );

      verify(requestApiContract.getUsersBySearch(
        sessionId: 'sessionId',
        name: 'name',
        mode: 'mode',
      )).called(1);

      assert(result.first.id == getUsersSearchRemoteEntityList().first.id);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to downloadDocument THEN I get document when click on download button',
    () async {
      when(requestApiContract.downloadDocument(
        sessionId: 'sessionId',
        documentId: 'documentId',
        documentName: 'documentName',
        operation: 1,
      )).thenAnswer(
        (_) => Future.value(File('path')),
      );

      final result = await remoteDataSource.downloadDocument(
        sessionId: 'sessionId',
        documentId: 'documentId',
        documentName: 'documentName',
        operation: 1,
      );

      verify(requestApiContract.downloadDocument(
        sessionId: 'sessionId',
        documentId: 'documentId',
        documentName: 'documentName',
        operation: 1,
      )).called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to revokeRequests THEN I revoke the request',
    () async {
      final encodedReason = base64Encode(
        'reason'.codeUnits,
      ).replaceAll('+', '-').replaceAll('/', '_');

      when(requestApiContract.revokeRequests(
        sessionId: 'sessionId',
        encodedReason: encodedReason,
        encodedRequestIds: "<rjct id='id'/>",
      )).thenAnswer(
        (_) => Future.value(getRevokeRequestsRemoteEntity()),
      );

      final result = await remoteDataSource.revokeRequests(
        sessionId: 'sessionId',
        reason: 'reason',
        requestIds: ['id'],
      );

      verify(requestApiContract.revokeRequests(
        sessionId: 'sessionId',
        encodedReason: encodedReason,
        encodedRequestIds: "<rjct id='id'/>",
      )).called(1);

      assert(result.isNotEmpty);
    },
  );
  test(
    'GIVEN a remote data source WHEN call to validatePetitions THEN I validate the request',
    () async {
      when(requestApiContract.validatePetitions(
        sessionId: 'sessionId',
        petitionId: "<r id='id'/>",
      )).thenAnswer(
        (_) => Future.value(getValidatePetitionsListRemoteEntity()),
      );

      final result = await remoteDataSource.validatePetitions(
        sessionId: 'sessionId',
        petitionId: [
          'id',
        ],
      );

      verify(requestApiContract.validatePetitions(
        sessionId: 'sessionId',
        petitionId: "<r id='id'/>",
      )).called(1);

      assert(result.isNotEmpty);
    },
  );

  test(
    'GIVEN a remote data source WHEN call to approveRequests THEN I approve the request',
    () async {
      when(requestApiContract.approveRequests(
        sessionId: 'sessionId',
        encodedRequestIds: "<rjct id='id'/>",
      )).thenAnswer(
        (_) => Future.value(getApproveRequestsRemoteEntity()),
      );

      final result = await remoteDataSource
          .approveRequests(sessionId: 'sessionId', requestIds: ['id']);

      verify(requestApiContract.approveRequests(
        sessionId: 'sessionId',
        encodedRequestIds: "<rjct id='id'/>",
      )).called(1);

      assert(result.isNotEmpty);
    },
  );
}
