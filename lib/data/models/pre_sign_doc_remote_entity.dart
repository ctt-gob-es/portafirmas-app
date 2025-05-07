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
import 'package:portafirmas_app/domain/models/pre_sign_doc_entity.dart';

part 'pre_sign_doc_remote_entity.freezed.dart';

@freezed
class PreSignDocRemoteEntity with _$PreSignDocRemoteEntity {
  const factory PreSignDocRemoteEntity({
    @JsonKey(name: 'docid') required String id,
    @JsonKey(name: 'cop') required String signOp, // (sign, cosign, countersign)
    @JsonKey(name: 'sigfrmt') required String signFrmt,
    @JsonKey(name: 'mdalgo') required String signAlgo,
    @JsonKey(name: 'params') required String params,
    @JsonKey(name: 'PRE') required String preSignContent,
    @JsonKey(name: 'ENCODING') String? preSignEncoding,
    @JsonKey(name: 'NEED_PRE') required bool needPre,
    @JsonKey(name: 'NEED_DATA') bool? needData,
    @JsonKey(name: 'BASE') String? signBase,
    @JsonKey(name: 'TIME') String? time,
    @JsonKey(name: 'PID') String? pid,
  }) = _PreSignDocRemoteEntity;

  factory PreSignDocRemoteEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> signData = json['result']['p'];

    dynamic needDataVal = _getValue(signData, 'NEED_DATA');
    dynamic baseVal = _getValue(signData, 'BASE');
    dynamic encodingVal = _getValue(signData, 'ENCODING');
    dynamic timeVal = _getValue(signData, 'TIME');
    dynamic pidVal = _getValue(signData, 'PID');

    return PreSignDocRemoteEntity(
      id: json['docid'],
      signOp: json['cop'],
      signFrmt: json['sigfrmt'],
      signAlgo: json['mdalgo'],
      params: json['params']['__cdata'],
      preSignContent: signData.firstWhere((el) => el['n'] == 'PRE')['\$t'],
      preSignEncoding: encodingVal != null ? encodingVal['\$t'] : null,
      needPre: signData.firstWhere(
                (el) => el['n'] == 'NEED_PRE',
              )['\$t'] ==
              'true'
          ? true
          : false,
      needData: needDataVal != null
          ? needDataVal['\$t'] == 'true'
              ? true
              : false
          : null,
      signBase: baseVal != null ? baseVal['\$t'] : null,
      time: timeVal != null ? timeVal['\$t'] : null,
      pid: pidVal != null ? pidVal['\$t'] : null,
    );
  }
}

dynamic _getValue(List<dynamic> signData, String key) {
  final parsedData = signData.cast<Map<String, dynamic>?>();

  return parsedData.firstWhere(
    (el) {
      if (el == null) return false;

      return el['n'] == key;
    },
    orElse: () => null,
  );
}

extension PreSignDocRemoteEntityExtension on PreSignDocRemoteEntity {
  PreSignDocEntity toPreSignDocEntity() => PreSignDocEntity(
        id: id,
        signOp: signOp,
        signFrmt: signFrmt,
        signAlgo: signAlgo,
        params: params,
        preSignContent: preSignContent,
        preSignEncoding: preSignEncoding,
        needPre: needPre,
        needData: needData,
        signBase: signBase,
        time: time,
        pid: pid,
      );
}
