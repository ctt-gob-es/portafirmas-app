import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_android_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_ios_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/migration_repository.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

import '../instruments/certificate_instruments.dart';
import '../instruments/servers_instruments.dart';
import 'migration_repository_test.mocks.dart';

@GenerateMocks([
  MigrationAndroidLocalDataSourceContract,
  ServersLocalDataSourceContract,
  MigrationIOSLocalDataSourceContract,
])
void main() {
  late MockMigrationAndroidLocalDataSourceContract
      migrationAndroidLocalDataSource;
  late MockServersLocalDataSourceContract serversLocalDataSource;
  late MockMigrationIOSLocalDataSourceContract migrationIOSLocalDataSource;

  late MigrationRepository repository;

  setUp(() {
    migrationAndroidLocalDataSource =
        MockMigrationAndroidLocalDataSourceContract();
    migrationIOSLocalDataSource = MockMigrationIOSLocalDataSourceContract();
    serversLocalDataSource = MockServersLocalDataSourceContract();

    repository = MigrationRepository(
      migrationAndroidLocalDataSource,
      migrationIOSLocalDataSource,
      serversLocalDataSource,
    );
  });

  group('Migration servers in Android', () {
    test(
      'GIVEN migration repository WHEN call to migrate servers in Android not empty THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        when(migrationAndroidLocalDataSource.retrieveServers())
            .thenAnswer((_) async => givenServerMigratedList());
        when(serversLocalDataSource.addServers(any))
            .thenAnswer((_) async => [0, 1]);

        final result = await repository.migrateServers();

        verify(migrationAndroidLocalDataSource.retrieveServers()).called(1);
        verify(serversLocalDataSource.addServers(any)).called(1);

        result.when(
          success: (list) {
            DoNothingAction();
          },
          failure: (error) => fail('Should have returned a success result'),
        );
      },
    );
    test(
      'GIVEN migration repository WHEN call to migrate servers in android empty THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        when(migrationAndroidLocalDataSource.retrieveServers())
            .thenAnswer((_) async => []);

        final result = await repository.migrateServers();

        verify(migrationAndroidLocalDataSource.retrieveServers()).called(1);
        verifyNever(serversLocalDataSource.addServers(any));

        result.when(
          success: (list) {
            DoNothingAction();
          },
          failure: (error) => fail('Should have returned a success result'),
        );
      },
    );
    test(
      'GIVEN migration repository WHEN call to migrate servers in Android error THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        when(migrationAndroidLocalDataSource.retrieveServers())
            .thenThrow(Exception('Unexpected error'));
        when(serversLocalDataSource.addServers(any))
            .thenAnswer((_) async => [0, 1]);

        final result = await repository.migrateServers();

        verify(migrationAndroidLocalDataSource.retrieveServers()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.unknownError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
  group('Migration servers in iOS', () {
    test(
      'GIVEN migration repository WHEN call to migrate servers in iOS not empty THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        when(migrationIOSLocalDataSource.retrieveServers())
            .thenAnswer((_) async => givenServerMigratedList());
        when(migrationIOSLocalDataSource.migrateDefaultServer())
            .thenAnswer((_) async => null);
        when(serversLocalDataSource.getDefaultServer())
            .thenAnswer((_) async => null);
        when(serversLocalDataSource.addServers(any))
            .thenAnswer((_) async => [0, 1]);

        final result = await repository.migrateServers();

        verify(migrationIOSLocalDataSource.retrieveServers()).called(1);
        verify(serversLocalDataSource.getDefaultServer()).called(1);
        verify(serversLocalDataSource.addServers(any)).called(1);

        result.when(
          success: (list) {
            DoNothingAction();
          },
          failure: (error) => fail('Should have returned a success result'),
        );
      },
    );
    test(
      'GIVEN migration repository WHEN call to migrate servers in iOS empty THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        when(serversLocalDataSource.getDefaultServer())
            .thenAnswer((_) async => null);
        when(migrationIOSLocalDataSource.migrateDefaultServer())
            .thenAnswer((_) async => null);
        when(migrationIOSLocalDataSource.retrieveServers())
            .thenAnswer((_) async => []);

        final result = await repository.migrateServers();

        verify(migrationIOSLocalDataSource.retrieveServers()).called(1);
        verifyNever(serversLocalDataSource.addServers(any));

        result.when(
          success: (list) {
            DoNothingAction();
          },
          failure: (error) => fail('Should have returned a success result'),
        );
      },
    );
    test(
      'GIVEN migration repository WHEN call to migrate servers in iOS error THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        when(migrationIOSLocalDataSource.retrieveServers())
            .thenThrow(Exception('Unexpected error'));
        when(serversLocalDataSource.getDefaultServer())
            .thenAnswer((_) async => null);
        when(serversLocalDataSource.addServers(any))
            .thenAnswer((_) async => [0, 1]);

        final result = await repository.migrateServers();

        verify(migrationIOSLocalDataSource.retrieveServers()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.unknownError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
  group('Migration default cert in iOS', () {
    test(
      'GIVEN migration repository WHEN call to migrate default cert in iOS THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        when(migrationIOSLocalDataSource.migrateDefaultCertificate())
            .thenAnswer((_) async => givenCertificateLocalEntity());

        final result = await repository.migrateDefaultCertificate();

        verify(migrationIOSLocalDataSource.migrateDefaultCertificate())
            .called(1);

        result.when(
          success: (list) {
            DoNothingAction();
          },
          failure: (error) => fail('Should have returned a success result'),
        );
      },
    );
    test(
      'GIVEN migration repository WHEN call to migrate servers in iOS empty THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        when(serversLocalDataSource.getDefaultServer())
            .thenAnswer((_) async => null);
        when(migrationIOSLocalDataSource.migrateDefaultServer())
            .thenAnswer((_) async => null);
        when(migrationIOSLocalDataSource.retrieveServers())
            .thenAnswer((_) async => []);

        final result = await repository.migrateServers();

        verify(migrationIOSLocalDataSource.retrieveServers()).called(1);
        verifyNever(serversLocalDataSource.addServers(any));

        result.when(
          success: (list) {
            DoNothingAction();
          },
          failure: (error) => fail('Should have returned a success result'),
        );
      },
    );
    test(
      'GIVEN migration repository WHEN call to migrate servers in iOS error THEN I get Result success',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        when(migrationIOSLocalDataSource.migrateDefaultCertificate())
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.migrateDefaultCertificate();

        verify(migrationIOSLocalDataSource.migrateDefaultCertificate())
            .called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.unknownError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });
}
