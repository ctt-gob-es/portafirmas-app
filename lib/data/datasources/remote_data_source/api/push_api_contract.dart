
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/data/datasources/remote_data_source/api/portafirma_api_base.dart';
import 'package:portafirmas_app/data/models/push_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/register_push_remote_entity.dart';
import 'package:portafirmas_app/data/models/update_push_remote_entity.dart';

abstract class PushApiContract extends PortafirmaApiBase {
  PushApiContract({
    required super.dio,
    required super.serverLocalDataSource,
  });

  Future<RegisterPushRemoteEntity> registerPush({
    required String sessionId,
    required PushPetitionRemoteEntity petition,
  });

  Future<UpdatePushRemoteEntity> updatePush({
    required String sessionId,
    required bool status,
  });
}
