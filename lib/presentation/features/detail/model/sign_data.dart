
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

part 'sign_data.freezed.dart';

@freezed
class SignData with _$SignData {
  const factory SignData({
    required String id,
    required String signResultBase64,
    required String preSignContent,
    required bool needPre,
    bool? needData,
    String? preSignEncoding,
    String? signBase,
    String? time,
    String? pid,
  }) = _SignData;
}

extension SignDataExtension on SignData {
  String get xmlString {
    String result =
        "<result><p n='PRE'>$preSignContent</p><p n='NEED_PRE'>$needPre</p>${_getEncoding()}${_getSignBase()}${_getNeedData()}${_getTime()}${_getPid()}<p n='PK1'>$signResultBase64</p></result>";

    return result;
  }

  String _getEncoding() =>
      preSignEncoding != null ? "<p n='ENCODING'>$preSignEncoding</p>" : '';

  String _getSignBase() => signBase != null ? "<p n='BASE'>$signBase</p>" : '';

  String _getNeedData() =>
      needData != null ? "<p n='NEED_DATA'>$needData</p>" : '';

  String _getTime() => time != null ? "<p n='TIME'>$time</p>" : '';

  String _getPid() => pid != null ? "<p n='PID'>$pid</p>" : '';
}
