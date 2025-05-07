/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';

extension BuildContextLogoutExtension on BuildContext {
  /// Manual Log Out => User clicks on logout
  /// In this situation push notification must be muted
  /// When session expires this is not the case
  void logout({bool deleteLastAuthMethod = false}) async {
    read<ProfileBloc>().add(const ProfileEvent.profileSelected(null));
    if (deleteLastAuthMethod) {
      read<PushBloc>().add(const PushEvent.muteNotifications());
    }
    Future.delayed(
        const Duration(milliseconds: 500),
        () => read<AuthBloc>().add(
              AuthEvent.signOutEvent(
                  deleteLastAuthMethod: deleteLastAuthMethod),
            ));
  }
}
