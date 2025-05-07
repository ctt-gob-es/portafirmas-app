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

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/repository_contracts/authentication_repository_contract.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// A [Bloc] responsible for managing user authentication.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepositoryContract _repository;

  /// Constructs an [AuthBloc] with the provided dependencies.
  AuthBloc({
    required AuthenticationRepositoryContract repositoryContract,
  })  : _repository = repositoryContract,
        super(
          AuthState.initial(),
        ) {
    on<AuthEvent>(
      (event, emit) async {
        await event.when(
          signOutEvent: (deleteLastAuthMethod) => _mapSignOutEventToState(deleteLastAuthMethod, emit),
          signInByDefaultCertificateEvent: () =>
              _mapSignInByDefaultCertificateEventToState(
            event,
            emit,
          ),
          signInByCertificateEvent: (context) =>
              _mapSignInByCertificateEventToState(
            event,
            emit,
            context,
          ),
          trySignInWithLastMethod: (context) => _mapTrySignInWithLastMethod(
            event,
            emit,
            context,
          ),
          setOnBoardingValue: (value) {
            emit(
              state.copyWith(isWelcomeTourFinished: value),
            );
          },
          errorLoginByClaveUnauthorizeServerAccess: (message) async =>
              _onErrorLoginByClaveUnauthorizeServerAccess(emit, message),
          errorLoginByClave: () {
            if (!state.userAuthStatus.isError()) {
              emit(
                state.copyWith(
                  userAuthStatus: const UserAuthStatus.error(),
                ),
              );
              emit(
                state.copyWith(
                  userAuthStatus: const UserAuthStatus.unidentified(),
                ),
              );
            }
          },
          successLoginByClave: (nif, sessionId) =>
              _mapSuccessLoginByClaveEventToState(event, emit, nif, sessionId),
          signInByClave: () => _mapSignInByClaveEventToState(event, emit),
          resetState: () {
            emit(AuthState.initial()
                .copyWith(isWelcomeTourFinished: state.isWelcomeTourFinished));
          },
        );
      },
    );
  }

  void _onErrorLoginByClaveUnauthorizeServerAccess(
    Emitter<AuthState> emit,
    String message,
  ) {
    final error = ClaveErrorType.fromValue(message);

    if (!state.userAuthStatus.isError()) {
      emit(
        state.copyWith(userAuthStatus: UserAuthStatus.error(error: error)),
      );
      emit(
        state.copyWith(userAuthStatus: const UserAuthStatus.unidentified()),
      );
    }
  }

  /// Saves session id
  FutureOr<void> _mapSuccessLoginByClaveEventToState(
    AuthEvent event,
    Emitter<AuthState> emit,
    String nif,
    String sessionId,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    await _repository.saveSessionId(sessionId: sessionId);

    await _repository.setLastAuthMethod(
      const AuthMethod.clave(),
    );

    emit(state.copyWith(
      userAuthStatus: UserAuthStatus.loggedIn(dni: nif, loggedWithClave: true),
      screenStatus: const ScreenStatus.success(),
    ));
  }

  /// Does sign in with Cl@ve
  FutureOr<void> _mapSignInByClaveEventToState(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));

    final data = await _repository.loginWithClave();

    data.when(
      failure: (e) {
        emit(
          state.copyWith(
            screenStatus: ScreenStatus.error(e),
            userAuthStatus: const UserAuthStatus.error(),
          ),
        );

        emit(
          state.copyWith(
            userAuthStatus: const UserAuthStatus.unidentified(),
          ),
        );
      },
      success: (loginData) {
        emit(
          state.copyWith(
            userAuthStatus: UserAuthStatus.urlLoaded(loginData: loginData),
            screenStatus: const ScreenStatus.success(),
          ),
        );
      },
    );
  }

  /// Maps the [AuthEvent.signInByDefaultCertificateEvent] event to the appropriate state.
  FutureOr<void> _mapSignInByDefaultCertificateEventToState(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        screenStatus: const ScreenStatus.loading(),
      ),
    );

    final result = await _repository.loginWithDefaultCertificate();

    result.when(
      failure: (e) => emit(
        state.copyWith(
          screenStatus: ScreenStatus.error(e),
        ),
      ),
      success: (dni) async {
        emit(
          state.copyWith(
            userAuthStatus:
                UserAuthStatus.loggedIn(dni: dni, loggedWithClave: false),
          ),
        );

        await _repository.setLastAuthMethod(
          const AuthMethod.certificate(),
        );
      },
      noDefaultCertificate: () => emit(
        state.copyWith(
          userAuthStatus: const UserAuthStatus.error(),
        ),
      ),
    );
  }

  /// Maps the [AuthEvent.signInByCertificateEvent] event to the appropriate state.
  FutureOr<void> _mapSignInByCertificateEventToState(
    AuthEvent event,
    Emitter<AuthState> emit,
    BuildContext context,
  ) async {
    emit(state.copyWith(
      screenStatus: const ScreenStatus.loading(),
    ));

    final result = await _repository.loginWithCertificate(context);

    result.when(
      failure: (e) => emit(
        state.copyWith(
          screenStatus: ScreenStatus.error(e),
        ),
      ),
      success: (dni) async {
        emit(
          state.copyWith(
            userAuthStatus:
                UserAuthStatus.loggedIn(dni: dni, loggedWithClave: false),
          ),
        );

        await _repository.setLastAuthMethod(
          const AuthMethod.certificate(),
        );
      },
    );
  }

  /// Maps the [AuthEvent.trySignInWithLastMethod] event to the appropriate state.
  FutureOr<void> _mapTrySignInWithLastMethod(
    AuthEvent event,
    Emitter<AuthState> emit,
    BuildContext context,
  ) async {
    emit(state.copyWith(
      screenStatus: const ScreenStatus.loading(),
    ));

    final result = await _repository.getLastAuthMethod();

    result.when(
      failure: (e) => emit(
        state.copyWith(
          screenStatus: ScreenStatus.error(e),
        ),
      ),
      success: (value) {
        if (value == null) {
          emit(
            state.copyWith(
              screenStatus: const ScreenStatus.error(),
            ),
          );
        } else {
          value.when(
            certificate: () {
              add(AuthEvent.signInByCertificateEvent(context));
            },
            clave: () {
              add(const AuthEvent.signInByClave());
            },
          );
        }
      },
    );
  }

  FutureOr<void> _mapSignOutEventToState(
    bool? deleteLastAuthMethod,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(screenStatus: const ScreenStatus.loading()));
    
    final data = await _repository.logOut(deleteLastAuthMethod ?? false);

    data.when(
      failure: (e) => emit(
        state.copyWith(
          screenStatus: ScreenStatus.error(e),
          userAuthStatus: const UserAuthStatus.unidentified(),
        ),
      ),
      success: (value) => emit(
        state.copyWith(
          screenStatus: const ScreenStatus.initial(),
          userAuthStatus: const UserAuthStatus.unidentified(),
        ),
      ),
    );
  }
}
