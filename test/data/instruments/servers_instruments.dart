import 'package:portafirmas_app/app/constants/initial_servers.dart';
import 'package:portafirmas_app/data/models/server_local_entity.dart';
import 'package:portafirmas_app/data/models/server_migrated_local_entity.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';

ServerEntity givenServerEntity() =>
    ServerEntity(databaseIndex: 0, alias: 'Server alias', url: 'urlEx');

MapEntry<String, String> givenServerMap() =>
    const MapEntry('Server alias', 'urlEx');
Map<String, String> givenServerMapList() => Map.fromEntries([givenServerMap()]);

List<ServerMigratedLocalEntity> givenServerMigratedList() => const [
      ServerMigratedLocalEntity(alias: 'Server 1 alias', url: 'urlEx1'),
      ServerMigratedLocalEntity(alias: 'Server 2 alias', url: 'urlEx2'),
    ];

ServerEntity givenServerEntityDefault() => initialServers.first;

ServerEntity givenServerEntityNew() => ServerEntity(
      databaseIndex: 0,
      alias: 'alias',
      url: 'url',
    );

ServerLocalEntity givenServerLocalEntity() =>
    ServerLocalEntity(alias: 'Server alias', url: 'urlEx');

List<ServerEntity> givenServerEntityList() => [
      ServerEntity(databaseIndex: 0, alias: 'Server 1 alias', url: 'urlEx1'),
      ServerEntity(databaseIndex: 0, alias: 'Server 2 alias', url: 'urlEx2'),
    ];

List<ServerLocalEntity> givenServerLocalEntityList() => [
      ServerLocalEntity(alias: 'Server 1 alias', url: 'urlEx1'),
      ServerLocalEntity(alias: 'Server 2 alias', url: 'urlEx2'),
    ];
