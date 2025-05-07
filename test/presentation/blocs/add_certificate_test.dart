import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/pick_file_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';

import '../../data/instruments/auth_data_instruments.dart';
import '../../data/instruments/general_instruments.dart';
import 'add_certificate_test.mocks.dart';

@GenerateMocks([CertificateRepositoryContract, PickFileRepositoryContract])
void main() {
  late MockCertificateRepositoryContract certificateRepository;
  late MockPickFileRepositoryContract pickFileRepository;
  late AddCertificateBloc addCertificateBloc;

  setUp(() {
    certificateRepository = MockCertificateRepositoryContract();
    pickFileRepository = MockPickFileRepositoryContract();
    addCertificateBloc = AddCertificateBloc(
      certificateRepository: certificateRepository,
      fileRepositoryContract: pickFileRepository,
    );
  });

  blocTest(
    'GIVEN add certificate bloc WHEN add certificate success then status is success',
    build: () => addCertificateBloc,
    act: (AddCertificateBloc bloc) {
      when(certificateRepository.addCertificate(
        context: anyNamed('context'),
        certificate: anyNamed('certificate'),
      )).thenAnswer(
        (_) async => const Result.success(''),
      );

      when(pickFileRepository.getCertificateFileContent()).thenAnswer(
        (_) async => Result.success(givenUInt8List()),
      );

      bloc.add(AddCertificateEvent.addCertificate(context: givenContext()));
    },
    expect: () => [
      const AddCertificateState(
        screenStatus: ScreenStatus.loading(),
      ),
      const AddCertificateState(
        screenStatus: ScreenStatus.success(),
      ),
    ],
  );

  blocTest(
    'GIVEN add certificate bloc WHEN add certificate not selected then status is initial',
    build: () => addCertificateBloc,
    act: (AddCertificateBloc bloc) {
      when(certificateRepository.addCertificate(
        context: anyNamed('context'),
        certificate: anyNamed('certificate'),
      )).thenAnswer(
        (_) async => const Result.success(''),
      );

      when(pickFileRepository.getCertificateFileContent()).thenAnswer(
        (_) async => const Result.success(null),
      );

      bloc.add(AddCertificateEvent.addCertificate(context: givenContext()));
    },
    expect: () => [
      const AddCertificateState(
        screenStatus: ScreenStatus.loading(),
      ),
      const AddCertificateState(
        screenStatus: ScreenStatus.initial(),
      ),
    ],
  );

  blocTest(
    'GIVEN add certificate bloc WHEN add certificate with error then status is error',
    build: () => addCertificateBloc,
    act: (AddCertificateBloc bloc) {
      when(certificateRepository.addCertificate(
        context: anyNamed('context'),
        certificate: anyNamed('certificate'),
      )).thenAnswer(
        (_) async => const Result.failure(error: RepositoryError.serverError()),
      );

      when(pickFileRepository.getCertificateFileContent()).thenAnswer(
        (_) async => Result.success(givenUInt8List()),
      );

      bloc.add(AddCertificateEvent.addCertificate(context: givenContext()));
    },
    expect: () => [
      const AddCertificateState(
        screenStatus: ScreenStatus.loading(),
      ),
      const AddCertificateState(
        screenStatus: ScreenStatus.error(RepositoryError.serverError()),
      ),
    ],
  );
}
