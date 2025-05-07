/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:af_privacy_policy/af_privacy_policy.dart';
import 'package:af_privacy_policy/core/enums/enum_privacy_policy_check_status.dart';
import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/login_clave_body.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/widget/clave_unauthorize_server_error_overlay.dart';
import 'package:portafirmas_app/presentation/widget/login_error_overlay.dart';
import 'package:portafirmas_app/presentation/widget/server_internal_error_overlay.dart';

typedef AuthBuilder = Widget Function(
  BuildContext context,
  AuthState state,
);

class AuthenticationEnvelope extends StatelessWidget {
  const AuthenticationEnvelope({Key? key, required this.builder})
      : super(key: key);

  final AuthBuilder builder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.screenStatus.whenOrNull(
          error: (e) {
            if (e == const RepositoryError.noCertificatesIOS()) {
              context.go(RoutePath.certificatesListIOS);
            } else if (e != const RepositoryError.sessionExpired()) {
              _showLoginErrorOverlay(context, e);
            }
          },
        );
        state.userAuthStatus.whenOrNull(
          loggedIn: (dni, loggedInWithClave) {
            AFPrivacyPolicy.checkAndShowIfNecessary(
              context: context,
              onChangeStatus: (PrivacyPolicyCheckStatus status) {
                if (status == PrivacyPolicyCheckStatus.success) {
                  context.read<PushBloc>().add(PushEvent.initialize(nif: dni));
                  context.go(RoutePath.home);
                }
              },
            );
          },
          error: (e) => _showServerErrorOverlay(context, e),
        );
      },
      builder: (context, stateAuth) {
        return stateAuth.userAuthStatus.maybeWhen(
          urlLoaded: (loginData) => Scaffold(
            appBar: AFTopSectionBar.action(
              themeComponent: AFThemeComponent.medium,
              onBackTap: () => stateAuth.userAuthStatus.isClaveUrlLoaded()
                  ? context.read<AuthBloc>().add(const AuthEvent.resetState())
                  : context.pop(),
            ),
            body: LoginClaveBodyScreen(data: loginData),
          ),
          orElse: () => builder(context, stateAuth),
        );
      },
    );
  }

  void _showLoginErrorOverlay(
    BuildContext context,
    RepositoryError? e,
  ) {
    if (!_isThereCurrentModalShowing(context)) {
      showModalBottomSheet(
        backgroundColor: AFTheme.of(context).colors.primaryWhite,
        isScrollControlled: true,
        context: context,
        shape: AFOverlayBottomSheetShapeBorder(),
        builder: (ctx) => LoginErrorOverlay(
          error: e ?? const RepositoryError.invalidCertificate(),
        ),
      );
    }
  }

  void _showServerErrorOverlay(
    BuildContext context,
    ClaveErrorType? e,
  ) {
    if (!_isThereCurrentModalShowing(context)) {
      showModalBottomSheet(
        backgroundColor: AFTheme.of(context).colors.primaryWhite,
        isScrollControlled: true,
        context: context,
        shape: AFOverlayBottomSheetShapeBorder(),
        builder: (ctx) => e != null
            ? ClaveUnauthorizeServerErrorOverlay(
                claveErrorType: e,
              )
            : const ServerInternalErrorOverlay(),
      );
    }
  }

  bool _isThereCurrentModalShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
}
