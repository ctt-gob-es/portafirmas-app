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
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';

part 'repository_error.freezed.dart';

@freezed
class RepositoryError with _$RepositoryError {
  const factory RepositoryError.badRequestListErrors(List<String> listErrors) =
      badRequestListErrors;

  const factory RepositoryError.securityError() = SecurityError;

  const factory RepositoryError.badRequest() = badRequest;

  const factory RepositoryError.noAccess() = NoAccess;

  const factory RepositoryError.notFoundResource() = NotFoundResource;

  const factory RepositoryError.serverError() = ServerError;

  const factory RepositoryError.noInternetConnection() = NoInternetConnection;

  const factory RepositoryError.authExpired() = AuthExpired;
  const factory RepositoryError.anyProblemWithSignature() =
      AnyProblemWithSignature;
  const factory RepositoryError.signWrongCertificate() = _SignWrongCertificate;

  const factory RepositoryError.infoNotMatching() = InfoNotMatching;
  const factory RepositoryError.invalidSignature() = InvalidSignature;
  const factory RepositoryError.docSignatureFailed() = DocSignatureFailed;
  const factory RepositoryError.noUserException() = NoUserException;
  const factory RepositoryError.addNewAuthorizedException() =
      AddNewAuthorizedException;
  const factory RepositoryError.addUserValidatorException() =
      AddUserValidatorException;
  const factory RepositoryError.listErrors(List<String> errorList) =
      ListErrorsM;

  const factory RepositoryError.unknownError() = _UnkwnownError;
  const factory RepositoryError.canceledByUser() = _CanceledByUser;
  const factory RepositoryError.sessionExpired() = _SessionExpired;
  const factory RepositoryError.noCertificatesIOS() = _NoCertificatesIOS;
  const factory RepositoryError.invalidCertificate() = _InvalidCertificate;
  const factory RepositoryError.expiredCertificate() = _ExpiredCertificate;
  const factory RepositoryError.revokedCertificate() = _RevokedCertificate;
  const factory RepositoryError.authorizationPermissionError() =
      _AuthorizationPermissionError;

  const factory RepositoryError.isTimeExpired() = _IsTimeExpired;

  static RepositoryError fromDataSourceError(dynamic error) {
    return error is NetworkError
        ? error.maybeWhen(
            sessionExpired: () => const RepositoryError.sessionExpired(),
            badRequestListErrors: (errors) =>
                RepositoryError.badRequestListErrors(errors),
            infoNotMatching: RepositoryError.infoNotMatching,
            badRequest: () => const RepositoryError.badRequest(),
            forbidden: () => const RepositoryError.noAccess(),
            notFound: (_) => const RepositoryError.notFoundResource(),
            internalServerError: () => const RepositoryError.serverError(),
            noInternetConnection: () =>
                const RepositoryError.noInternetConnection(),
            unauthorizedRequest: () => const RepositoryError.authExpired(),
            certNotValid: () => const RepositoryError.invalidCertificate(),
            noValidSignature: () => const RepositoryError.invalidSignature(),
            anyProblemWithSignature: () =>
                const RepositoryError.anyProblemWithSignature(),
            docSignatureFailed: () =>
                const RepositoryError.docSignatureFailed(),
            noUserException: () => const RepositoryError.noUserException(),
            addNewAuthorizedException: () =>
                const RepositoryError.addNewAuthorizedException(),
            addUserValidatorException: () =>
                const RepositoryError.addUserValidatorException(),
            certExpired: () => const RepositoryError.expiredCertificate(),
            certRevoked: () => const RepositoryError.revokedCertificate(),
            certUserNoPermission: () =>
                const RepositoryError.authorizationPermissionError(),
            signWrongCertificate: () =>
                const RepositoryError.signWrongCertificate(),
            sendTimeout: () => const RepositoryError.isTimeExpired(),
            orElse: () => const RepositoryError.serverError(),
          )
        : const RepositoryError.unknownError();
  }
}
