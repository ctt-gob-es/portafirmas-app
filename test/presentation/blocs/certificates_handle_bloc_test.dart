import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/models/result_check_certificate.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificate_status_check.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';

import '../../data/instruments/certificate_instruments.dart';
import '../../data/instruments/general_instruments.dart';

import 'certificates_handle_bloc_test.mocks.dart';

@GenerateMocks([CertificateRepositoryContract])
void main() {
  late MockCertificateRepositoryContract certificateRepository;
  late CertificatesHandleBloc certificatesHandleBloc;

  setUp(() {
    certificateRepository = MockCertificateRepositoryContract();
    certificatesHandleBloc = CertificatesHandleBloc(
      repositoryContract: certificateRepository,
    );
  });

  group('Check certificates event', () {
    blocTest(
      'GIVEN handle certificates bloc WHEN check certificates with certificate selected THEN state is selected certificate',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.checkCertificates()).thenAnswer(
          (_) async => ResultCheckCertificate.hasCertificateSelected(
            givenCertificateEntity(),
          ),
        );

        bloc.add(const CertificatesHandleEvent.checkCertificates());
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.loading(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
        CertificatesHandleState(
          certificateCheck:
              const CertificateStatusCheck.goToCertificateServerScreen(),
          attemptsSelectCertificate: 0,
          defaultCertificate: givenCertificateEntity(),
          selectDefaultCertificateStatus: const ScreenStatus.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN handle certificates bloc WHEN check certificates with error THEN state is error',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.checkCertificates()).thenAnswer(
          (_) async => const ResultCheckCertificate.failure(
            error: RepositoryError.serverError(),
          ),
        );

        bloc.add(const CertificatesHandleEvent.checkCertificates());
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.loading(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
        const CertificatesHandleState(
          certificateCheck:
              CertificateStatusCheck.error(RepositoryError.serverError()),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN handle certificates bloc WHEN check certificates with no certificate selected THEN state is no certificate',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.checkCertificates()).thenAnswer(
          (_) async => const ResultCheckCertificate.noCertificateSelected(),
        );

        bloc.add(const CertificatesHandleEvent.checkCertificates());
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.loading(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
        const CertificatesHandleState(
          certificateCheck:
              CertificateStatusCheck.goToCertificateServerScreen(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN handle certificates bloc WHEN check certificates with no certificates in ios THEN state is no certificate',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.checkCertificates()).thenAnswer(
          (_) async =>
              const ResultCheckCertificate.userHasNoCertificatesOnIOS(),
        );

        bloc.add(const CertificatesHandleEvent.checkCertificates());
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.loading(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.goToAddCertificate(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
      ],
    );
  });
  group('Choose default certificate', () {
    blocTest(
      'GIVEN handle certificates bloc WHEN choose default certificate success THEN state is with new certificate',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.changeDefaultCertificate(any)).thenAnswer(
          (_) async => Result.success(givenCertificateEntity()),
        );

        when(certificateRepository.setCertificateDefault(any)).thenAnswer(
          (_) async => const Result.success(''),
        );

        bloc.add(
          CertificatesHandleEvent.chooseDefaultCertificate(givenContext()),
        );
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.loading(),
        ),
        CertificatesHandleState(
          certificateCheck: const CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 1,
          defaultCertificate: givenCertificateEntity(),
          selectDefaultCertificateStatus: const ScreenStatus.success(),
        ),
      ],
    );
    blocTest(
      'GIVEN handle certificates bloc WHEN choose default certificate with error THEN state is error',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.changeDefaultCertificate(any)).thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.serverError()),
        );

        bloc.add(
          CertificatesHandleEvent.chooseDefaultCertificate(givenContext()),
        );
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.loading(),
        ),
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus:
              ScreenStatus.error(RepositoryError.serverError()),
        ),
      ],
    );
  });
  group('Reload default certificate', () {
    blocTest(
      'GIVEN handle certificates bloc WHEN reload default certificate success THEN state is with new certificate',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.getDefaultCertificate()).thenAnswer(
          (_) async => Result.success(givenCertificateEntity()),
        );

        bloc.add(const CertificatesHandleEvent.reloadDefaultCertificate());
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.loading(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
        CertificatesHandleState(
          certificateCheck: const CertificateStatusCheck.idle(),
          attemptsSelectCertificate: 0,
          defaultCertificate: givenCertificateEntity(),
          selectDefaultCertificateStatus: const ScreenStatus.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN handle certificates bloc WHEN reload default certificate with error THEN state is error',
      build: () => certificatesHandleBloc,
      act: (CertificatesHandleBloc bloc) {
        when(certificateRepository.getDefaultCertificate()).thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.serverError()),
        );

        bloc.add(const CertificatesHandleEvent.reloadDefaultCertificate());
      },
      expect: () => [
        const CertificatesHandleState(
          certificateCheck: CertificateStatusCheck.loading(),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
        const CertificatesHandleState(
          certificateCheck:
              CertificateStatusCheck.error(RepositoryError.serverError()),
          attemptsSelectCertificate: 0,
          defaultCertificate: null,
          selectDefaultCertificateStatus: ScreenStatus.initial(),
        ),
      ],
    );
  });
}
