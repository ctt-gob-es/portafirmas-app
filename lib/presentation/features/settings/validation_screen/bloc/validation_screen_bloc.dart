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
import 'package:portafirmas_app/domain/models/validator_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';

part 'validation_screen_bloc.freezed.dart';
part 'validation_screen_event.dart';
part 'validation_screen_state.dart';

class ValidationScreenBloc
    extends Bloc<ValidationScreenEvent, ValidationScreenState> {
  final ValidatorListRepositoryContract _repository;
  ValidationScreenBloc({
    required ValidatorListRepositoryContract repositoryContract,
  })  : _repository = repositoryContract,
        super(ValidationScreenState.initial()) {
    on<ValidationScreenEvent>((event, emit) async {
      await event.when(
        loadUsers: () => _getValidatorList(emit),
        removeUser: (id) => _removeValidatorFromList(emit, id),
        refreshScreen: () {
          emit(ValidationScreenState.initial());
        },
      );
    });
  }

  FutureOr<void> _getValidatorList(Emitter<ValidationScreenState> emit) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    await Future.delayed(const Duration(milliseconds: 400));

    final result = await _repository.getValidatorUserList();
    result.when(
      failure: (e) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(e)));
      },
      success: (validatorUserList) {
        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          listOfValidatorUsers: validatorUserList,
        ));
      },
    );
  }

  FutureOr<void> _removeValidatorFromList(
    Emitter<ValidationScreenState> emit,
    id,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    await Future.delayed(const Duration(milliseconds: 200));

    final result = await _repository.removeValidatorUser(id);
    result.when(
      failure: (e) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(e)));
      },
      success: (_) {
        final localValidatorList =
            List<ValidatorEntity>.from(state.listOfValidatorUsers);
        localValidatorList.removeWhere((_) => _.validatorUser.id == id);

        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          listOfValidatorUsers: localValidatorList,
        ));
      },
    );
  }
}
