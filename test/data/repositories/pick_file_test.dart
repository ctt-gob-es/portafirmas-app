import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/pick_file_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/pick_file_repository.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

import '../instruments/auth_data_instruments.dart';

import 'pick_file_test.mocks.dart';

@GenerateMocks([
  PickFileLocalDataSourceContract,
])
void main() {
  late MockPickFileLocalDataSourceContract pickFileLocalDataSource;

  late PickFileRepository repository;

  setUp(() {
    pickFileLocalDataSource = MockPickFileLocalDataSourceContract();
    repository = PickFileRepository(
      pickFileLocalDataSource,
    );
  });

  test(
    'GIVEN pick file repository WHEN call to get certificate content with non null THEN I get Result success',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      when(pickFileLocalDataSource.getCertificateFileContent())
          .thenAnswer((_) async => givenUInt8List());

      final result = await repository.getCertificateFileContent();

      verify(pickFileLocalDataSource.getCertificateFileContent()).called(1);

      result.when(
        success: (list) {
          expect(list, givenUInt8List());
        },
        failure: (error) => fail('Should have returned a success result'),
      );
    },
  );

  test(
    'GIVEN pick file repository WHEN call to get certificate content with null THEN I get Result success',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      when(pickFileLocalDataSource.getCertificateFileContent())
          .thenAnswer((_) async => null);

      final result = await repository.getCertificateFileContent();

      verify(pickFileLocalDataSource.getCertificateFileContent()).called(1);

      result.when(
        success: (list) {
          expect(list, null);
        },
        failure: (error) => fail('Should have returned a success result'),
      );
    },
  );

  test(
    'GIVEN pick file repository WHEN call to get certificate content with error THEN I get Result error',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      when(pickFileLocalDataSource.getCertificateFileContent())
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.getCertificateFileContent();

      verify(pickFileLocalDataSource.getCertificateFileContent()).called(1);

      result.when(
        failure: (error) => expect(error, const RepositoryError.serverError()),
        success: (data) => fail('Should have returned a error result'),
      );
    },
  );
}
