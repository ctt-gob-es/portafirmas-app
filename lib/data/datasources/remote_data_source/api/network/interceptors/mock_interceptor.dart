
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:portafirmas_app/app/constants/mock_paths.dart';

// Class to handle mock requests
class MockInterceptor extends InterceptorsWrapper {
  // Overrides the onRequest method to handle mock requests
  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Loads the JSON data from assets
      final jsonData = await getJsonFromAssets(
        '${MocksPaths.mockPathBaseAssets}${options.path}.json',
      );
      // Resolves the request with the loaded JSON data
      handler.resolve(Response(requestOptions: options, data: jsonData));
    } catch (e) {
      // Rejects the request with a mock error
      handler.reject(DioError(
        requestOptions: options,
        type: DioErrorType.other,
        error: MocksPaths.error,
      ));
    }
  }

  // Loads JSON data from assets
  Future<dynamic> getJsonFromAssets(String path) async {
    final result = await rootBundle.loadString(path);

    return json.decode(result);
  }
}
