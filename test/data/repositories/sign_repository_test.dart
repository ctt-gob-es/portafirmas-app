import 'dart:convert';
import 'dart:typed_data';

import 'package:firma_portafirmas/models/enum_pf_sign_algorithm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/sign_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/data/repositories/sign_repository.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';

import '../../presentation/instruments/requests_instruments.dart';
import '../instruments/app_version_instruments.dart';
import 'sign_repository_test.mocks.dart';

@GenerateMocks([
  SignRemoteDataSourceContract,
  AuthLocalDataSourceContract,
  CertificateHandlerLocalDataSourceContract,
])
void main() {
  late MockSignRemoteDataSourceContract signRemoteC;
  late MockAuthLocalDataSourceContract authLocalC;
  late MockCertificateHandlerLocalDataSourceContract certHandlerLocalC;
  late SignRepository repo;

  setUp(() {
    signRemoteC = MockSignRemoteDataSourceContract();
    authLocalC = MockAuthLocalDataSourceContract();
    certHandlerLocalC = MockCertificateHandlerLocalDataSourceContract();
    repo = SignRepository(
      signRemoteC,
      authLocalC,
      certHandlerLocalC,
    );
  });

  group('Get Pre Sign with Certificate', () {
    test(
      'GIVEN a preSignWithCert WHEN call to Sign Repository THEN show the Result.Success',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(signRemoteC.preSignWithCert(
          sessionId: LiteralsPushVersion.sessionId,
          signReqs: getListSignRequestPetitionRemoteEntity(),
        )).thenAnswer((_) async => givenPreSignReqEntityList());
        final res = await repo.preSignWithCert(
          signReqs: getListSignRequestPetitionRemoteEntity(),
        );

        verify(authLocalC.retrieveSessionId()).called(1);
        verify(signRemoteC.preSignWithCert(
          sessionId: LiteralsPushVersion.sessionId,
          signReqs: getListSignRequestPetitionRemoteEntity(),
        )).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );

    test(
      'GIVEN a preSignWithCert WHEN call to Sign Repository THEN show the Result.Failure',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);

        when(signRemoteC.preSignWithCert(
          sessionId: LiteralsPushVersion.sessionId,
          signReqs: [],
        )).thenThrow(Exception(const RepositoryError.serverError()));

        final res = await repo.preSignWithCert(
          signReqs: [],
        );

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => false,
        ));
      },
    );
  });

  group('Get Post Sign With Cert', () {
    test(
      'GIVEN a postSignWithCert WHEN call to Sign Repository THEN show the Result.Success',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(signRemoteC.postSignWithCert(
          sessionId: LiteralsPushVersion.sessionId,
          signedReqs: getListSignRequestPetitionRemoteEntity(),
        )).thenAnswer((_) async => givenPostSignReqEntityList());

        final res = await repo.postSignWithCert(
          signedReqs: getListSignRequestPetitionRemoteEntity(),
        );

        verify(authLocalC.retrieveSessionId()).called(1);
        verify(
          signRemoteC.postSignWithCert(
            sessionId: LiteralsPushVersion.sessionId,
            signedReqs: getListSignRequestPetitionRemoteEntity(),
          ),
        ).called(1);

        assert(res.when(
          failure: (e) => false,
          success: (data) => true,
        ));
      },
    );
    test(
      'GIVEN a postSignWithCert WHEN call to Sign Repository THEN show the Result.Failure',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(signRemoteC.postSignWithCert(
          sessionId: LiteralsPushVersion.sessionId,
          signedReqs: [],
        )).thenThrow(Exception(const RepositoryError.serverError()));

        final res = await repo.postSignWithCert(
          signedReqs: [],
        );

        verify(authLocalC.retrieveSessionId()).called(1);

        assert(res.when(
          failure: (e) => e == const RepositoryError.serverError(),
          success: (data) => true,
        ));
      },
    );
  });

  group('Get Pre sign with Clave', () {
    test(
      'GIVEN a preSignWithClave WHEN call to Sign Repository THEN show the Result.Success',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(signRemoteC.preSignWithClave(
          sessionId: LiteralsPushVersion.sessionId,
          requestIds: [
            LiteralsPushVersion.requestId,
          ],
        )).thenAnswer((_) async => givenPreSignClaveEntity);
        final res = await repo.preSignWithClave(requestIds: [
          LiteralsPushVersion.requestId,
        ]);
        verify(authLocalC.retrieveSessionId()).called(1);
        verify(
          signRemoteC.preSignWithClave(
            sessionId: LiteralsPushVersion.sessionId,
            requestIds: [
              LiteralsPushVersion.requestId,
            ],
          ),
        ).called(1);

        assert(
          res.when(failure: (e) => false, success: (data) => true),
        );
      },
    );

    test(
      'GIVEN a preSignWithClave WHEN call to Sign Repository THEN show the Result.Failure',
      () async {
        when(authLocalC.retrieveSessionId())
            .thenAnswer((_) async => LiteralsPushVersion.sessionId);
        when(signRemoteC.preSignWithClave(
          sessionId: LiteralsPushVersion.sessionId,
          requestIds: [],
        )).thenThrow(Exception(const RepositoryError.serverError()));

        final res = await repo.preSignWithClave(requestIds: []);

        assert(
          res.when(
            failure: (e) => e == const RepositoryError.serverError(),
            success: (data) => false,
          ),
        );
      },
    );
  });

  group(
    'Get Post Sign with Clave',
    () {
      test(
        'GIVEN a postSignWithClave WHEN call to Sign Repository THEN show the Result.Success',
        () async {
          when(authLocalC.retrieveSessionId())
              .thenAnswer((_) async => LiteralsPushVersion.sessionId);
          when(signRemoteC.postSignWithClave(
            sessionId: LiteralsPushVersion.sessionId,
          )).thenAnswer((_) async => givenPostSignClaveEntity);

          final res = await repo.postSignWithClave();

          verify(authLocalC.retrieveSessionId()).called(1);
          verify(signRemoteC.postSignWithClave(
            sessionId: LiteralsPushVersion.sessionId,
          )).called(1);

          assert(res.when(failure: (e) => false, success: (data) => true));
        },
      );
      test(
        'GIVEN a postSignWithClave WHEN call to Sign Repository THEN show the Result.Failure',
        () async {
          when(authLocalC.retrieveSessionId())
              .thenAnswer((_) async => LiteralsPushVersion.sessionId);
          when(signRemoteC.postSignWithClave(
            sessionId: LiteralsPushVersion.sessionId,
          )).thenThrow(Exception(const RepositoryError.serverError()));

          final res = await repo.postSignWithClave();

          assert(res.when(
            failure: (e) => e == const RepositoryError.serverError(),
            success: (data) => false,
          ));
        },
      );
    },
  );

  group(
    'Get Sign with Cert',
    () {
      test(
        'GIVEN a signWithCert WHEN call to Sign Repository THEN show the Result.Success',
        () async {
          PfSignAlgorithm signAlgo = PfSignAlgorithm.fromString(
            '${getPreSignReqEntity().signDocs.first.signAlgo.replaceAll('-', '')}${SignDocument.rsaSuffix}',
          );
          Uint8List decodedPreSign =
              base64Decode(getPreSignReqEntity().signDocs.first.preSignContent);
          when(certHandlerLocalC.signWithDefaultCertificate(
            decodedPreSign,
            signAlgo,
          )).thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));
          final res =
              await repo.signWithCert(preSignedRequest: getPreSignReqEntity());

          verify(certHandlerLocalC.signWithDefaultCertificate(
            decodedPreSign,
            signAlgo,
          )).called(1);

          assert(res.when(
            failure: (e) => false,
            success: (data) => true,
          ));
        },
      );
      test(
        'GIVEN a signWithCert WHEN call to Sign Repository THEN show the Result.Failure',
        () async {
          final res =
              await repo.signWithCert(preSignedRequest: getPreSignReqEntity());

          assert(res.when(
            failure: (e) => e == const RepositoryError.serverError(),
            success: (data) => false,
          ));
        },
      );
    },
  );

  test(
    'GIVEN a getAuthMethod WHEN call to Sign Repository THEN show the last Auth Method  Cetificate',
    () async {
      when(authLocalC.getLastAuthMethod())
          .thenAnswer((_) async => 'certificate');
      final res = await repo.getAuthMethod();

      verify(authLocalC.getLastAuthMethod()).called(1);
      expect(res, const AuthMethod.certificate());
    },
  );
  test(
    'GIVEN a getAuthMethod WHEN call to Sign Repository THEN show the last Auth Method Clave',
    () async {
      when(authLocalC.getLastAuthMethod()).thenAnswer((_) async => 'clave');
      final res = await repo.getAuthMethod();

      verify(authLocalC.getLastAuthMethod()).called(1);
      expect(res, const AuthMethod.clave());
    },
  );
}
