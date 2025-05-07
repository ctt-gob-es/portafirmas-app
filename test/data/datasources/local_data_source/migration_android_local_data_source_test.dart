import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/migration_android_local_data_source.dart';
import 'package:portafirmas_app/data/models/server_migrated_local_entity.dart';

import '../../instruments/path_provider_instruments.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'migration_android_local_data_source_test.mocks.dart';

@GenerateMocks([PathProviderPlatform])
main() {
  late MockPathProviderPlatform pathProviderPlatform;

  late MigrationAndroidLocalDataSource localDataSource;
  setUp(() {
    pathProviderPlatform = MockPathProviderPlatform();
    localDataSource = MigrationAndroidLocalDataSource();
  });

  test(
    'GIVEN shared preference file WHEN retrieve servers THEN get a list of servers',
    () async {
      PathProviderPlatform.instance = PathProviderPlatformMock();

      when(pathProviderPlatform.getApplicationDocumentsPath())
          .thenAnswer((_) async => '');

      final result = await localDataSource.retrieveServers();

      expect(
        result,
        [
          const ServerMigratedLocalEntity(
            alias: 'testalias',
            url: 'https://test',
          ),
        ],
      );
    },
  );
}
