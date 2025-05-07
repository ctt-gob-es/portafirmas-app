
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
import 'package:portafirmas_app/domain/repository_contracts/app_version_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/app_version/models/version_case.dart';

part 'app_version_event.dart';
part 'app_version_state.dart';
part 'app_version_bloc.freezed.dart';

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final AppVersionRepositoryContract _repository;
  AppVersionBloc({required AppVersionRepositoryContract repository})
      : _repository = repository,
        super(const AppVersionState.init()) {
    on<AppVersionEvent>((event, emit) async {
      await event.when(
        checkAppVersion: () => _mapCheckVersionEventToState(event, emit),
        resetCheck: () {
          emit(const AppVersionState.init());
        },
        changeVersionState: (AppVersionState newAppVersion) async =>
            emit(newAppVersion),
      );
    });
  }

  FutureOr<void> _mapCheckVersionEventToState(
    AppVersionEvent event,
    Emitter<AppVersionState> emit,
  ) async {
    emit(const AppVersionState.loading());
    final appVersionData = await _repository.getLatestVersion();

    appVersionData.when(
      failure: (error) {
        emit(const AppVersionState.error());
      },
      success: (latestVersion) async {
        String serverVersion = latestVersion.minAppVersion;
        final caseOfVersion = await _repository.getVersionCase();
        final localAppVersion = await _repository.getAppVersion();

        caseOfVersion.when(
          failure: (error) {
            add(AppVersionEvent.changeVersionState(
              newAppVersion: const AppVersionState.error(),
            ));
          },
          success: (dataCase) {
            AppVersionState newVersion;
            switch (dataCase) {
              case VersionCase.updateRequired:
                newVersion = AppVersionState.requiredUpdateVersion(
                  appVersion: localAppVersion,
                  minVersion: serverVersion,
                );
                break;
              case VersionCase.updateRecommended:
                newVersion = AppVersionState.recommendedUpdateVersion(
                  appVersion: localAppVersion,
                );
                break;
              case VersionCase.upToDate:
              default:
                newVersion = AppVersionState.upToDateVersion(
                  appVersion: localAppVersion,
                );
                break;
            }
            add(AppVersionEvent.changeVersionState(newAppVersion: newVersion));
          },
        );
      },
    );
  }
}
