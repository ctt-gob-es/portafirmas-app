import 'package:firma_portafirmas/firma_portafirmas_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/migration_ios_local_data_source.dart';
import 'package:portafirmas_app/data/models/server_migrated_local_entity.dart';

import '../../instruments/certificate_instruments.dart';
import '../../instruments/path_provider_instruments.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../instruments/servers_instruments.dart';

import 'migration_ios_local_data_source_test.mocks.dart';

@GenerateMocks([FirmaPortafirmasInterface])
main() {
  late MockFirmaPortafirmasInterface firmaPortafirmasInterface;

  late MigrationIOSLocalDataSource localDataSource;
  setUp(() {
    firmaPortafirmasInterface = MockFirmaPortafirmasInterface();
    localDataSource = MigrationIOSLocalDataSource(firmaPortafirmasInterface);
  });

  test(
    'GIVEN ios local data source WHEN retrieve servers THEN get a list of servers',
    () async {
      PathProviderPlatform.instance = PathProviderPlatformMock();

      when(firmaPortafirmasInterface.migrationRetrieveServers())
          .thenAnswer((_) async => givenServerMapList());

      final result = await localDataSource.retrieveServers();

      expect(
        result,
        [
          const ServerMigratedLocalEntity(
            alias: 'Server alias',
            url: 'urlEx',
          ),
        ],
      );
    },
  );

  test(
    'GIVEN ios local data source WHEN retrieve default server THEN get server',
    () async {
      PathProviderPlatform.instance = PathProviderPlatformMock();

      when(firmaPortafirmasInterface.migrationRetrieveDefaultServer())
          .thenAnswer((_) async => givenServerMap());

      final result = await localDataSource.migrateDefaultServer();

      expect(
        result,
        const ServerMigratedLocalEntity(
          alias: 'Server alias',
          url: 'urlEx',
        ),
      );
    },
  );

  test(
    'GIVEN ios local data source WHEN retrieve default certificate THEN get certificate',
    () async {
      PathProviderPlatform.instance = PathProviderPlatformMock();

      when(firmaPortafirmasInterface.migrateDefaultCertificate())
          .thenAnswer((_) async => givenPfCertificateInfo());

      final result = await localDataSource.migrateDefaultCertificate();

      expect(
        result,
        givenCertificateLocalEntity(),
      );
    },
  );
}
