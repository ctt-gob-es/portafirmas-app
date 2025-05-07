/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/api_errors.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error_utils.dart';

part 'network_error.freezed.dart';

@freezed
class NetworkError with _$NetworkError {
  const factory NetworkError.badRequest() = _BadRequest;

  const factory NetworkError.badRequestListErrors(List<String> listErrors) =
      _BadRequestListErrors;

  const factory NetworkError.conflict() = _Conflict;

  const factory NetworkError.defaultError(String error) = _DefaultError;

  const factory NetworkError.formatException() = _FormatException;

  const factory NetworkError.internalServerError() = _InternalServerError;

  const factory NetworkError.signWrongCertificate() = _SignWrongCertificate;

  const factory NetworkError.methodNotAllowed() = _MethodNotAllowed;

  const factory NetworkError.noInternetConnection() = _NoInternetConnection;

  const factory NetworkError.notAcceptable() = _NotAcceptable;

  const factory NetworkError.notFound(String reason) = _NotFound;

  const factory NetworkError.notImplemented() = _NotImplemented;

  const factory NetworkError.requestCancelled() = _RequestCancelled;

  const factory NetworkError.requestTimeout() = _RequestTimeout;

  const factory NetworkError.sendTimeout() = _SendTimeout;

  const factory NetworkError.serviceUnavailable() = _ServiceUnavailable;

  const factory NetworkError.unableToProcess() = _UnableToProcess;

  const factory NetworkError.unauthorizedRequest() = _UnauthorizedRequest;

  const factory NetworkError.noValidSignature() = _NoValidSignature;

  const factory NetworkError.anyProblemWithSignature() =
      _AnyProblemWithSignature;

  const factory NetworkError.docSignatureFailed() = _DocSignatureFailed;

  const factory NetworkError.noUserException() = _NoUserException;

  const factory NetworkError.addNewAuthorizedException() =
      _AddNewAuthorizedException;

  const factory NetworkError.addUserValidatorException() =
      _AddUserValidatorException;

  const factory NetworkError.forbidden() = _Forbidden;

  const factory NetworkError.unexpectedError() = _UnexpectedError;

  const factory NetworkError.mockNotFoundError() = _MockNotFoundError;

  const factory NetworkError.infoNotMatching() = _InfoNotMatching;
  const factory NetworkError.sessionExpired() = _SessionExpired;
  const factory NetworkError.certNotValid() = _CertNotValid;
  const factory NetworkError.certExpired() = _CertExpired;
  const factory NetworkError.certRevoked() = _CertRevoked;
  const factory NetworkError.certUserNoPermission() = _CertUserNoPermission;

  static NetworkError fromException(error) {
    try {
      if (error is Exception) {
        NetworkError networkExceptions;
        if (error is ApiErrorSessionExpired) {
          networkExceptions = const NetworkError.sessionExpired();
        } else if (error.toString().contains('COD_001')) {
          networkExceptions = const NetworkError.signWrongCertificate();
        } else if (error.toString().contains('COD_002')) {
          networkExceptions = const NetworkError.certNotValid();
        } else if (error.toString().contains('COD_003')) {
          networkExceptions = const NetworkError.certUserNoPermission();
        } else if (error.toString().contains('COD_021')) {
          networkExceptions = const NetworkError.certExpired();
        } else if (error.toString().contains('COD_022')) {
          networkExceptions = const NetworkError.certRevoked();
        } else if (error.toString().contains('COD_301')) {
          networkExceptions = const NetworkError.anyProblemWithSignature();
        } else if (error.toString().contains('COD_302')) {
          networkExceptions = const NetworkError.noValidSignature();
        } else if (error.toString().contains('El usuario no está vigente')) {
          networkExceptions = const NetworkError.noUserException();
        } else if (error
            .toString()
            .contains('Error trying to add authorization')) {
          networkExceptions = const NetworkError.addNewAuthorizedException();
        } else if (error.toString().contains('Error trying to add validator')) {
          networkExceptions = const NetworkError.addUserValidatorException();
        } else if (error.toString().contains('Server error')) {
          networkExceptions = const NetworkError.internalServerError();
        } else if (error.toString().contains('El certificado no es valido')) {
          networkExceptions = const NetworkError.certNotValid();
        } else if (error.toString().contains('Error presigning requests') ||
            (RegExp(r'COD_3(?!02)\d{2}').hasMatch(error.toString()))) {
          networkExceptions = const NetworkError.docSignatureFailed();
        } else if (error is SocketException) {
          networkExceptions = const NetworkError.noInternetConnection();
        } else if (error is DioError) {
          networkExceptions = getErrorFromDioError(error);
        } else {
          networkExceptions = const NetworkError.unexpectedError();
        }
        return networkExceptions;
      } else if (error is FormatException) {
        return const NetworkError.formatException();
      } else {
        return error.toString().contains('is not a subtype of')
            ? const NetworkError.unableToProcess()
            : const NetworkError.unexpectedError();
      }
    } catch (_) {
      return const NetworkError.unexpectedError();
    }
  }
}
