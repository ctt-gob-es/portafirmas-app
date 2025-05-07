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
import 'package:path_provider/path_provider.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/api_errors.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';

abstract class PortafirmaApiBase {
  final Dio dio;

  final ServersLocalDataSourceContract serverLocalDataSource;

  Future<String> get _baseUrl async {
    final url = await serverLocalDataSource.getDefaultServer();
    if (url == null) {
      throw (Exception('No url is Selected'));
    }

    return url;
  }

  PortafirmaApiBase({
    required this.dio,
    required this.serverLocalDataSource,
  });

  Future<String> download({
    required int operation,
    required String xmlData,
    required String documentName,
    String? sessionId,
  }) async {
    var directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/$documentName';

    final response = await dio.download(
      await _baseUrl,
      savePath,
      options: getOptions(sessionId),
      queryParameters: getParams(operation: operation, xmlData: xmlData),
    );

    int statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode > 299) {
      throw (Exception('Error downloading file'));
    }

    return savePath;
  }

  Future<Response<T>> get<T>({
    required int operation,
    required String xmlData,
    String? sessionId,
  }) async {
    final response = await dio.get<T>(
      await _baseUrl,
      options: getOptions(sessionId),
      queryParameters: getParams(operation: operation, xmlData: xmlData),
    );

    return response;
  }

  Future<Response<T>> post<T>({
    required int operation,
    required String xmlData,
    String? sessionCookie,
    bool? expectHeader,
  }) async {
    final url = await serverLocalDataSource.getDefaultServer();
    if (url == null) {
      throw (Exception('No url is Selected'));
    }
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    if (expectHeader == true) {
      headers.addAll(
        {'Expect': '100-Continue'}, //header used for long duration requests
      );
    }
    final response = await dio.post<T>(
      await _baseUrl,
      options: getOptions(sessionCookie, headers: headers),
      data: getParams(operation: operation, xmlData: xmlData),
    );

    if (response.data.toString().contains('ERR-11') ||
        response.data.toString().contains('COD_004')) {
      throw ApiErrorSessionExpired();
    }

    return response;
  }

  Map<String, dynamic> getParams({
    required int operation,
    required String xmlData,
  }) =>
      {
        'op': operation,
        'dat': encodeXml(xmlData),
      };

  String encodeXml(String xml) {
    final utf8Bytes = utf8.encode(xml);
    final base64Xml = base64Encode(utf8Bytes);
    final base64XmlSafe = base64Xml.replaceAll('+', '-').replaceAll('/', '_');

    return base64XmlSafe;
  }

  Options? getOptions(
    String? cookie, {
    Map<String, dynamic>? headers,
  }) {
    if (cookie != null) {
      var parts = cookie.split(';');

      if (parts.isEmpty) {
        return Options(
          headers: {'Cookie': cookie}..addAll(headers ?? {}),
        );
      }

      var newCookie = parts[0].trim();

      return Options(
        headers: {'Cookie': newCookie}..addAll(headers ?? {}),
      );
    } else {
      return null;
    }
  }

  bool isProxyVersionUnder25(Map<String, dynamic> result) {
    return (result['err'] != null &&
            result['err']
                .containsValue(AppLiterals.notSupportedOperationCode) ||
        (result['rsgtsrcg'] != null &&
            result['rsgtsrcg']['v'] != null &&
            int.parse(result['rsgtsrcg']['v']) < 25));
  }
}
