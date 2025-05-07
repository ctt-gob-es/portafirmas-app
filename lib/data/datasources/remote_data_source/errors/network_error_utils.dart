
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
import 'package:portafirmas_app/app/constants/mock_paths.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';

NetworkError getErrorFromDioError(DioError error) {
  final NetworkError networkExceptions;
  switch (error.type) {
    case DioErrorType.cancel:
      networkExceptions = const NetworkError.requestCancelled();
      break;
    case DioErrorType.connectTimeout:
      networkExceptions = const NetworkError.requestTimeout();
      break;
    case DioErrorType.other:
      if (error.error == MocksPaths.error) {
        networkExceptions = const NetworkError.mockNotFoundError();
      } else if (error.toString().contains('is not a subtype of')) {
        networkExceptions = const NetworkError.unableToProcess();
      } else {
        networkExceptions = const NetworkError.noInternetConnection();
      }
      break;
    case DioErrorType.receiveTimeout:
      networkExceptions = const NetworkError.sendTimeout();
      break;
    case DioErrorType.response:
      final errorDescription =
          error.response?.data?['error']?['error_description'];
      final errorType = error.response?.data?['error']?['error_type'];
      if (errorType != null && errorType == 'INFO_NOT_MATCHING') {
        return const NetworkError.infoNotMatching();
      }

      if (errorDescription != null && errorDescription is List) {
        return NetworkError.badRequestListErrors(
          (errorDescription).map((e) => e as String).toList(),
        );
      }

      networkExceptions = _checkStatusCode(error.response?.statusCode);
      break;
    case DioErrorType.sendTimeout:
      networkExceptions = const NetworkError.sendTimeout();
      break;
  }

  return networkExceptions;
}

NetworkError _checkStatusCode(int? statusCode) {
  switch (statusCode) {
    case 400:
      return const NetworkError.badRequest();
    case 401:
      return const NetworkError.unauthorizedRequest();
    case 403:
      return const NetworkError.forbidden();
    case 404:
      return const NetworkError.notFound('Not found');
    case 409:
      return const NetworkError.conflict();
    case 408:
      return const NetworkError.requestTimeout();
    case 500:
      return const NetworkError.internalServerError();
    case 503:
      return const NetworkError.serviceUnavailable();
    default:
      var responseCode = statusCode;
      return NetworkError.defaultError(
        'Received invalid status code: $responseCode',
      );
  }
}
