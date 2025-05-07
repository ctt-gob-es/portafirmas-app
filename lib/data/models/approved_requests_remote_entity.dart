
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/data/models/approved_request_remote_entity.dart';

part 'approved_requests_remote_entity.freezed.dart';

@freezed
class ApproveRequestsRemoteEntity with _$ApproveRequestsRemoteEntity {
  const factory ApproveRequestsRemoteEntity({
    @JsonKey(name: 'apprq')
    required List<ApprovedRequestRemoteEntity> approvedRequest, // true / false
  }) = _ApproveRequestsRemoteEntity;

  factory ApproveRequestsRemoteEntity.fromJson(Map<String, dynamic> json) {
    var data = json['apprq']['r'];
    List<dynamic> list = data is List ? data : [data];

    return ApproveRequestsRemoteEntity(
      approvedRequest:
          list.map((e) => ApprovedRequestRemoteEntity.fromJson(e)).toList(),
    );
  }
}
