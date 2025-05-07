import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/utils/document_utils.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/request_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/data/repositories/request_repository.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';

import '../../presentation/instruments/requests_instruments.dart';
import '../instruments/app_version_instruments.dart';
import '../instruments/request_data_instruments.dart';
import 'requests_repository_test.mocks.dart';

@GenerateMocks([
  RequestRemoteDataSourceContract,
  AuthLocalDataSourceContract,
])
void main() {
  late MockRequestRemoteDataSourceContract requestRemoteDataSource;
  late MockAuthLocalDataSourceContract authLocalDataSource;
  late RequestRepository repository;

  setUp(() {
    requestRemoteDataSource = MockRequestRemoteDataSourceContract();
    authLocalDataSource = MockAuthLocalDataSourceContract();

    repository = RequestRepository(
      requestRemoteDataSource,
      authLocalDataSource,
    );
  });

  group('Get pending requests', () {
    test(
      'GIVEN a repository WHEN call to pending requests success THEN I get Result success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value('SessionId'));
        when(authLocalDataSource.getUserNif())
            .thenAnswer((_) => Future.value(''));

        when(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).thenAnswer((_) => Future.value(givenRequestListRemoteEntity()));

        final result = await repository.getPendingRequests(
          page: 1,
          pageSize: 5,
          filter: RequestFilter.initial(),
        );

        verify(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).called(1);
        verify(authLocalDataSource.retrieveSessionId()).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, givenRequestListEntity()),
        );
      },
    );
    test(
      'GIVEN a repository WHEN call to pending requests error THEN I get Result error',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value('SessionId'));
        when(authLocalDataSource.getUserNif())
            .thenAnswer((_) => Future.value(''));

        when(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.getPendingRequests(
          page: 1,
          pageSize: 5,
          filter: RequestFilter.initial(),
        );

        verify(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).called(1);
        verify(authLocalDataSource.retrieveSessionId()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
  group('Get signed requests', () {
    test(
      'GIVEN a repository WHEN call to signed requests success THEN I get Result success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value('SessionId'));
        when(authLocalDataSource.getUserNif())
            .thenAnswer((_) => Future.value(''));

        when(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).thenAnswer((_) => Future.value(givenRequestListRemoteEntity()));

        final result = await repository.getSignedRequests(
          page: 1,
          pageSize: 5,
          filter: RequestFilter.initial(),
        );

        verify(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).called(1);
        verify(authLocalDataSource.retrieveSessionId()).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, givenRequestListEntity()),
        );
      },
    );
    test(
      'GIVEN a repository WHEN call to signed requests error THEN I get Result error',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value('SessionId'));
        when(authLocalDataSource.getUserNif())
            .thenAnswer((_) => Future.value(''));

        when(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.getSignedRequests(
          page: 1,
          pageSize: 5,
          filter: RequestFilter.initial(),
        );

        verify(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).called(1);
        verify(authLocalDataSource.retrieveSessionId()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
  group('Get rejected requests', () {
    test(
      'GIVEN a repository WHEN call to rejected requests success THEN I get Result success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value('SessionId'));
        when(authLocalDataSource.getUserNif())
            .thenAnswer((_) => Future.value(''));

        when(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).thenAnswer((_) => Future.value(givenRequestListRemoteEntity()));

        final result = await repository.getRejectedRequests(
          page: 1,
          pageSize: 5,
          filter: RequestFilter.initial(),
        );

        verify(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).called(1);
        verify(authLocalDataSource.retrieveSessionId()).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, givenRequestListEntity()),
        );
      },
    );
    test(
      'GIVEN a repository WHEN call to pending requests error THEN I get Result error',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value('SessionId'));
        when(authLocalDataSource.getUserNif())
            .thenAnswer((_) => Future.value(''));

        when(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.getPendingRequests(
          page: 1,
          pageSize: 5,
          filter: RequestFilter.initial(),
        );

        verify(requestRemoteDataSource.getRequests(
          sessionId: anyNamed('sessionId'),
          petition: anyNamed('petition'),
        )).called(1);
        verify(authLocalDataSource.retrieveSessionId()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
  group('Get User Requests Apps', () {
    test(
      'GIVEN a getUserRequestApps WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(
          requestRemoteDataSource.getUserRequestApps(
            sessionId: LiteralsPushVersion.sessionId,
          ),
        ).thenAnswer((_) async => getListRequestAppEntity());
        final res = await repository.getUserRequestApps();

        verify(authLocalDataSource.retrieveSessionId()).called(1);
        verify(requestRemoteDataSource.getUserRequestApps(
          sessionId: LiteralsPushVersion.sessionId,
        )).called(1);
        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a getUserRequestApps WHEN call to repository THEN shor the Result.Failure',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(
          requestRemoteDataSource.getUserRequestApps(
            sessionId: LiteralsPushVersion.sessionId,
          ),
        ).thenThrow(Exception(const RepositoryError.serverError()));
        final res = await repository.getUserRequestApps();

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => true,
        ));
      },
    );
  });
  group('Get All Request Apps', () {
    test(
      'GIVEN a getAllRequestApps WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(authLocalDataSource.retrievePublicKey())
            .thenAnswer((_) async => 'key');
        when(
          requestRemoteDataSource.getAllRequestApps(
            sessionId: LiteralsPushVersion.sessionId,
            publicKeyBase64: 'key',
          ),
        ).thenAnswer((_) async => getListRequestAppEntity());
        final res = await repository.getAllRequestApps();

        verify(authLocalDataSource.retrieveSessionId()).called(1);
        verify(authLocalDataSource.retrievePublicKey()).called(1);
        verify(requestRemoteDataSource.getAllRequestApps(
          sessionId: LiteralsPushVersion.sessionId,
          publicKeyBase64: 'key',
        )).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a getAllRequestApps WHEN call to repository THEN shor the Result.Failure',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(
          authLocalDataSource.retrievePublicKey(),
        ).thenThrow(Exception(const RepositoryError.serverError()));
        final res = await repository.getAllRequestApps();

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => true,
        ));
      },
    );
  });
  group('Get Request Detail', () {
    test(
      'GIVEN a getRequestDetail WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));

        when(requestRemoteDataSource.detailRequest(
          sessionId: LiteralsPushVersion.sessionId,
          requestId: LiteralsPushVersion.requestId,
        )).thenAnswer((_) async => givenDetailRequestEntity);

        final res =
            await repository.getRequestDetail(LiteralsPushVersion.requestId);
        verify(authLocalDataSource.retrieveSessionId()).called(1);
        verify(requestRemoteDataSource.detailRequest(
          sessionId: LiteralsPushVersion.sessionId,
          requestId: LiteralsPushVersion.requestId,
        )).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a getRequestDetail WHEN call to repository THEN show the Result.Failure',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));

        when(requestRemoteDataSource.detailRequest(
          sessionId: '',
          requestId: '',
        )).thenThrow(Exception(const RepositoryError.serverError()));

        final res =
            await repository.getRequestDetail(LiteralsPushVersion.requestId);

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => false,
        ));
      },
    );
  });
  group('Get User Roles', () {
    test(
      'GIVEN a getRequestDetail WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(requestRemoteDataSource.getUserRoles(
          sessionId: LiteralsPushVersion.sessionId,
        )).thenAnswer((_) async => getListUserRoleEntity());
        final res = await repository.getUserRoles();

        verify(authLocalDataSource.retrieveSessionId()).called(1);
        verify(requestRemoteDataSource.getUserRoles(
          sessionId: LiteralsPushVersion.sessionId,
        )).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a getRequestDetail WHEN call to repository THEN show the Result.Failure',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(requestRemoteDataSource.getUserRoles(
          sessionId: LiteralsPushVersion.sessionId,
        )).thenThrow(
          Exception(const RepositoryError.serverError()),
        );
        final res = await repository.getUserRoles();

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => false,
        ));
      },
    );
  });
  group('Get User by Search', () {
    test(
      'GIVEN a getUserBySearch WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(requestRemoteDataSource.getUsersBySearch(
          sessionId: LiteralsPushVersion.sessionId,
          name: LiteralsPushVersion.name,
          mode: 'mode',
        )).thenAnswer((_) async => getListUsersSearchEntity());
        final res =
            await repository.getUserBySearch(LiteralsPushVersion.name, 'mode');

        verify(authLocalDataSource.retrieveSessionId()).called(1);
        verify(requestRemoteDataSource.getUsersBySearch(
          sessionId: LiteralsPushVersion.sessionId,
          name: LiteralsPushVersion.name,
          mode: 'mode',
        )).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a getUserBySearch WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        when(requestRemoteDataSource.getUsersBySearch(
          sessionId: LiteralsPushVersion.sessionId,
          name: LiteralsPushVersion.name,
          mode: 'mode',
        )).thenThrow(Exception(
          const RepositoryError.serverError(),
        ));
        final res =
            await repository.getUserBySearch(LiteralsPushVersion.name, 'mode');

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => false,
        ));
      },
    );
  });
  group('Get Signed Document', () {
    test(
      'GIVEN a getSignedDocument WHEN call to repository THEN show the Result.success',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        final docName =
            '${LiteralsPushVersion.name}${SignReport.signedFile}${DocumentUtils.getSignatureExtension(LiteralsPushVersion.signFormat)}';

        when(
          requestRemoteDataSource.downloadDocument(
            sessionId: LiteralsPushVersion.sessionId,
            documentId: LiteralsPushVersion.id,
            documentName: docName,
            operation: 8,
          ),
        ).thenAnswer((_) async => 'test');

        final res = await repository.getSignedDocument(
          docId: LiteralsPushVersion.id,
          docName: LiteralsPushVersion.name,
          signFormat: LiteralsPushVersion.signFormat,
        );
        verify(authLocalDataSource.retrieveSessionId()).called(1);
        verify(requestRemoteDataSource.downloadDocument(
          sessionId: LiteralsPushVersion.sessionId,
          documentId: LiteralsPushVersion.id,
          documentName: docName,
          operation: 8,
        )).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a getSignedDocument WHEN call to repository THEN show the Result.Failure',
      () async {
        when(authLocalDataSource.retrieveSessionId())
            .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
        final docName =
            '${LiteralsPushVersion.name}${SignReport.signedFile}${DocumentUtils.getSignatureExtension(LiteralsPushVersion.signFormat)}';

        when(
          requestRemoteDataSource.downloadDocument(
            sessionId: LiteralsPushVersion.sessionId,
            documentId: LiteralsPushVersion.id,
            documentName: docName,
            operation: 8,
          ),
        ).thenThrow(Exception(const RepositoryError.serverError()));

        final res = await repository.getSignedDocument(
          docId: LiteralsPushVersion.id,
          docName: LiteralsPushVersion.name,
          signFormat: docName,
        );

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => false,
        ));
      },
    );
  });
  group(
    'Revoked Request Entity',
    () {
      test(
        'GIVEN a revokeRequests WHEN call to repository THEN show the Result.success',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
          when(requestRemoteDataSource.revokeRequests(
            sessionId: LiteralsPushVersion.sessionId,
            reason: 'reason',
            requestIds: [
              LiteralsPushVersion.id,
            ],
          )).thenAnswer((_) async => givenRevokedRequestEntityList());
          final res = await repository
              .revokeRequests(reason: 'reason', requestIds: ['id']);

          verify(authLocalDataSource.retrieveSessionId()).called(1);
          verify(requestRemoteDataSource.revokeRequests(
            sessionId: LiteralsPushVersion.sessionId,
            reason: 'reason',
            requestIds: [
              LiteralsPushVersion.id,
            ],
          )).called(1);

          assert(
            res.when(failure: (e) => false, success: (d) => true),
          );
        },
      );
      test(
        'GIVEN a revokeRequests WHEN call to repository THEN show the Result.success',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
          final res = await repository
              .revokeRequests(reason: 'reason', requestIds: ['id']);

          assert(
            res.when(
              failure: (e) => true,
              success: (d) => false,
            ),
          );
        },
      );
    },
  );
  group(
    'Approve Requests',
    () {
      test(
        'GIVEN a approveRequests WHEN call to repository THEN show the Result.success',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
          when(requestRemoteDataSource.approveRequests(
            sessionId: LiteralsPushVersion.sessionId,
            requestIds: [
              LiteralsPushVersion.id,
            ],
          )).thenAnswer((_) async => givenApprovedRequestEntityList());
          final res = await repository.approveRequests(requestIds: ['id']);

          verify(authLocalDataSource.retrieveSessionId()).called(1);
          verify(requestRemoteDataSource.approveRequests(
            sessionId: LiteralsPushVersion.sessionId,
            requestIds: [
              LiteralsPushVersion.id,
            ],
          )).called(1);
          assert(res.when(
            failure: (e) => false,
            success: (data) => true,
          ));
        },
      );
      test(
        'GIVEN a approveRequests WHEN call to repository THEN show the message failure when Session id is empty',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) async => '');
          final res = await repository.approveRequests(requestIds: ['id']);

          assert(res.when(
            failure: (e) =>
                e ==
                RepositoryError.fromDataSourceError(
                  NetworkError.fromException('Error obtaining session token'),
                ),
            success: (data) => false,
          ));
        },
      );
    },
  );

  group(
    'Validate Petition',
    () {
      test(
        'GIVEN a validatePetition WHEN call to repository THEN show the Result.success',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) => Future.value(LiteralsPushVersion.sessionId));
          when(requestRemoteDataSource.validatePetitions(
            sessionId: LiteralsPushVersion.sessionId,
            petitionId: [
              LiteralsPushVersion.id,
            ],
          )).thenAnswer((_) async => givenValidateRequestEntityList());

          final res = await repository.validatePetition(id: [
            LiteralsPushVersion.id,
          ]);

          verify(authLocalDataSource.retrieveSessionId()).called(1);
          verify(requestRemoteDataSource.validatePetitions(
            sessionId: LiteralsPushVersion.sessionId,
            petitionId: [
              LiteralsPushVersion.id,
            ],
          )).called(1);
          assert(res.when(
            failure: (e) => false,
            success: (data) => true,
          ));
        },
      );
      test(
        'GIVEN a validatePetition WHEN call to repository THEN show the Result.Failure when the sessionId is empty',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) => Future.value(''));

          final res = await repository.validatePetition(id: []);

          assert(res.when(
            failure: (e) =>
                e ==
                RepositoryError.fromDataSourceError(
                  NetworkError.fromException('Error obtaining session token'),
                ),
            success: (data) => false,
          ));
        },
      );
    },
  );
}
