import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/domain/repository_contracts/app_version_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/app_version/models/version_case.dart';

import '../instruments/requests_instruments.dart';
import 'app_version_bloc_test.mocks.dart';

@GenerateMocks([AppVersionRepositoryContract])
void main() {
  late MockAppVersionRepositoryContract appVersionRepositoryContract;

  late AppVersionBloc bloc;

  setUp(() {
    appVersionRepositoryContract = MockAppVersionRepositoryContract();

    bloc = AppVersionBloc(repository: appVersionRepositoryContract);
  });

  group('Check App Version event', () {
    blocTest(
      'GIVEN a AppVersionBloc WHEN checkAppVersion event is called THEN if version is upToDate AppVersionState will be upToDateVersion',
      build: () => bloc,
      act: (AppVersionBloc bloc) {
        when(appVersionRepositoryContract.getLatestVersion())
            .thenAnswer((_) async => Result.success(givenAppVersionEntity));
        when(appVersionRepositoryContract.getVersionCase()).thenAnswer(
          (_) async => const Result.success(VersionCase.upToDate),
        );
        when(appVersionRepositoryContract.getAppVersion())
            .thenAnswer((_) async => '2.1');

        bloc.add(AppVersionEvent.checkAppVersion());
      },
      expect: () => [
        const AppVersionState.loading(),
        const AppVersionState.upToDateVersion(
          appVersion: '2.1',
        ),
      ],
    );

    blocTest(
      'GIVEN a AppVersionBloc WHEN checkAppVersion event is called THEN if version is not latest version AppVersionState will be recommendedUpdateVersion',
      build: () => bloc,
      act: (AppVersionBloc bloc) {
        when(appVersionRepositoryContract.getLatestVersion())
            .thenAnswer((_) async => Result.success(givenAppVersionEntity));
        when(appVersionRepositoryContract.getVersionCase()).thenAnswer(
          (_) async => const Result.success(VersionCase.updateRecommended),
        );
        when(appVersionRepositoryContract.getAppVersion())
            .thenAnswer((_) async => '1.9');

        bloc.add(AppVersionEvent.checkAppVersion());
      },
      expect: () => [
        const AppVersionState.loading(),
        const AppVersionState.recommendedUpdateVersion(
          appVersion: '1.9',
        ),
      ],
    );

    blocTest(
      'GIVEN a AppVersionBloc WHEN checkAppVersion event is called THEN if version is mandatory to be updated AppVersionState will be requiredUpdateVersion',
      build: () => bloc,
      act: (AppVersionBloc bloc) {
        when(appVersionRepositoryContract.getLatestVersion())
            .thenAnswer((_) async => Result.success(givenAppVersionEntity));
        when(appVersionRepositoryContract.getVersionCase()).thenAnswer(
          (_) async => const Result.success(VersionCase.updateRequired),
        );
        when(appVersionRepositoryContract.getAppVersion())
            .thenAnswer((_) async => '1.9');

        bloc.add(AppVersionEvent.checkAppVersion());
      },
      expect: () => [
        const AppVersionState.loading(),
        const AppVersionState.requiredUpdateVersion(
          appVersion: '1.9',
          minVersion: '2.0',
        ),
      ],
    );
  });

  blocTest(
    'GIVEN a AppVersionBloc WHEN resetCheck event is called THEN  AppVersionState will be init',
    build: () => bloc,
    act: (AppVersionBloc bloc) {
      bloc.add(AppVersionEvent.resetCheck());
    },
    expect: () => [const AppVersionState.init()],
  );
}
