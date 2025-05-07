
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:portafirmas_app/app/constants/initial_servers.dart';

import 'package:portafirmas_app/data/models/server_local_entity.dart';

import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';

import 'package:portafirmas_app/data/models/server_migrated_local_entity.dart';

class ServersLocalDatasource implements ServersLocalDataSourceContract {
  final String boxName;
  final FlutterSecureStorage storage;
  final HiveInterface hive;
  static const _defaultServerKey = 'defaultServer';
  static const _serversMigratedKey = 'serversMigrated';

  ServersLocalDatasource({
    required this.boxName,
    required this.storage,
    required this.hive,
  });

  @override
  Future<String?> getDefaultServer() async {
    return await storage.read(
      key: _defaultServerKey,
    );
  }

  @override
  Future<void> setDefaultServer(String url) async {
    await storage.write(key: _defaultServerKey, value: url);
  }

  @override
  Future<List<ServerLocalEntity>> getServers() async {
    final box = await hive.openBox<ServerLocalEntity>(boxName);

    return box.values.toList();
  }

  @override
  Future<int> addServer(String alias, String url) async {
    final box = await hive.openBox<ServerLocalEntity>(boxName);
    final newServer = ServerLocalEntity(alias: alias, url: url);
    final index = await box.add(newServer);

    return index;
  }

  @override
  Future<List<int>> addServers(List<ServerMigratedLocalEntity> servers) async {
    final box = await hive.openBox<ServerLocalEntity>(boxName);

    final actualServers = await getServers();
    final initServers = initialServers;
    final List<ServerLocalEntity> serversToAdd = [];

    for (final server in servers) {
      // Check duplicates
      if (!(actualServers.any((element) => element.url == server.url) ||
          initServers.any((element) => element.url == server.url))) {
        final newServer =
            ServerLocalEntity(alias: server.alias, url: server.url);
        serversToAdd.add(newServer);
      }
    }

    final indexes = await box.addAll(serversToAdd);

    return indexes.toList();
  }

  @override
  Future<ServerLocalEntity> modifyServer(
    int index,
    String alias,
    String url,
  ) async {
    final box = await hive.openBox<ServerLocalEntity>(boxName);
    final newServer = ServerLocalEntity(alias: alias, url: url);
    await box.put(index, newServer);

    return newServer;
  }

  @override
  Future<void> deleteServer(int index) async {
    final box = await hive.openBox<ServerLocalEntity>(boxName);
    await box.delete(index);
  }

  @override
  Future<bool> getServersMigrated() async {
    final data = await storage.read(key: _serversMigratedKey);

    return data == 'true';
  }

  @override
  Future<void> setServersMigrated() async {
    await storage.write(key: _serversMigratedKey, value: 'true');
  }
}
