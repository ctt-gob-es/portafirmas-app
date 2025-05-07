import 'dart:typed_data';

import 'package:firma_portafirmas/firma_portafirmas_interface.dart';
import 'package:firma_portafirmas/models/enum_pf_sign_algorithm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/certificate_handler_local_data_source.dart';

import '../../instruments/certificate_instruments.dart';
import 'certificate_handler_local_data_source_test.mocks.dart';

@GenerateMocks([FirmaPortafirmasInterface])
main() {
  late MockFirmaPortafirmasInterface firmaPortafirmasInterface;

  late CertificateHandlerLocalDataSource localDataSource;

  setUp(() {
    firmaPortafirmasInterface = MockFirmaPortafirmasInterface();

    localDataSource = CertificateHandlerLocalDataSource(
      firmaPortafirmasInterface,
    );
  });

  test(
    'GIVEN certificate handler local datasource WHEN get default certificate THEN return default certificate',
    () async {
      when(firmaPortafirmasInterface.getDefaultCertificate())
          .thenAnswer((_) async => givenPfCertificateInfo());

      final result = await localDataSource.getDefaultCertificate();
      expect(result, givenCertificateLocalEntity());
    },
  );

  test(
    'GIVEN certificate handler local datasource WHEN get default certificate null THEN return null',
    () async {
      when(firmaPortafirmasInterface.getDefaultCertificate())
          .thenAnswer((_) async => null);

      final result = await localDataSource.getDefaultCertificate();
      expect(result, null);
    },
  );
  test(
    'GIVEN certificate handler local datasource WHEN signWithDefaultCertificate THEN return signed data',
    () async {
      final data = Uint8List(0);
      when(firmaPortafirmasInterface.signWithDefaultCertificate(any))
          .thenAnswer((_) async => data);
      final result = await localDataSource.signWithDefaultCertificate(
        Uint8List(0),
        PfSignAlgorithm.sha1rsa,
      );

      expect(result, data);
    },
  );
  test(
    'GIVEN certificate handler local datasource WHEN addCertificate THEN no errors throw',
    () async {
      when(firmaPortafirmasInterface.addCertificate(
        context: anyNamed('context'),
        certificate: anyNamed('certificate'),
      )).thenAnswer((_) => Future.value());
      bool hasError = false;
      try {
        await localDataSource.addCertificate(
          context: const SizedBox().createElement(),
          certificate: Uint8List(0),
        );
      } catch (e) {
        hasError = true;
      }

      expect(hasError, false);
    },
  );
  test(
    'GIVEN certificate handler local datasource WHEN call selectDefaultCertificate THEN return selected certificate',
    () async {
      when(firmaPortafirmasInterface.selectDefaultCertificate(any))
          .thenAnswer((_) async => givenPfCertificateInfo());

      final result = await localDataSource.selectDefaultCertificate(
        context: const SizedBox().createElement(),
      );
      expect(result, givenCertificateLocalEntity());
    },
  );

  test(
    'GIVEN certificate handler local datasource WHEN call selectDefaultCertificate when null THEN return selected certificate',
    () async {
      when(firmaPortafirmasInterface.selectDefaultCertificate(any))
          .thenAnswer((_) async => null);

      final result = await localDataSource.selectDefaultCertificate(
        context: const SizedBox().createElement(),
      );
      expect(result, null);
    },
  );
  test(
    'GIVEN certificate handler local datasource WHEN call userHasCertificates when has certificates THEN return true',
    () async {
      when(firmaPortafirmasInterface.getAllCertificates())
          .thenAnswer((_) async => [givenPfCertificateInfo()]);

      final result = await localDataSource.userHasCertificates();
      expect(result, true);
    },
  );
  test(
    'GIVEN certificate handler local datasource WHEN call userHasCertificates when not has certificates THEN return false',
    () async {
      when(firmaPortafirmasInterface.getAllCertificates())
          .thenAnswer((_) async => []);

      final result = await localDataSource.userHasCertificates();
      expect(result, false);
    },
  );

  test(
    'GIVEN certificate handler local datasource WHEN deleteCertificate THEN no errors throw',
    () async {
      when(firmaPortafirmasInterface.deleteCertificateBySerialNumber(any))
          .thenAnswer((_) => Future.value());
      bool hasError = false;
      try {
        await localDataSource.deleteCertificate('');
      } catch (e) {
        hasError = true;
      }

      expect(hasError, false);
    },
  );

  test(
    'GIVEN certificate handler local datasource WHEN call getAllCertificates THEN return list with certificates',
    () async {
      when(firmaPortafirmasInterface.getAllCertificates())
          .thenAnswer((_) async => [givenPfCertificateInfo()]);

      final result = await localDataSource.getAllCertificates();
      expect(result, [givenCertificateLocalEntity()]);
    },
  );
  test(
    'GIVEN certificate handler local datasource WHEN setCertificateDefault THEN no errors throw',
    () async {
      when(firmaPortafirmasInterface.setDefaultCertificateBySerialNumber(any))
          .thenAnswer((_) => Future.value());
      bool hasError = false;
      try {
        await localDataSource.setCertificateDefault('');
      } catch (e) {
        hasError = true;
      }

      expect(hasError, false);
    },
  );
}
