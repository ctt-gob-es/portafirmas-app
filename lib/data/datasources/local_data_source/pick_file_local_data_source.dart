/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/pick_file_local_data_source_contract.dart';

class PickFileLocalDataSource implements PickFileLocalDataSourceContract {
  final FilePicker _filePicker;

  PickFileLocalDataSource(this._filePicker);

  @override
  Future<Uint8List?> getCertificateFileContent() async {
    final fileResult = await _filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['p12'],
    );
    final platformFilePath = fileResult?.files.first.path;

    if (platformFilePath == null) {
      return null;
    } else {
      final file = File(platformFilePath);
      final bytes = await file.readAsBytes();

      return bytes;
    }
  }
}
