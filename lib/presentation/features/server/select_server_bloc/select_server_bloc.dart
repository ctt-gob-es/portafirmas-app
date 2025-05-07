/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/constants/initial_servers.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/migration_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/servers_repository_contract.dart';

part 'select_server_bloc.freezed.dart';
part 'select_server_event.dart';
part 'select_server_state.dart';

class SelectServerBloc extends Bloc<SelectServerEvent, SelectServerState> {
  final ServersRepositoryContract _serversRepository;
  final MigrationRepositoryContract _migrationRepository;
  final CertificateRepositoryContract _certificateRepository;

  /// Determine if the app is being opened for the first time
  /// or come from an update.
  final bool _isFromInstallation;

  SelectServerBloc({
    required ServersRepositoryContract serversRepository,
    required MigrationRepositoryContract migrationRepository,
    required CertificateRepositoryContract certificateRepository,
    required bool isFromInstallation,
  })  : _isFromInstallation = isFromInstallation,
        _serversRepository = serversRepository,
        _certificateRepository = certificateRepository,
        _migrationRepository = migrationRepository,
        super(SelectServerState.initial()) {
    on<SelectServerEvent>((event, emit) async {
      await event.when(
        selectServer: (server) => _mapToSelectServer(emit, server: server),
        loadServers: () async => await _mapToLoadServers(emit),
        loadMigratedServers: () async => await _mapToLoadMigratedServers(emit),
        setSelectedServerDefault: () async =>
            await _mapToSetSelectedServerDefault(emit),
        addServer: (
          alias,
          url,
        ) async =>
            _mapToAddServer(emit, alias: alias, url: url),
        updateServer: (
          dbIndex,
          alias,
          url,
        ) async =>
            await _mapToUpdateServer(
          emit,
          dbIndex: dbIndex,
          alias: alias,
          url: url,
        ),
        deleteServer: (int dbIndex) async =>
            await _mapToDeleteServer(emit, dbIndex: dbIndex),
        changeScreen: () {
          emit(state.copyWith(
            defaultServerStatus: const ScreenStatus.initial(),
          ));
        },
      );
    });
  }

  _mapToSelectServer(
    Emitter<SelectServerState> emit, {
    required ServerEntity server,
  }) {
    emit(state.copyWith(
      preSelectedServer: server,
      defaultServerStatus: const ScreenStatus.initial(),
    ));
  }

  _mapToLoadServers(
    Emitter<SelectServerState> emit,
  ) async {
    emit(state.copyWith(
      serversDataStatus: const ScreenStatus.loading(),
      serversMigrationDataStatus: const ScreenStatus.initial(),
    ));
    //final emmServer = await _serversRepository.getEmmServers();

    final emmServerResponse = await _serversRepository.getEmmServer();
    final emmServer = emmServerResponse.maybeWhen(
      orElse: () => null,
      success: (server) => server,
    );
    final result = await _serversRepository.getServers();
    final resultDefault = await _serversRepository.getDefaultServer();

    final isFixed = emmServer?.isFixed ?? false;

    result.when(
      failure: (e) => emit(
        state.copyWith(serversDataStatus: ScreenStatus.error(e)),
      ),
      success: (servers) {
        final newServers = emmServer != null
            ? isFixed
                ? [emmServer]
                : [emmServer, ...SelectServerState.initial().servers]
            : [...SelectServerState.initial().servers, ...servers];
        bool hasDefaultServer = resultDefault.maybeWhen(
          orElse: () => false,
          success: (server) => server != null,
        );

        ServerEntity? defaultEntity =
            resultDefault.whenOrNull(success: (urlDefault) {
          return newServers.firstWhere(
            (element) => element.url == urlDefault,
            orElse: () => state.servers.first,
          );
        });
        emit(state.copyWith(
          preSelectedServer:
              emmServer ?? defaultEntity ?? state.preSelectedServer,
          selectedServerFinal: hasDefaultServer ? defaultEntity : null,
          servers: newServers,
          serversDataStatus: const ScreenStatus.success(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
        ));
      },
    );
  }

  _mapToLoadMigratedServers(
    Emitter<SelectServerState> emit,
  ) async {
    if (state.serversMigrationDataStatus.maybeWhen(
      orElse: () => false,
      success: () => true,
      loading: () => true,
    )) {
      return;
    }

    emit(state.copyWith(
      serversMigrationDataStatus: const ScreenStatus.loading(),
    ));

    //checks if servers have been migrated
    final serversMigratedResult = await _serversRepository.getServersMigrated();
    bool serversMigrated =
        serversMigratedResult.when(failure: (_) => false, success: (e) => e);

    if (!serversMigrated) {
      //If servers have not been migrated, migrate them
      final result = await _migrationRepository.migrateServers();
      await _migrationRepository.migrateDefaultCertificate();

      result.when(
        failure: (e) => emit(
          state.copyWith(serversMigrationDataStatus: ScreenStatus.error(e)),
        ),
        success: (_) async {
          emit(
            state.copyWith(
              serversMigrationDataStatus: const ScreenStatus.success(),
            ),
          );

          await _serversRepository.setServersMigrated();
        },
      );
    } else {
      // If native migration was done, we need to handle flutter migration.
      if (_isFromInstallation) {
        await _certificateRepository.deleteAllCertificate();
      }

      emit(state.copyWith(
        serversMigrationDataStatus: const ScreenStatus.success(),
      ));
    }
  }

  _mapToSetSelectedServerDefault(
    Emitter<SelectServerState> emit,
  ) async {
    emit(state.copyWith(
      defaultServerStatus: const ScreenStatus.loading(),
    ));
    final result =
        await _serversRepository.setDefaultServer(state.preSelectedServer);
    result.when(
      failure: (e) => emit(state.copyWith(
        defaultServerStatus: ScreenStatus.error(e),
      )),
      success: (_) => emit(
        state.copyWith(
          defaultServerStatus: const ScreenStatus.success(),
          selectedServerFinal: state.preSelectedServer,
        ),
      ),
    );
  }

  _mapToAddServer(
    Emitter<SelectServerState> emit, {
    required String alias,
    required String url,
  }) async {
    emit(state.copyWith(serversDataStatus: const ScreenStatus.loading()));
    final result = await _serversRepository.addServer(
      alias,
      url,
    );

    result.when(
      failure: (e) => emit(state.copyWith(
        serversDataStatus: ScreenStatus.error(e),
      )),
      success: (newServer) => emit(
        state.copyWith(
          servers: [...state.servers, newServer],
          serversDataStatus: const ScreenStatus.success(),
        ),
      ),
    );
  }

  _mapToUpdateServer(
    Emitter<SelectServerState> emit, {
    required int dbIndex,
    required String alias,
    required String url,
  }) async {
    emit(state.copyWith(serversDataStatus: const ScreenStatus.loading()));
    final result = await _serversRepository.modifyServer(
      dbIndex,
      alias,
      url,
    );

    result.when(
      failure: (e) => emit(state.copyWith(
        serversDataStatus: ScreenStatus.error(e),
      )),
      success: (newServer) {
        final newList = [...state.servers];
        int index =
            newList.indexWhere((element) => element.databaseIndex == dbIndex);
        newList.removeAt(index);
        newList.insert(index, newServer);
        emit(
          state.copyWith(
            serversDataStatus: const ScreenStatus.success(),
            servers: newList,
            preSelectedServer: newServer,
          ),
        );
      },
    );
  }

  _mapToDeleteServer(
    Emitter<SelectServerState> emit, {
    required int dbIndex,
  }) async {
    emit(state.copyWith(serversDataStatus: const ScreenStatus.loading()));
    final result = await _serversRepository.deleteServer(
      dbIndex,
    );
    result.when(
      failure: (e) => emit(state.copyWith(
        serversDataStatus: ScreenStatus.error(e),
      )),
      success: (_) {
        final newList = [...state.servers]
          ..removeWhere((element) => element.databaseIndex == dbIndex);
        emit(
          state.copyWith(
            preSelectedServer: newList.first,
            servers: newList,
            serversDataStatus: const ScreenStatus.success(),
          ),
        );
      },
    );
  }
}
