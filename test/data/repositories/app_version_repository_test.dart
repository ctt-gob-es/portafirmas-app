import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/app_version_repository.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/app_version_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/features/app_version/models/version_case.dart';

import '../instruments/app_version_instruments.dart';
import 'app_version_repository_test.mocks.dart';

@GenerateMocks([AppVersionRemoteDataSourceContract])
void main() {
  late MockAppVersionRemoteDataSourceContract remoteDataSource;
  late AppVersionRepository repository;
  setUp(() {
    remoteDataSource = MockAppVersionRemoteDataSourceContract();
    repository = AppVersionRepository(remoteDataSource);
  });

  test(
    'GIVEN getLatestVersion WHEN call to repository THEN verify the results',
    () async {
      when(remoteDataSource.getAppLatestVersion())
          .thenAnswer((_) => Future.value(getAppVersionRemoteEntity()));

      final result = await remoteDataSource.getAppLatestVersion();

      verify(repository.getLatestVersion()).called(1);

      assert(result == getAppVersionRemoteEntity());
    },
  );

  test(
    'GIVEN getVersionCase WHEN call to repository THEN verify the results',
    () async {
      when(remoteDataSource.checkAppVersion())
          .thenAnswer((_) => Future.value('Up to date'));

      final result = await repository.getVersionCase();

      verify(repository.getVersionCase()).called(1);

      result.when(
        failure: (e) =>
            const Result.failure(error: RepositoryError.serverError()),
        success: (data) => const Result.success(VersionCase.upToDate),
      );
    },
  );

  test(
    'GIVEN getAppVersion WHEN call to repository THEN verify the results',
    () async {
      when(remoteDataSource.getLocalAppVersion())
          .thenAnswer((_) => Future.value({'versionApp': '1.2.3'}));

      final result = await repository.getAppVersion();

      verify(remoteDataSource.getLocalAppVersion()).called(1);

      assert(result.isNotEmpty);
    },
  );
}
