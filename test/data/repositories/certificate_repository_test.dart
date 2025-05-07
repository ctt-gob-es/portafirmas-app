import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/repositories/certificate_repository.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/certificate_handler_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

import '../instruments/auth_data_instruments.dart';
import '../instruments/certificate_instruments.dart';
import '../instruments/general_instruments.dart';
import 'certificate_repository_test.mocks.dart';

@GenerateMocks([
  CertificateHandlerLocalDataSourceContract,
])
void main() {
  late MockCertificateHandlerLocalDataSourceContract
      certificateHandlerLocalDataSource;
  late CertificateRepository repository;

  setUp(() {
    certificateHandlerLocalDataSource =
        MockCertificateHandlerLocalDataSourceContract();
    repository = CertificateRepository(
      certificateHandlerLocalDataSource,
    );
  });

  group('Check certificates', () {
    test(
      'GIVEN a repository WHEN call to checkCertificates with default certificate in Android THEN I get Result hasCertificateSelected',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => givenCertificateLocalEntity());

        final result = await repository.checkCertificates();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        result.when(
          failure: (error) =>
              fail('Should have returned a hasCertificateSelected result'),
          hasCertificateSelected: (cert) =>
              expect(cert, givenCertificateEntity()),
          noCertificateSelected: () =>
              fail('Should have returned a hasCertificateSelected result'),
          userHasNoCertificatesOnIOS: () =>
              fail('Should have returned a hasCertificateSelected result'),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to checkCertificates with default certificate in ios THEN I get Result hasCertificateSelected',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => givenCertificateLocalEntity());

        final result = await repository.checkCertificates();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        result.when(
          failure: (error) =>
              fail('Should have returned a hasCertificateSelected result'),
          hasCertificateSelected: (cert) =>
              expect(cert, givenCertificateEntity()),
          noCertificateSelected: () =>
              fail('Should have returned a hasCertificateSelected result'),
          userHasNoCertificatesOnIOS: () =>
              fail('Should have returned a hasCertificateSelected result'),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to checkCertificates with no default certificate in Android THEN I get Result noCertificateSelected',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => null);

        final result = await repository.checkCertificates();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        result.when(
          failure: (error) =>
              fail('Should have returned a noCertificateSelected result'),
          hasCertificateSelected: (cert) =>
              fail('Should have returned a noCertificateSelected result'),
          noCertificateSelected: () => DoNothingAction(),
          userHasNoCertificatesOnIOS: () =>
              fail('Should have returned a noCertificateSelected result'),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to checkCertificates with no default certificate and with certificates in iOS THEN I get Result noCertificateSelected',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => null);

        when(certificateHandlerLocalDataSource.userHasCertificates())
            .thenAnswer((_) async => true);

        final result = await repository.checkCertificates();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        verify(certificateHandlerLocalDataSource.userHasCertificates())
            .called(1);

        result.when(
          failure: (error) =>
              fail('Should have returned a noCertificateSelected result'),
          hasCertificateSelected: (cert) =>
              fail('Should have returned a noCertificateSelected result'),
          noCertificateSelected: () => DoNothingAction(),
          userHasNoCertificatesOnIOS: () =>
              fail('Should have returned a noCertificateSelected result'),
        );
      },
    );
    test(
      'GIVEN a repository WHEN call to checkCertificates with no default certificate and no certificates in iOS THEN I get Result userHasNoCertificatesOnIOS',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => null);

        when(certificateHandlerLocalDataSource.userHasCertificates())
            .thenAnswer((_) async => false);

        final result = await repository.checkCertificates();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        verify(certificateHandlerLocalDataSource.userHasCertificates())
            .called(1);

        result.when(
          failure: (error) =>
              fail('Should have returned a userHasNoCertificatesOnIOS result'),
          hasCertificateSelected: (cert) =>
              fail('Should have returned a userHasNoCertificatesOnIOS result'),
          noCertificateSelected: () =>
              fail('Should have returned a userHasNoCertificatesOnIOS result'),
          userHasNoCertificatesOnIOS: () => DoNothingAction(),
        );
      },
    );
  });

  group('add certificate', () {
    test(
      'GIVEN a repository WHEN call to addCertificate success THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.addCertificate(
          context: anyNamed('context'),
          certificate: anyNamed('certificate'),
        )).thenAnswer((_) => Future.value());
        final result = await repository.addCertificate(
          context: givenContext(),
          certificate: givenUInt8List(),
        );

        verify(certificateHandlerLocalDataSource.addCertificate(
          context: anyNamed('context'),
          certificate: anyNamed('certificate'),
        )).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => DoNothingAction(),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to addCertificate error THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.addCertificate(
          context: anyNamed('context'),
          certificate: anyNamed('certificate'),
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.addCertificate(
          context: givenContext(),
          certificate: givenUInt8List(),
        );

        verify(certificateHandlerLocalDataSource.addCertificate(
          context: anyNamed('context'),
          certificate: anyNamed('certificate'),
        )).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('delete certificate', () {
    test(
      'GIVEN a repository WHEN call to deleteCertificate success THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.deleteCertificate(
          any,
        )).thenAnswer((_) => Future.value());

        final result = await repository.deleteCertificate(
          givenCertificateEntity(),
        );

        verify(certificateHandlerLocalDataSource.deleteCertificate(any))
            .called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => DoNothingAction(),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to deleteCertificate error THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.deleteCertificate(any))
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.deleteCertificate(
          givenCertificateEntity(),
        );

        verify(certificateHandlerLocalDataSource.deleteCertificate(any))
            .called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('get all certificates', () {
    test(
      'GIVEN a repository WHEN call to getAllCertificates success THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.getAllCertificates())
            .thenAnswer((_) async => [givenCertificateLocalEntity()]);

        final result = await repository.getAllCertificates();

        verify(certificateHandlerLocalDataSource.getAllCertificates())
            .called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, [givenCertificateEntity()]),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to getAllCertificates error THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.getAllCertificates())
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.getAllCertificates();

        verify(certificateHandlerLocalDataSource.getAllCertificates())
            .called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('set certificate default', () {
    test(
      'GIVEN a repository WHEN call to setCertificateDefault success THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.setCertificateDefault(
          any,
        )).thenAnswer((_) => Future.value());

        final result = await repository.setCertificateDefault(
          givenCertificateEntity(),
        );

        verify(certificateHandlerLocalDataSource.setCertificateDefault(any))
            .called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => DoNothingAction(),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to setCertificateDefault error THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.setCertificateDefault(any))
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.setCertificateDefault(
          givenCertificateEntity(),
        );

        verify(certificateHandlerLocalDataSource.setCertificateDefault(any))
            .called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('get default certificate', () {
    test(
      'GIVEN a repository WHEN call to getDefaultCertificate success THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenAnswer((_) async => givenCertificateLocalEntity());

        final result = await repository.getDefaultCertificate();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, givenCertificateEntity()),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to getDefaultCertificate error THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.getDefaultCertificate())
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.getDefaultCertificate();

        verify(certificateHandlerLocalDataSource.getDefaultCertificate())
            .called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('change default certificate', () {
    test(
      'GIVEN a repository WHEN call to changeDefaultCertificate success THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.selectDefaultCertificate(
          context: anyNamed('context'),
        )).thenAnswer((_) async => givenCertificateLocalEntity());

        final result =
            await repository.changeDefaultCertificate(givenContext());

        verify(certificateHandlerLocalDataSource.selectDefaultCertificate(
          context: anyNamed('context'),
        )).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, givenCertificateEntity()),
        );
      },
    );

    test(
      'GIVEN a repository WHEN call to changeDefaultCertificate error THEN get Result success',
      () async {
        when(certificateHandlerLocalDataSource.selectDefaultCertificate(
          context: anyNamed('context'),
        )).thenThrow(Exception('Unexpected error'));

        final result =
            await repository.changeDefaultCertificate(givenContext());

        verify(certificateHandlerLocalDataSource.selectDefaultCertificate(
          context: anyNamed('context'),
        )).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
}
