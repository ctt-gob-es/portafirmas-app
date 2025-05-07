
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
import 'package:portafirmas_app/data/models/request_remote_entity.dart';
import 'package:portafirmas_app/domain/models/request_list_entity.dart';

part 'request_list_remote_entity.freezed.dart';

@freezed
class RequestListRemoteEntity with _$RequestListRemoteEntity {
  const factory RequestListRemoteEntity({
    required String count,
    required List<RequestRemoteEntity> requestList,
  }) = _RequestListRemoteEntity;

  factory RequestListRemoteEntity.fromJson(Map<String, dynamic> json) {
    return RequestListRemoteEntity(
      count: json['list']['n'],
      requestList: _getRequestRemoteEntities(json['list']),
    );
  }
}

List<RequestRemoteEntity> _getRequestRemoteEntities(Map<String, dynamic> list) {
  List<RequestRemoteEntity> requestRemoteEntities;
  switch (list['n']) {
    case '0':
      requestRemoteEntities = [];
      break;
    case '1':
      requestRemoteEntities = [
        RequestRemoteEntity.fromRequestList(list['rqt']),
      ];
      break;
    default:
      requestRemoteEntities = (list['rqt'] as List)
          .map((e) => RequestRemoteEntity.fromRequestList(e))
          .toList();
      break;
  }

  return requestRemoteEntities;
}

extension RequestListRemoteEntityExtension on RequestListRemoteEntity {
  RequestListEntity toRequestListEntity() => RequestListEntity(
        count: int.parse(count),
        requests: requestList.map((e) => e.toRequestEntity()).toList(),
      );
}
