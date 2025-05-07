
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:typed_data';

import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/pick_file_repository_contract.dart';

import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/pick_file_local_data_source_contract.dart';

class PickFileRepository implements PickFileRepositoryContract {
  final PickFileLocalDataSourceContract pickFileLocalDataSourceContract;

  PickFileRepository(this.pickFileLocalDataSourceContract);

  @override
  Future<Result<Uint8List?>> getCertificateFileContent() async {
    try {
      final content =
          await pickFileLocalDataSourceContract.getCertificateFileContent();

      return Result.success(content);
    } catch (e) {
      return Result.failure(
        error:
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
      );
    }
  }
}
