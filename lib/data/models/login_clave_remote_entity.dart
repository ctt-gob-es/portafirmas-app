
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_clave_remote_entity.freezed.dart';

@freezed
class LoginClaveRemoteEntity with _$LoginClaveRemoteEntity {
  const factory LoginClaveRemoteEntity({
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'cookies') required Map<String, String> cookies,
  }) = _LoginClaveRemoteEntity;

  factory LoginClaveRemoteEntity.fromJsonWithCookie(
    Map<String, dynamic> json,
    Headers headers,
  ) {
    final List<String>? setCookie = headers.map['set-cookie'];
    String? cookie;
    if (setCookie != null) {
      for (String c in setCookie) {
        RegExp regExp = RegExp(r'JSESSIONID=[^;]+');
        Match? match = regExp.firstMatch(c);

        cookie = match?.group(0);
        break;
      }
    }

    var data = LoginClaveRemoteEntity(
      url: json['__cdata'],
      cookies: {
        'Cookie': cookie ?? headers.value('set-cookie').toString(),
      },
    );

    return data;
  }
}
