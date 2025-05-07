/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/
import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/login_clave_body.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificate_status_check.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/widget/clave_unauthorize_server_error_overlay.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/id_method_overlay.dart';
import 'package:portafirmas_app/presentation/widget/loading_component.dart';
import 'package:portafirmas_app/presentation/widget/login_error_overlay.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color white = AFTheme.of(context).colors.primaryWhite;

    return BlocConsumer<CertificatesHandleBloc, CertificatesHandleState>(
      listener: (context, stateCertificateHandle) {
        if (GoRouter.of(context).location == RoutePath.authentication) {
          stateCertificateHandle.certificateCheck.when(
            idle: () => DoNothingAction(),
            loading: () => DoNothingAction(),
            error: (e) => DoNothingAction(),
            goToAddCertificate: () => context.go(
              RoutePath.explainAddCert,
            ),
            goToCertificateServerScreen: () =>
                context.go(RoutePath.serverCertScreen),
          );
        }
      },
      builder: (context, stateCertificateHandle) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, stateAuth) {
            if (stateAuth.userAuthStatus.isError()) {
              if (stateAuth.userAuthStatus.error != null) {
                _showClavePermanenteErrorOverlay(
                  context,
                  stateAuth.userAuthStatus.error ?? ClaveErrorType.unknown,
                );
              } else {
                _showLoginErrorOverlay(
                  context,
                  stateAuth.screenStatus.whenOrNull(
                    error: (value) => value,
                  ),
                );
              }
            }
          },
          builder: (context, stateAuth) {
            return Scaffold(
              backgroundColor: white,
              appBar: AFTopSectionBar.action(
                themeComponent: AFThemeComponent.medium,
                onBackTap: () => stateAuth.userAuthStatus.isClaveUrlLoaded()
                    ? context.read<AuthBloc>().add(const AuthEvent.resetState())
                    : context.pop(),
              ),
              body: stateAuth.screenStatus.isLoading() ||
                      stateCertificateHandle.certificateCheck.isLoading()
                  ? const LoadingComponent()
                  : stateAuth.userAuthStatus.maybeWhen(
                      urlLoaded: (loginData) =>
                          LoginClaveBodyScreen(data: loginData),
                      orElse: () => Padding(
                        padding: const EdgeInsets.all(Spacing.space4),
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(Spacing.space4),
                                child: AFTitle(
                                  brightness: AFThemeBrightness.light,
                                  title: context.localizations.choose_id_title,
                                  subTitle: context.localizations
                                      .choose_identification_method_description,
                                  size: AFTitleSize.l,
                                  align: AFTitleAlign.left,
                                ),
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ExpandedButton(
                                    text: context.localizations.general_clave,
                                    isTertiary: true,
                                    size: AFButtonSize.l,
                                    iconRight: Assets.iconExternalLink,
                                    onTap: () => context.read<AuthBloc>().add(
                                          const AuthEvent.signInByClave(),
                                        ),
                                  ),
                                  const SizedBox(
                                    height: Spacing.space3,
                                  ),
                                  ExpandedButton(
                                    text: context
                                        .localizations.general_certificate,
                                    isTertiary: true,
                                    onTap: () => context
                                        .read<CertificatesHandleBloc>()
                                        .add(
                                          const CertificatesHandleEvent
                                              .checkCertificates(),
                                        ),
                                  ),
                                  const SizedBox(
                                    height: Spacing.space4,
                                  ),
                                  ClearButton(
                                    text: context
                                        .localizations.choose_id_register,
                                    onTap: () => _showHelpOverlay(
                                      context,
                                      true,
                                    ),
                                  ),
                                  SafeArea(
                                    top: false,
                                    child: ClearButton(
                                      text: context
                                          .localizations.general_need_help,
                                      onTap: () => _showHelpOverlay(
                                        context,
                                        false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Spacing.space4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
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

  void _showClavePermanenteErrorOverlay(
    BuildContext context,
    ClaveErrorType claveErrorType,
  ) {
    if (!_isThereCurrentModalShowing(context)) {
      showModalBottomSheet(
        backgroundColor: AFTheme.of(context).colors.primaryWhite,
        isScrollControlled: true,
        context: context,
        shape: AFOverlayBottomSheetShapeBorder(),
        builder: (ctx) => ClaveUnauthorizeServerErrorOverlay(
          claveErrorType: claveErrorType,
        ),
      );
    }
  }

  bool _isThereCurrentModalShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  void _showHelpOverlay(
    BuildContext context,
    bool isClaveRegister,
  ) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (ctx) => IdMethodOverlay(
        isClaveRegister: isClaveRegister,
        onTapHelp: () {
          context.pop();
          _showHelpOverlay(
            context,
            false,
          );
        },
      ),
    );
  }
}
