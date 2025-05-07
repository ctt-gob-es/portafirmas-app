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
import 'package:portafirmas_app/data/repositories/models/user_search.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';

part 'users_search_bloc.freezed.dart';
part 'users_search_event.dart';
part 'users_search_state.dart';

class UsersSearchBloc extends Bloc<UsersSearchEvent, UsersSearchState> {
  final RequestRepositoryContract _repository;
  final ValidatorListRepositoryContract _validatorRepo;
  UsersSearchBloc({
    required RequestRepositoryContract repositoryContract,
    required ValidatorListRepositoryContract listRepositoryContract,
  })  : _repository = repositoryContract,
        _validatorRepo = listRepositoryContract,
        super(UsersSearchState.initial()) {
    on<UsersSearchEvent>((event, emit) async {
      await event.when(
        searchTextChanged: (text, mode) =>
            _onSearchTextChanged(text, mode, emit),
        selectedUser: (user) {
          _handleValidatorSelected(user, emit);
        },
        handleValidator: (validator) async {
          await _handleValidator(emit, validator);
        },
        clearResults: () {
          emit(UsersSearchState.initial());
        },
        wrongFormat: (results) {
          emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
          emit(state.copyWith(
            suggestedUsers: [],
            numberOfResults: results,
          ));
        },
      );
    });
  }

  FutureOr<void> _onSearchTextChanged(
    String text,
    String mode,
    Emitter<UsersSearchState> emit,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    if (text.isEmpty) {
      emit(
        state.copyWith(
          suggestedUsers: [],
          screenStatus: const ScreenStatus.initial(),
        ),
      );

      return;
    }

    final result = await _repository.getUserBySearch(text, mode);

    result.when(
      failure: (e) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(e)));
      },
      success: (usersList) {
        final suggestedUsers = usersList
            .where(
              (user) {
                return user.name.toLowerCase().contains(text.toLowerCase()) ||
                    user.dni.contains(text) ||
                    user.id.toString().contains(text);
              },
            )
            .toSet()
            .toList();

        final numberOfResults = suggestedUsers.length;

        emit(state.copyWith(
          selectedUser: null,
          screenStatus: const ScreenStatus.success(),
          suggestedUsers: suggestedUsers,
          numberOfResults: numberOfResults,
          isButtonEnabled: false,
          isUserAdded: false,
        ));
      },
    );
  }

  void _handleValidatorSelected(UserSearch user, emit) {
    emit(state.copyWith(
      screenStatus: const ScreenStatus.success(),
      selectedUser: user,
      isButtonEnabled: true,
      isUserAdded: false,
    ));
  }

  FutureOr<void> _handleValidator(
    Emitter<UsersSearchState> emit,
    UserSearch user,
  ) async {
    final result =
        await _validatorRepo.addValidatorUser(user.dni, user.id, user.name);

    result.when(
      failure: (e) {
        emit(state.copyWith(
          screenStatus: ScreenStatus.error(e),
          isUserAdded: false,
          isButtonEnabled: false,
        ));
      },
      success: (_) {
        emit(state.copyWith(
          isButtonEnabled: false,
          screenStatus: const ScreenStatus.success(),
          isUserAdded: true,
        ));
      },
    );
  }
}
