
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'authorization_screen_bloc.dart';

@freezed
class AuthorizationScreenState with _$AuthorizationScreenState {
  const factory AuthorizationScreenState({
    required ScreenStatus screenStatus,
    required List<AuthDataEntity> listOfAuthorizations,
    required List<AuthDataEntity> listOfAuthorizationsSend,
    required List<AuthDataEntity> listOfAuthorizationsReceived,
    required AuthDataEntity? authorization,
    required NewAuthorizationUserEntity newAuthorization,
  }) = _AuthorizationScreenState;

  factory AuthorizationScreenState.initial() => AuthorizationScreenState(
        screenStatus: const ScreenStatus.initial(),
        listOfAuthorizations: [],
        listOfAuthorizationsSend: [],
        listOfAuthorizationsReceived: [],
        authorization: null,
        newAuthorization: NewAuthorizationUserEntity(
          type: '',
          nif: '',
          id: '',
          observations: '',
          startDate: '',
          expDate: '',
        ),
      );
}

extension AuthorizationScreenStateExtension on AuthorizationScreenState {
  List<AuthDataEntity> get pendingAuthorizations {
    final authorizationList = listOfAuthorizations
        .where((authData) =>
            authData.state?.toLowerCase() ==
                StatusAuthorization.pendingStatus &&
            authData.sended != true)
        .toList();

    return authorizationList;
  }
}
