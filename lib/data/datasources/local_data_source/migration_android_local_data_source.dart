
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:portafirmas_app/data/models/server_migrated_local_entity.dart';
import 'package:xml2json/xml2json.dart';

import 'package:portafirmas_app/data/repositories/data_source_contracts/local/migration_android_local_data_source_contract.dart';

class MigrationAndroidLocalDataSource
    implements MigrationAndroidLocalDataSourceContract {
  MigrationAndroidLocalDataSource();

  @override
  Future<List<ServerMigratedLocalEntity>> retrieveServers() async {
    final data = await _performMigrationForAndroid();

    return data.entries
        .map((e) => ServerMigratedLocalEntity(alias: e.key, url: e.value))
        .toList();
  }
}

Future<FileSystemEntity?> getAndroidOldPrefsFile() async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final directory = Directory('${appDir.parent.path}/shared_prefs');

    List<FileSystemEntity?> files = directory.listSync(recursive: true);

    return files.firstWhere(
      (file) => file?.path.endsWith('_preferences.xml') ?? false,
    );
  } catch (_) {
    return null;
  }
}

Future<Map<String, String>> _performMigrationForAndroid() async {
  final FileSystemEntity? fileSystem = await getAndroidOldPrefsFile();

  if (fileSystem == null) {
    return {};
  }

  final File file = File(fileSystem.path);
  final String xmlString = file.readAsStringSync();
  final Xml2Json transformer = Xml2Json();
  transformer.parse(xmlString);
  final gdataJson = transformer.toGData();
  Map<dynamic, dynamic> gDataMap = jsonDecode(gdataJson);
  List<dynamic> stringList = gDataMap['map']['string'];

  final Map<String, String> result = {};
  for (final item in stringList) {
    final key = item['name'];
    final value = item['\$t'];
    if (key is String && value is String) {
      if (key.startsWith('server')) {
        final correctKey = key.replaceAll('server', '');

        result[correctKey] = value;
      }
    }
  }

  return result;
}
