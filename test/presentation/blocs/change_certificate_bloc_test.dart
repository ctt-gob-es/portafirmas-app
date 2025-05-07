import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/types/screen_status_with_result.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/change_certificate_ios/change_certificate_bloc/change_certificate_bloc.dart';

import '../../data/instruments/certificate_instruments.dart';
import 'change_certificate_bloc_test.mocks.dart';

@GenerateMocks([CertificateRepositoryContract])
void main() {
  late MockCertificateRepositoryContract certificateRepository;
  late ChangeCertificateBloc changeCertificateBloc;

  setUp(() {
    certificateRepository = MockCertificateRepositoryContract();
    changeCertificateBloc = ChangeCertificateBloc(
      certificateRepositoryContract: certificateRepository,
    );
  });

  group('Check Change Certificate events', () {
    blocTest(
      'GIVEN a Success result WHEN call to event loadAllCertificates THEN show the list of certificates',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository.getAllCertificates()).thenAnswer(
          (_) async => Result.success(
            givenListCertificateEntity(),
          ),
        );
        when(certificateRepository.getDefaultCertificate()).thenAnswer(
          (_) async => Result.success(
            givenCertificateEntity(),
          ),
        );

        bloc.add(const ChangeCertificateEvent.loadAllCertificates());
      },
      expect: () => [
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.loading(),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: givenListCertificateEntity(),
          certificateListStatus: const ScreenStatus.success(),
          certificateChangeDefaultStatus: const ScreenStatus.initial(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN a Failure result WHEN call to event loadAllCertificates THEN show the list of certificates',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository.getAllCertificates()).thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.notFoundResource()),
        );
        when(certificateRepository.getDefaultCertificate()).thenAnswer(
          (_) async => Result.success(
            givenCertificateEntity(),
          ),
        );

        bloc.add(const ChangeCertificateEvent.loadAllCertificates());
      },
      expect: () => [
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.loading(),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus:
              ScreenStatus.error(RepositoryError.notFoundResource()),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN a certificate WHEN call to event changePreselectedCertificate THEN emit he correct state',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) => bloc.add(
        ChangeCertificateEvent.changePreselectedCertificate(
          givenCertificateEntity(),
        ),
      ),
      expect: () => [
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.initial(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN a preSelectedCertificate WHEN call to event setPreselectedCertificateDefault THEN emit the correct initial state',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        bloc.add(
          const ChangeCertificateEvent.setPreselectedCertificateDefault(),
        );
      },
      expect: () => [
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.initial(),
          certificateChangeDefaultStatus: ScreenStatus.loading(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.initial(),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN a preSelectedCertificate WHEN call to event setPreselectedCertificateDefault THEN emit the correct state success',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository
                .setCertificateDefault(givenCertificateEntity()))
            .thenAnswer(
          (_) async => Result.success(
            givenListCertificateEntity(),
          ),
        );
        bloc.emit(
          ChangeCertificateState(
            preselectedCertificate: givenCertificateEntity(),
            certificates: [givenCertificateEntity()],
            certificateListStatus: const ScreenStatus.initial(),
            certificateChangeDefaultStatus: const ScreenStatus.loading(),
            certificateDeleteStatus: const ScreenStatusWithResult.initial(),
          ),
        );
        bloc.add(
          const ChangeCertificateEvent.setPreselectedCertificateDefault(),
        );
      },
      expect: () => [
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.success(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN a preSelectedCertificate WHEN call to event setPreselectedCertificateDefault THEN emit the failure state',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository
                .setCertificateDefault(givenCertificateEntity()))
            .thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.notFoundResource()),
        );
        bloc.emit(
          ChangeCertificateState(
            preselectedCertificate: givenCertificateEntity(),
            certificates: [givenCertificateEntity()],
            certificateListStatus: const ScreenStatus.initial(),
            certificateChangeDefaultStatus: const ScreenStatus.loading(),
            certificateDeleteStatus: const ScreenStatusWithResult.initial(),
          ),
        );
        bloc.add(
          const ChangeCertificateEvent.setPreselectedCertificateDefault(),
        );
      },
      expect: () => [
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus:
              const ScreenStatus.error(RepositoryError.notFoundResource()),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
      ],
    );

    blocTest(
      'GIVEN a preSelectedCertificate WHEN call to event deletePreselectedCertificate THEN emit the initial state',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository.deleteCertificate(givenCertificateEntity()))
            .thenAnswer(
          (_) async => Result.success(
            givenCertificateEntity(),
          ),
        );

        bloc.add(
          const ChangeCertificateEvent.deletePreselectedCertificate(),
        );
      },
      expect: () => [
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.initial(),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.loading(),
        ),
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.initial(),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
      ],
    );
    blocTest(
      'GIVEN a preSelectedCertificate WHEN call to event deletePreselectedCertificate THEN emit the success',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository.deleteCertificate(givenCertificateEntity()))
            .thenAnswer(
          (_) async => Result.success(ChangeCertificateState(
            preselectedCertificate: null,
            certificates: [givenCertificateEntity()]
              ..remove(changeCertificateBloc.state.preselectedCertificate),
            certificateListStatus: const ScreenStatus.initial(),
            certificateChangeDefaultStatus: const ScreenStatus.loading(),
            certificateDeleteStatus: const ScreenStatusWithResult.initial(),
          )),
        );

        bloc.emit(
          ChangeCertificateState(
            preselectedCertificate: givenCertificateEntity(),
            certificates: [givenCertificateEntity()],
            certificateListStatus: const ScreenStatus.initial(),
            certificateChangeDefaultStatus: const ScreenStatus.loading(),
            certificateDeleteStatus: const ScreenStatusWithResult.initial(),
          ),
        );

        bloc.add(
          const ChangeCertificateEvent.deletePreselectedCertificate(),
        );
      },
      expect: () => [
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.loading(),
        ),
        ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus:
              ScreenStatusWithResult.success(givenCertificateEntity()),
        ),
      ],
    );
    blocTest(
      'GIVEN a preSelectedCertificate WHEN call to event deletePreselectedCertificate THEN emit the failure',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        when(certificateRepository.deleteCertificate(givenCertificateEntity()))
            .thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.notFoundResource()),
        );

        bloc.emit(
          ChangeCertificateState(
            preselectedCertificate: givenCertificateEntity(),
            certificates: [givenCertificateEntity()],
            certificateListStatus: const ScreenStatus.initial(),
            certificateChangeDefaultStatus: const ScreenStatus.loading(),
            certificateDeleteStatus: const ScreenStatusWithResult.initial(),
          ),
        );

        bloc.add(
          const ChangeCertificateEvent.deletePreselectedCertificate(),
        );
      },
      expect: () => [
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.initial(),
        ),
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.loading(),
        ),
        ChangeCertificateState(
          preselectedCertificate: givenCertificateEntity(),
          certificates: [givenCertificateEntity()],
          certificateListStatus: const ScreenStatus.initial(),
          certificateChangeDefaultStatus: const ScreenStatus.loading(),
          certificateDeleteStatus: const ScreenStatusWithResult.error(null),
        ),
      ],
    );

    blocTest(
      'GIVEN a certificateDeleteStatus WHEN call to event preselectedCertificateDeletedShow THEN emit the correct initial state',
      build: () => changeCertificateBloc,
      act: (ChangeCertificateBloc bloc) {
        bloc.add(
          const ChangeCertificateEvent.preselectedCertificateDeletedShow(),
        );
      },
      expect: () => [
        const ChangeCertificateState(
          preselectedCertificate: null,
          certificates: [],
          certificateListStatus: ScreenStatus.initial(),
          certificateChangeDefaultStatus: ScreenStatus.initial(),
          certificateDeleteStatus: ScreenStatusWithResult.initial(),
        ),
      ],
    );
  });
}
