/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'auth_bloc.dart';

/// The `AuthEvent` class is a sealed class that represents the various types of events that can occur during authentication.
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signInByDefaultCertificateEvent() =
      _SignInByDefaultCertificateEvent;
  const factory AuthEvent.signInByCertificateEvent(BuildContext context) =
      _SignInByCertificateEvent;
  const factory AuthEvent.signInByClave() = _SignInByClave;

  const factory AuthEvent.trySignInWithLastMethod(BuildContext context) =
      _SignInWithLastMethod;

  const factory AuthEvent.errorLoginByClave() = _ErrorLoginByClave;
  const factory AuthEvent.errorLoginByClaveUnauthorizeServerAccess(
    String message,
  ) = _ErrorLoginByClaveUnauthorizeServerAccess;

  const factory AuthEvent.successLoginByClave({
    required String nif,
    required String sessionId,
  }) = _SuccessLoginByClave;

  /// This factory method represents the event where the user has signed out.
  const factory AuthEvent.signOutEvent({bool? deleteLastAuthMethod}) = _SignOutEvent;

  const factory AuthEvent.setOnBoardingValue(bool value) = _SetOnBoardingValue;

  const factory AuthEvent.resetState() = _ResetState;
}
