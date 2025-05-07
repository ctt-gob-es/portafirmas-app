
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
import 'package:portafirmas_app/domain/models/document_entity.dart';
part 'document_remote_entity.freezed.dart';
part 'document_remote_entity.g.dart';

@freezed
class DocumentRemoteEntity with _$DocumentRemoteEntity {
  const factory DocumentRemoteEntity({
    @JsonKey(name: 'docid') required String docId,
    @JsonKey(name: 'nm') required String docName,
    @JsonKey(name: 'sz') required String docSize,
    @JsonKey(name: 'sigfrmt') required String signFrmt,
    @JsonKey(name: 'mdalgo') required String signAlgo,
    @JsonKey(name: 'params') required String params,
  }) = _DocumentRemoteEntity;

  factory DocumentRemoteEntity.fromJson(Map<String, dynamic> json) =>
      _$DocumentRemoteEntityFromJson({
        'docid': json['docid'],
        'nm': json['nm']['__cdata'],
        'sz': json['sz']['\$t'],
        'sigfrmt': json['sigfrmt']['\$t'] ?? json['sigfrmt']['__cdata'],
        'mdalgo': json['mdalgo']['\$t'] ?? json['mdalgo']['__cdata'],
        'params': json['params'].isNotEmpty ? json['params'] : '',
      });
}

extension DocumentRemoteEntityExtension on DocumentRemoteEntity {
  DocumentEntity toDocumentEntity() => DocumentEntity(
        docId: docId,
        docName: docName,
        docSize: docSize,
        signFrmt: signFrmt,
        signAlgo: signAlgo,
        params: params,
      );
}
