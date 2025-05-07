
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:firma_portafirmas/firma_portafirmas_interface.dart';
import 'package:portafirmas_app/data/models/certificate_local_entity.dart';
import 'package:portafirmas_app/data/models/server_migrated_local_entity.dart';

import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_ios_local_data_source_contract.dart';

class MigrationIOSLocalDataSource
    implements MigrationIOSLocalDataSourceContract {
  final FirmaPortafirmasInterface firmaPortafirmas;
  MigrationIOSLocalDataSource(this.firmaPortafirmas);

  @override
  Future<List<ServerMigratedLocalEntity>> retrieveServers() async {
    final serversMap = await firmaPortafirmas.migrationRetrieveServers();
    final List<ServerMigratedLocalEntity> result = [];

    result.addAll(serversMap.entries
        .map((e) => ServerMigratedLocalEntity(alias: e.key, url: e.value)));

    return result;
  }

  @override
  Future<ServerMigratedLocalEntity?> migrateDefaultServer() async {
    final result = await firmaPortafirmas.migrationRetrieveDefaultServer();
    if (result == null) return null;

    return ServerMigratedLocalEntity(alias: result.key, url: result.value);
  }

  @override
  Future<CertificateLocalEntity?> migrateDefaultCertificate() async {
    final result = await firmaPortafirmas.migrateDefaultCertificate();
    if (result == null) return null;

    return CertificateLocalEntity.fromPfCertificateInfo(result);
  }
}
