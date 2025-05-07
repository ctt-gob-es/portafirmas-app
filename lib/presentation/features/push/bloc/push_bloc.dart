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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/push_repository_contract.dart';

part 'push_bloc.freezed.dart';
part 'push_event.dart';
part 'push_state.dart';

class PushBloc extends Bloc<PushEvent, PushState> {
  final PushRepositoryContract _pushRepository;
  final FlutterSecureStorage _secureStorage;
  PushBloc({
    required PushRepositoryContract pushRepository,
    required FlutterSecureStorage secureStorage,
  })  : _pushRepository = pushRepository,
        _secureStorage = secureStorage,
        super(const PushState.idle()) {
    on<PushEvent>((event, emit) async {
      await event.when(
        initialize: (nif) async {
          await _mapInitializeEventToState(nif, emit);
        },
        userPreferences: (nif) => _userPreferences(nif, emit),
        notificationReceived: ((title, body) {
          emit(
            PushState.hasNewNotification(
              title: title,
              body: body,
            ),
          );
        }),
        muteNotifications: () async {
          await _mapMuteEventToState(emit);
        },
        unMuteNotifications: () async {
          await _mapUnmuteEventToState(emit);
        },
        setNewPushState: (PushState pushState) {
          emit(pushState);
        },
      );
    });
  }
  FutureOr<void> _mapInitializeEventToState(
    String nif,
    Emitter<PushState> emit,
  ) async {
    String? savedNif = await _pushRepository.getUserNif();
    // If is new user registry on push notifications
    if (savedNif == null) {
      await _pushRepository.saveUserNif(nif);
      await _requestPermissionsAndInitialize(emit);
    }

    // if new user is different from saved user, unregister previous and register new user
    else if (savedNif != nif) {
      await _pushRepository.unRegisterDevice();
      await _pushRepository.saveUserNif(nif);
      await _requestPermissionsAndInitialize(emit);
    }

    // if user doesn't change, just initialize
    else {
      await _requestPermissionsAndInitialize(emit);
    }
  }

  FutureOr<void> _mapMuteEventToState(
    Emitter<PushState> emit,
  ) async {
    final res = await _pushRepository.updatePush(status: false);
    res.when(
      failure: (error) {
        emit(
          PushState.operationError(
            status: ScreenStatus.error(error),
          ),
        );
      },
      success: (success) {
        emit(const PushState.mutedNotifications());
      },
    );
  }

  FutureOr<void> _mapUnmuteEventToState(
    Emitter<PushState> emit,
  ) async {
    await _pushRepository.requestPermissions();
    final res = await _pushRepository.updatePush(status: true);

    res.when(
      failure: (error) {
        emit(
          PushState.operationError(
            status: ScreenStatus.error(error),
          ),
        );
      },
      success: (success) {
        emit(const PushState.waitingNotifications());
      },
    );
  }

  FutureOr<bool> _requestPermissionsAndInitialize(
    Emitter<PushState> emit,
  ) async {
    final pushEnabled =
        await _pushRepository.requestPermissionsAndInitialize((title, message) {
      add(
        PushEvent.notificationReceived(
          title: title ?? '',
          body: message ?? '',
        ),
      );
    });

    return pushEnabled;
  }

  _userPreferences(String nif, Emitter<PushState> emit) {
    _secureStorage.read(key: nif).then((value) async {
      if (value == 'true') {
        add(const PushEvent.unMuteNotifications());
      } else if (value == 'false') {
        add(const PushEvent.muteNotifications());
      } else {
        final permissionStatus =
            await _pushRepository.checkNotificationPermStatus();
        if (permissionStatus == 'granted') {
          add(const PushEvent.unMuteNotifications());
        } else {
          add(const PushEvent.muteNotifications());
        }
      }
    });
  }
}
