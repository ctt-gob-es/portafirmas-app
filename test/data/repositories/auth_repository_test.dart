import 'package:firma_portafirmas/models/enum_pf_sign_algorithm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/repositories/auth_repository.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/auth_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/auth_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';

import '../instruments/auth_data_instruments.dart';
import '../instruments/certificate_instruments.dart';
import 'auth_repository_test.mocks.dart';

@GenerateMocks([
  AuthRemoteDataSourceContract,
  AuthLocalDataSourceContract,
  CertificateHandlerLocalDataSourceContract,
])
void main() {
  late MockAuthRemoteDataSourceContract authRemoteDataSource;
  late MockAuthLocalDataSourceContract authLocalDataSource;
  late MockCertificateHandlerLocalDataSourceContract
      certificateHandlerLocalDataSource;
  late AuthRepository repository;

  setUp(() {
    authRemoteDataSource = MockAuthRemoteDataSourceContract();
    authLocalDataSource = MockAuthLocalDataSourceContract();
    certificateHandlerLocalDataSource =
        MockCertificateHandlerLocalDataSourceContract();
    repository = AuthRepository(
      authRemoteDataSource,
      authLocalDataSource,
      certificateHandlerLocalDataSource,
    );
  });

  group('Login method', () {
    test(
      'GIVEN a repository WHEN call to loginWithDefaultCertificate with default certificate THEN I get Result success',
      () async {
        when(authRemoteDataSource.preLogin())
            .thenAnswer((_) => Future.value(givenPreLoginRemoteEntity()));

        when(authLocalDataSource.saveSessionId(any))
            .thenAnswer((_) => Future.value());

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => givenCertificateLocalEntity());

        when(certificateHandlerLocalDataSource.signWithDefaultCertificate(
          any,
          any,
        )).thenAnswer((_) => Future.value(givenUInt8List()));

        when(authRemoteDataSource.loginWithCertificate(
          sessionId: anyNamed('sessionId'),
          loginTokenSignedBase64: anyNamed('loginTokenSignedBase64'),
          publicKeyBase64: anyNamed('publicKeyBase64'),
        )).thenAnswer((_) => Future.value('nif'));

        final result = await repository.loginWithDefaultCertificate();

        verify(authRemoteDataSource.preLogin()).called(1);
        verify(authLocalDataSource.saveSessionId(any)).called(1);
        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);
        verify(certificateHandlerLocalDataSource.signWithDefaultCertificate(
          any,
          PfSignAlgorithm.sha256rsa,
        )).called(1);
        verify(authRemoteDataSource.loginWithCertificate(
          sessionId: anyNamed('sessionId'),
          loginTokenSignedBase64: anyNamed('loginTokenSignedBase64'),
          publicKeyBase64: anyNamed('publicKeyBase64'),
        )).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          noDefaultCertificate: () =>
              fail('Should have returned a success result'),
          success: (data) => expect(data, 'nif'),
        );
      },
    );
    test(
      'GIVEN a repository WHEN call to loginWithDefaultCertificate with error THEN I get Result error',
      () async {
        when(authRemoteDataSource.preLogin())
            .thenAnswer((_) => Future.value(givenPreLoginRemoteEntity()));

        when(authLocalDataSource.saveSessionId(any))
            .thenAnswer((_) => Future.value());

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => givenCertificateLocalEntity());

        when(certificateHandlerLocalDataSource.signWithDefaultCertificate(
          any,
          any,
        )).thenAnswer((_) => Future.value(givenUInt8List()));

        when(authRemoteDataSource.loginWithCertificate(
          sessionId: anyNamed('sessionId'),
          loginTokenSignedBase64: anyNamed('loginTokenSignedBase64'),
          publicKeyBase64: anyNamed('publicKeyBase64'),
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.loginWithDefaultCertificate();

        verify(authRemoteDataSource.preLogin()).called(1);
        verify(authLocalDataSource.saveSessionId(any)).called(1);
        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);
        verify(certificateHandlerLocalDataSource.signWithDefaultCertificate(
          any,
          any,
        )).called(1);
        verify(authRemoteDataSource.loginWithCertificate(
          sessionId: anyNamed('sessionId'),
          loginTokenSignedBase64: anyNamed('loginTokenSignedBase64'),
          publicKeyBase64: anyNamed('publicKeyBase64'),
        )).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          noDefaultCertificate: () =>
              fail('Should have returned a error result'),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to loginWithDefaultCertificate with no default certificate THEN I get Result no certificate',
      () async {
        when(authRemoteDataSource.preLogin())
            .thenAnswer((_) => Future.value(givenPreLoginRemoteEntity()));

        when(authLocalDataSource.saveSessionId(any))
            .thenAnswer((_) => Future.value());

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => null);

        when(certificateHandlerLocalDataSource.signWithDefaultCertificate(
          any,
          any,
        )).thenAnswer((_) => Future.value(givenUInt8List()));

        when(authRemoteDataSource.loginWithCertificate(
          sessionId: anyNamed('sessionId'),
          loginTokenSignedBase64: anyNamed('loginTokenSignedBase64'),
          publicKeyBase64: anyNamed('publicKeyBase64'),
        )).thenAnswer((_) => Future.value('nif'));

        final result = await repository.loginWithDefaultCertificate();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);
        verifyNever(
          certificateHandlerLocalDataSource.signWithDefaultCertificate(
            any,
            any,
          ),
        );
        verifyNever(authLocalDataSource.saveSessionId(any));
        verifyNever(authRemoteDataSource.preLogin());
        verifyNever(authRemoteDataSource.loginWithCertificate(
          sessionId: anyNamed('sessionId'),
          loginTokenSignedBase64: anyNamed('loginTokenSignedBase64'),
          publicKeyBase64: anyNamed('publicKeyBase64'),
        ));

        result.when(
          failure: (error) =>
              fail('Should have returned a noDefaultCertificate result'),
          noDefaultCertificate: () => DoNothingAction(),
          success: (data) =>
              fail('Should have returned a noDefaultCertificate result'),
        );
      },
    );

    group('Get last auth method', () {
      test(
        'GIVEN a repository WHEN getLastAuthMethod is called and an error occurs THEN return Result failure',
        () async {
          when(authLocalDataSource.getLastAuthMethod())
              .thenThrow(Exception('Unexpected error'));

          final result = await repository.getLastAuthMethod();

          verify(authLocalDataSource.getLastAuthMethod()).called(1);

          result.when(
            success: (authMethod) =>
                fail('Should have returned a failure result'),
            failure: (error) => expect(error, isA<RepositoryError>()),
          );
        },
      );
    });

    group('Set Last Auth Method', () {
      test(
        'GIVEN a repository WHEN setLastAuthMethod fails THEN it returns Result.failure',
        () async {
          when(authLocalDataSource.setLastAuthMethod(any))
              .thenThrow(Exception('Unexpected error'));

          final result = await repository.setLastAuthMethod(
            const AuthMethod.certificate(),
          );

          verify(authLocalDataSource.setLastAuthMethod(any));
          result.when(
            success: (isSet) => fail('Should have returned a failure result'),
            failure: (error) => expect(error, isA<RepositoryError>()),
          );
        },
      );
    });

    group('Save Session ID', () {
      test(
        'GIVEN a repository WHEN saveSessionId is called THEN it delegates to local data source',
        () async {
          when(authLocalDataSource.saveSessionId(any))
              .thenAnswer((_) => Future.value());

          await repository.saveSessionId(sessionId: 'someSessionId');

          verify(authLocalDataSource.saveSessionId('someSessionId'));
        },
      );
    });

    group('Is User First Time', () {
      test(
        'GIVEN a repository WHEN isUserFirstTime is called THEN return Result.success with true',
        () async {
          when(authLocalDataSource.isUserFirstTime())
              .thenAnswer((_) async => true);

          final result = await repository.isUserFirstTime();

          verify(authLocalDataSource.isUserFirstTime()).called(1);

          result.when(
            success: (isFirstTime) => expect(isFirstTime, isTrue),
            failure: (error) => fail('Should have returned a success result'),
          );
        },
      );

      test(
        'GIVEN a repository WHEN isUserFirstTime is called THEN return Result.success with false',
        () async {
          when(authLocalDataSource.isUserFirstTime())
              .thenAnswer((_) async => false);

          final result = await repository.isUserFirstTime();

          verify(authLocalDataSource.isUserFirstTime()).called(1);

          result.when(
            success: (isFirstTime) => expect(isFirstTime, isFalse),
            failure: (error) => fail('Should have returned a success result'),
          );
        },
      );
    });

    group('Set First Time', () {
      test(
        'GIVEN a repository WHEN setFirstTime is called THEN it marks the user as not first time',
        () async {
          when(authLocalDataSource.setFirstTime())
              .thenAnswer((_) => Future.value());

          final result = await repository.setFirstTime();

          verify(authLocalDataSource.setFirstTime()).called(1);

          result.when(
            success: (isSet) => expect(isSet, isTrue),
            failure: (error) => fail('Should have returned a success result'),
          );
        },
      );
    });

    group('LogOut Method', () {
      test(
        'GIVEN no session ID WHEN logOut is called THEN return failure',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) async => null);

          final result = await repository.logOut(true);

          verify(authLocalDataSource.retrieveSessionId());
          verifyNever(
            authRemoteDataSource.logOut(
              sessionId: anyNamed('sessionId'),
            ),
          );
          verifyNever(authLocalDataSource.removeSessionId());
          verifyNever(authLocalDataSource.deleteLastAuthMethod());

          result.when(
            success: (data) => fail('Should have returned failure'),
            failure: (error) =>
                expect(error, const RepositoryError.serverError()),
          );
        },
      );

      test(
        'GIVEN a repository when logOut throws an error THEN return failure',
        () async {
          when(authLocalDataSource.retrieveSessionId())
              .thenAnswer((_) async => 'someSessionId');
          when(authRemoteDataSource.logOut(sessionId: anyNamed('sessionId')))
              .thenThrow(Exception('Unexpected error'));

          final result = await repository.logOut(true);

          verify(authLocalDataSource.retrieveSessionId());
          verify(authRemoteDataSource.logOut(sessionId: 'someSessionId'))
              .called(1);
          verifyNever(authLocalDataSource.removeSessionId());
          verifyNever(authLocalDataSource.deleteLastAuthMethod());

          result.when(
            success: (data) => fail('Should have returned failure'),
            failure: (error) => expect(error, isA<RepositoryError>()),
          );
        },
      );
    });
  });
}
