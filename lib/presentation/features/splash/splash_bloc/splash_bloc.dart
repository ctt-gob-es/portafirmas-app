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
import 'package:portafirmas_app/app/constants/initial_servers.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/authentication_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/portafirmas_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/servers_repository_contract.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

/// The SplashBloc class extends the Bloc class from the flutter_bloc library, which implements the bloc design pattern for state management.
///
/// This class handles the logic related to the splash screen of the application.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final PortafirmasRepositoryContract _repository;
  final AuthenticationRepositoryContract _authRepository;
  final ServersRepositoryContract _serversRepository;

  /// Creates a new instance of the SplashBloc with an initial state of
  /// [SplashState.initial()].
  SplashBloc({
    required PortafirmasRepositoryContract portafirmasRepositoryContract,
    required AuthenticationRepositoryContract authRepository,
    required ServersRepositoryContract serversRepositoryContract,
  })  : _repository = portafirmasRepositoryContract,
        _authRepository = authRepository,
        _serversRepository = serversRepositoryContract,
        super(const SplashState.initial()) {
    /// Listen for [SplashEvent]s and handle them with the [_unSplashInNMilliseconds] method.
    on<SplashEvent>((event, emit) async {
      await event.when(
        unSplashInNMilliseconds: (milliseconds) =>
            _unSplashInNMilliseconds(event, emit, milliseconds),
      );
    });
  }

  /// Delays for the specified [milliseconds] and then emits a [SplashState.splashed()] state using the provided [emit] function.
  ///
  /// @param event The [SplashEvent] that triggered this method call.
  /// @param emit The function to use for emitting a new state.
  /// @param milliseconds The number of milliseconds to delay before emitting a new state.
  Future<void> _unSplashInNMilliseconds(
    SplashEvent event,
    Emitter<SplashState> emit,
    milliseconds,
  ) async {
    final dataFuture = _repository.getWelcomeTourIsFinish();
    final firstTimeFuture = _authRepository.isUserFirstTime();
    final lastAuthMethod = await _authRepository.getLastAuthMethod();
    final isLogged = lastAuthMethod.maybeWhen(
      success: (data) => data != null,
      orElse: () => false,
    );
    await _authRepository.setFirstTime();

    await Future.delayed(Duration(milliseconds: milliseconds));
    final data = await dataFuture;
    final firstTimeFutureResult = await firstTimeFuture;
    bool welcomeTourIsFinished = data.when(
      failure: (error) => false,
      success: (value) => value,
    );
    bool isFirstTime = firstTimeFutureResult.when(
      failure: (_) => true,
      success: (value) => value,
    );

    // this chunk of code is necessary to check if the default server is still available
    // to be selected, if not, the user will be logged out.
    // this is necessary because the default server is stored in the local storage
    // and it could be deleted by the user or changed by the emm server.
    if (isLogged) {
      final defaultServerResponse = await _serversRepository.getDefaultServer();
      final defaultServer = defaultServerResponse.whenOrNull(
        success: (value) => value,
      );

      if (defaultServer != null) {
        final emmServerResponse = await _serversRepository.getEmmServer();
        final emmServer = emmServerResponse.whenOrNull(
          success: (value) => value,
        );

        if (emmServer != null && emmServer.isFixed) {
          if (emmServer.url == defaultServer) {
            return emit(
              SplashState.splashed(
                welcomeTourIsFinished: welcomeTourIsFinished,
                isFirstTime: isFirstTime,
                isLogged: isLogged,
              ),
            );
          }
        }

        final serversResponse = await _serversRepository.getServers();
        final servers = serversResponse.whenOrNull(
          success: (value) => value,
        );

        final serverList = emmServer != null
            ? emmServer.isFixed
                ? <ServerEntity>[]
                : servers
            : [...?servers];

        final initialServerList = emmServer != null
            ? emmServer.isFixed
                ? <ServerEntity>[]
                : [emmServer, ...initialServers]
            : initialServers;

        final fullServerList = [
          emmServer,
          ...initialServerList,
          ...?serverList,
        ];
        final defaultServerIsEligible = fullServerList.any((element) {
          if (element == null) return false;

          return element.url == defaultServer;
        });

        if (defaultServerIsEligible) {
          return emit(
            SplashState.splashed(
              welcomeTourIsFinished: welcomeTourIsFinished,
              isFirstTime: isFirstTime,
              isLogged: isLogged,
            ),
          );
        } else {
          await _authRepository.logOut(false);

          return emit(
            SplashState.splashed(
              welcomeTourIsFinished: welcomeTourIsFinished,
              isFirstTime: isFirstTime,
              isLogged: false,
            ),
          );
        }
      }
    }

    emit(
      SplashState.splashed(
        welcomeTourIsFinished: welcomeTourIsFinished,
        isFirstTime: isFirstTime,
        isLogged: isLogged,
      ),
    );
  }
}
