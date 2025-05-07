
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
import 'package:portafirmas_app/domain/models/annexes_entity.dart';

part 'annexes_remote_entity.freezed.dart';
part 'annexes_remote_entity.g.dart';

@freezed
class AnnexesRemoteEntity with _$AnnexesRemoteEntity {
  const factory AnnexesRemoteEntity({
    @JsonKey(name: 'docid') required String annexeId,
    @JsonKey(name: 'nm') required String annexeName,
    @JsonKey(name: 'sz') required String annexeSize,
    @JsonKey(name: 'mmtp') required String mediaType,
  }) = _AnnexesRemoteEntity;

  factory AnnexesRemoteEntity.fromJson(Map<String, dynamic> json) =>
      _$AnnexesRemoteEntityFromJson({
        'docid': json['docid'],
        'nm': json['nm']['__cdata'],
        'sz': json['sz']['\$t'],
        'mmtp': json['mmtp']['\$t'],
      });
}

extension AnnexesRemoteEntityExtension on AnnexesRemoteEntity {
  AnnexesEntity toAnnexesEntity() => AnnexesEntity(
        annexeId: annexeId,
        annexeName: annexeName,
        annexeSize: annexeSize,
        mediaType: mediaType,
      );
}
