import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/servers_local_data_source.dart';
import 'package:portafirmas_app/data/models/server_local_entity.dart';

import '../../instruments/servers_instruments.dart';
import 'servers_local_data_source_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
main() {
  late MockHiveInterface hive;
  late MockBox<ServerLocalEntity> box;

  late ServersLocalDatasource localDataSource;

  const boxName = 'ServerBoxTest';

  setUp(() {
    hive = MockHiveInterface();
    box = MockBox<ServerLocalEntity>();

    localDataSource = ServersLocalDatasource(
      boxName: boxName,
      hive: hive,
      storage: const FlutterSecureStorage(),
    );

    when(hive.openBox(any)).thenAnswer(
      (realInvocation) async => box,
    );
  });

  test(
    'GIVEN servers local datasource WHEN call get default server THEN return default server',
    () async {
      const serverDefaultMock = 'server url to test';

      FlutterSecureStorage.setMockInitialValues(
        {'defaultServer': serverDefaultMock},
      );

      final defaultServerRetrieved = await localDataSource.getDefaultServer();

      expect(defaultServerRetrieved, serverDefaultMock);
    },
  );

  test(
    'GIVEN servers local datasource WHEN call set default server THEN set default server',
    () async {
      const serverDefaultMock = 'server url to set test';
      FlutterSecureStorage.setMockInitialValues({});

      await localDataSource.setDefaultServer(serverDefaultMock);
      final defaultServerRetrieved = await localDataSource.getDefaultServer();

      expect(defaultServerRetrieved, serverDefaultMock);
    },
  );

  test(
    'GIVEN servers local datasource WHEN get servers THEN return  servers',
    () async {
      when(box.values).thenAnswer((_) => givenServerLocalEntityList());

      final servers = await localDataSource.getServers();

      verify(hive.openBox(any)).called(1);
      verify(box.values).called(1);

      expect(servers.length, givenServerLocalEntityList().length);
    },
  );

  test(
    'GIVEN servers local datasource WHEN add server THEN server added to db',
    () async {
      when(box.add(any)).thenAnswer((_) async => 0);

      final key = await localDataSource.addServer('ServerAlias', 'ServerUrl');

      verify(hive.openBox(any)).called(1);
      verify(box.add(any)).called(1);

      expect(key, 0);
    },
  );

  test(
    'GIVEN servers local datasource WHEN add servers THEN servers added to db',
    () async {
      when(box.values).thenAnswer((_) => givenServerLocalEntityList());
      when(box.addAll(any)).thenAnswer((_) async => [0, 1]);

      final keys = await localDataSource.addServers(givenServerMigratedList());

      verify(hive.openBox(any)).called(2);
      verify(box.addAll(any)).called(1);

      expect(keys, [0, 1]);
    },
  );
  test(
    'GIVEN servers local datasource WHEN modify server THEN server modified to db',
    () async {
      when(box.put(any, any)).thenAnswer((_) => Future.value());

      final newServer =
          await localDataSource.modifyServer(0, 'ServerAlias2', 'ServerUrl2');

      verify(hive.openBox(any)).called(1);
      verify(box.put(0, any)).called(1);

      expect(newServer.alias, 'ServerAlias2');
      expect(newServer.url, 'ServerUrl2');
    },
  );

  test(
    'GIVEN servers local datasource WHEN delete server THEN server is deleted',
    () async {
      when(box.delete(any)).thenAnswer((_) => Future.value());

      await localDataSource.deleteServer(0);

      verify(hive.openBox(any)).called(1);
      verify(box.delete(
        0,
      )).called(1);
    },
  );
}
