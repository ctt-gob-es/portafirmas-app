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
import 'package:portafirmas_app/domain/models/login_clave_entity.dart';

part 'auth_status.freezed.dart';

/// Enum representing the different types of errors that can occur during in the
/// authentication process.
enum ClaveErrorType {
  /// Thrown when clave is not operative in that moment.
  unknown,

  /// Thrown when the user is not authorized to access to server through clave
  /// or clave is not operative in that moment.
  unauthorized,

  /// Thrown when clave is expired.
  expired,

  /// Thrown Validation service error.
  revoked,

  noUserException,

  serviceValidationError;

  static ClaveErrorType fromValue(String value) {
    if (value.contains('COD_103')) {
      return ClaveErrorType.unauthorized;
    } else if (value.contains('COD_104')) {
      return ClaveErrorType.expired;
    } else if (value.contains('COD_105')) {
      return ClaveErrorType.revoked;
    } else if (value.contains('COD_106')) {
      return ClaveErrorType.serviceValidationError;
    } else {
      return ClaveErrorType.unknown;
    }
  }
}

@freezed
class UserAuthStatus with _$UserAuthStatus {
  const factory UserAuthStatus.unidentified() = _Unidentified;

  const factory UserAuthStatus.loggedIn({
    required String dni,
    required bool loggedWithClave,
  }) = _LoggedIn;

  const factory UserAuthStatus.urlLoaded({
    required LoginClaveEntity loginData,
  }) = _UrlLoaded;

  /// Used to represent an error state. [error] can be used to specify
  /// the type of error that occurred.
  const factory UserAuthStatus.error({ClaveErrorType? error}) = _Error;
}

extension UserLoadingStatusExtension on UserAuthStatus {
  bool isUnidentified() =>
      maybeWhen(orElse: () => false, unidentified: () => true);

  bool isLoggedIn() =>
      maybeWhen(orElse: () => false, loggedIn: (_, __) => true);

  bool isError() => maybeWhen(orElse: () => false, error: (_) => true);

  ClaveErrorType? get error => maybeWhen(
        error: (error) => error,
        orElse: () => null,
      );

  bool isClaveUrlLoaded() =>
      maybeWhen(orElse: () => false, urlLoaded: (_) => true);

  bool isLoggedInWithClave() => maybeWhen(
        orElse: () => false,
        loggedIn: (_, loggedWithClave) => true && loggedWithClave,
      );
}
