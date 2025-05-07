
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
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';

part 'app_filter_event.dart';
part 'app_filter_state.dart';
part 'app_filter_bloc.freezed.dart';

class AppFilterBloc extends Bloc<AppFilterEvent, AppFilterState> {
  final RequestRepositoryContract _repository;
  AppFilterBloc({required RequestRepositoryContract repositoryContract})
      : _repository = repositoryContract,
        super(AppFilterState.initial()) {
    on<AppFilterEvent>((event, emit) async {
      await event.when(
        getAppList: () async => _getAppList(emit),
      );
    });
  }

  FutureOr<void> _getAppList(Emitter<AppFilterState> emit) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    await Future.delayed(const Duration(milliseconds: 200));

    final result = await _repository.getUserRequestApps();
    result.when(
      failure: (error) {
        emit(state.copyWith(screenStatus: ScreenStatus.error(error)));
      },
      success: (apps) {
        emit(state.copyWith(
          screenStatus: const ScreenStatus.success(),
          appList: apps,
        ));
      },
    );
  }
}
