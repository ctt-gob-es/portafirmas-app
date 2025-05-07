
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

/// The `AuthState` class represents the current state of the user's
/// authentication status.
///
/// [user] - An optional instance of the `User` class that contains the user's
/// information.
///
/// [userAuthStatus] - An instance of the `UserAuthStatus` class that
/// represents the current authentication status of the user.
///
/// [authProcessStatus] - An instance of the `AuthProcessStatus` class that
/// represents the status of the authentication, if is need to select a
/// certificate or to add new one
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required ScreenStatus screenStatus,
    required UserAuthStatus userAuthStatus,
    required bool isWelcomeTourFinished,
  }) = _AuthState;

  /// This factory method creates a new instance of `AuthState` with initial state.
  factory AuthState.initial() {
    return const AuthState(
      screenStatus: ScreenStatus.initial(),
      userAuthStatus: UserAuthStatus.unidentified(),
      isWelcomeTourFinished: false,
    );
  }
}
