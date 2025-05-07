
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/authorizations_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/model/authorization_status.dart';

import 'package:portafirmas_app/app/constants/literals.dart';

part 'authorization_screen_event.dart';
part 'authorization_screen_state.dart';
part 'authorization_screen_bloc.freezed.dart';

class AuthorizationScreenBloc
    extends Bloc<AuthorizationScreenEvent, AuthorizationScreenState> {
  final AuthorizationsRepositoryContract _repository;
  AuthorizationScreenBloc({
    required AuthorizationsRepositoryContract repositoryContract,
  })  : _repository = repositoryContract,
        super(AuthorizationScreenState.initial()) {
    on<AuthorizationScreenEvent>((event, emit) async {
      await event.when(
        loadAuthorizations: () => _getAuthorizationList(emit),
        addAuthorization: (user) => _addAuthorization(emit, user),
        revokeAuthorization: (state) => _revokeAuthorization(emit, state),
        acceptAuthorization: () => _acceptAuthorization(emit),
        getSelectedAuthorization: (authorization) =>
            _getAuthorization(emit, authorization),
      );
    });
  }

  FutureOr<void> _getAuthorizationList(
    Emitter<AuthorizationScreenState> emit,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));

    final result = await _repository.getAuthorizationsList();

    result.when(
      failure: (error) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(error)));
      },
      success: (authorizationList) {
        final sentAuthorizations =
            authorizationList.where((auth) => auth.sended == true).toList();

        final receivedAuthorizations = authorizationList
            .where((auth) => auth.sended == false || auth.sended == null)
            .toList();

        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: authorizationList,
          listOfAuthorizationsSend: sentAuthorizations,
          listOfAuthorizationsReceived: receivedAuthorizations,
        ));
      },
    );
  }

  FutureOr<void> _addAuthorization(
    Emitter<AuthorizationScreenState> emit,
    NewAuthorizationUserEntity data,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));

    final result = await _repository.addAuthorization(data);

    result.when(
      failure: (error) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(error)));
      },
      success: (_) {
        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          newAuthorization: data,
        ));
      },
    );
  }

  FutureOr<void> _revokeAuthorization(
    Emitter<AuthorizationScreenState> emit,
    AuthorizationStatus status,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    final result = await _repository.revokeAuthorization(
      state.authorization?.id ?? '',
      status.name,
    );

    result.when(
      failure: (e) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(e)));
      },
      success: (e) {
        final localAuthorizationList = state.listOfAuthorizations.map((auth) {
          if (auth.id == (state.authorization?.id ?? '')) {
            AuthorizationStatus state = AuthorizationStatus.revoked;
            String authState = state.name;

            return auth.copyWith(state: authState);
          }

          return auth;
        }).toList();

        final revokedAuthorization = localAuthorizationList.firstWhere(
          (auth) => auth.id == (state.authorization?.id ?? ''),
        );

        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: localAuthorizationList,
          authorization: revokedAuthorization,
        ));
      },
    );
  }

  FutureOr<void> _acceptAuthorization(
    Emitter<AuthorizationScreenState> emit,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    final result =
        await _repository.acceptedAuthorization(state.authorization?.id ?? '');

    result.when(
      failure: (e) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(e)));
      },
      success: (e) {
        final localAuthorizationList = state.listOfAuthorizations.map((auth) {
          if (auth.id == (state.authorization?.id ?? '')) {
            AuthorizationStatus state = AuthorizationStatus.accepted;
            String atuhState = state.name;

            return auth.copyWith(state: atuhState);
          }

          return auth;
        }).toList();

        final acceptedAuthorization = localAuthorizationList.firstWhere(
          (auth) => auth.id == (state.authorization?.id ?? ''),
        );

        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: localAuthorizationList,
          authorization: acceptedAuthorization,
        ));
      },
    );
  }

  _getAuthorization(
    Emitter<AuthorizationScreenState> emit,
    AuthDataEntity authorization,
  ) {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    emit(state.copyWith(
      screenStatus: const ScreenStatus.success(),
      authorization: authorization,
    ));
  }
}
