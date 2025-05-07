
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
import 'package:portafirmas_app/data/repositories/models/user_role.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';

part 'profile_state.dart';
part 'profile_event.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final RequestRepositoryContract _repository;
  ProfileBloc({required RequestRepositoryContract repositoryContract})
      : _repository = repositoryContract,
        super(
          ProfileState.initial(),
        ) {
    on<ProfileEvent>(
      (event, emit) async {
        await event.when(
          getProfileList: () => _getProfilesList(emit, event),
          profileSelected: (String? profileDni) {
            UserRole? profileSelect = profileDni != null
                ? state.profiles.firstWhere(
                    (profile) => profile.dni == profileDni,
                  )
                : null;

            emit(state.copyWith(
              selectedProfile: profileSelect,
            ));
          },
        );
      },
    );
  }
  FutureOr<void> _getProfilesList(
    Emitter<ProfileState> emit,
    ProfileEvent event,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    final result = await _repository.getUserRoles();
    result.when(
      failure: (error) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(error)));
      },
      success: (data) {
        emit(state.copyWith(
          profiles: data.userRoles,
          proxyVersionUnder25: data.proxyVersionUnder25,
          screenStatus: const ScreenStatus.success(),
        ));
      },
    );
  }
}
