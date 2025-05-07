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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/widgets/certificate_card.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/server_card.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/custom_title_subtitle_box.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/login_error_overlay.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

class CertificateAndServerSelectedScreen extends StatelessWidget {
  const CertificateAndServerSelectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color white = AFTheme.of(context).colors.primaryWhite;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.screenStatus
            .whenOrNull(error: (e) => _showLoginErrorOverlay(context, e));
      },
      builder: (context, authState) {
        return BlocBuilder<SelectServerBloc, SelectServerState>(
          builder: (context, stateSelectServer) {
            return BlocConsumer<CertificatesHandleBloc,
                CertificatesHandleState>(
              listener: (context, certificateState) {
                if (GoRouter.of(context).location ==
                        RoutePath.serverCertScreen &&
                    !certificateState.selectDefaultCertificateStatus
                        .isLoading() &&
                    certificateState.defaultCertificate == null) {
                  context.go(RoutePath.certificateWarningAndroid);
                }
              },
              builder: (context, certificateState) {
                return ScreenWithLoader(
                  loading: authState.screenStatus.isLoading() ||
                      certificateState.isLoading,
                  child: Scaffold(
                    backgroundColor: white,
                    appBar: AFTopSectionBar.section(
                      themeComponent: AFThemeComponent.medium,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(Spacing.space4),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 80),
                        physics: const ScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTitleSubtitleBox(
                              title: context.localizations.app_title,
                              titleSize: AFTitleSize.xl,
                            ),
                            const SizedBox(
                              height: Spacing.space2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.space3,
                                horizontal: Spacing.space2,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AFTitle(
                                      brightness: AFThemeBrightness.light,
                                      title:
                                          context.localizations.general_server,
                                      size: AFTitleSize.xs,
                                    ),
                                  ),
                                  Flexible(
                                    child: ClearButton(
                                      expanded: false,
                                      text:
                                          context.localizations.general_modify,
                                      size: AFButtonSize.m,
                                      onTap: () => context.go(
                                        RoutePath.changeServerInCertServer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: Spacing.space2,
                            ),
                            if (stateSelectServer.selectedServerFinal !=
                                null) ...[
                              ServerCard(
                                server: stateSelectServer.selectedServerFinal ??
                                    stateSelectServer.preSelectedServer,
                                isSelected: false,
                                selectedByDefaultMark: true,
                              ),
                            ],
                            const SizedBox(
                              height: Spacing.space6,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.space2,
                                horizontal: Spacing.space2,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: AFTitle(
                                          brightness: AFThemeBrightness.light,
                                          title: context.localizations
                                              .general_certificate,
                                          size: AFTitleSize.xs,
                                        ),
                                      ),
                                      Flexible(
                                        child: ClearButton(
                                          text: certificateState
                                                      .defaultCertificate ==
                                                  null
                                              ? context
                                                  .localizations.general_select
                                              : context
                                                  .localizations.general_modify,
                                          size: AFButtonSize.m,
                                          expanded: false,
                                          onTap: () {
                                            if (defaultTargetPlatform ==
                                                TargetPlatform.iOS) {
                                              context.go(
                                                RoutePath.certificatesListIOS,
                                              );
                                            } else {
                                              context
                                                  .read<
                                                      CertificatesHandleBloc>()
                                                  .add(
                                                    CertificatesHandleEvent
                                                        .chooseDefaultCertificate(
                                                      context,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: Spacing.space14,
                                    ),
                                    child: Text(context.localizations
                                        .default_certificate_explain),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: Spacing.space2,
                            ),
                            Builder(builder: (context) {
                              final defaultCertificate =
                                  certificateState.defaultCertificate;

                              return defaultCertificate == null
                                  ? const SizedBox()
                                  : CertificateCard(
                                      certificate: defaultCertificate,
                                      selectedByDefaultMark: true,
                                    );
                            }),
                          ],
                        ),
                      ),
                    ),
                    bottomSheet: Container(
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.space4).add(
                          EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom,
                          ),
                        ),
                        child: Semantics(
                          hint: context.localizations.press_twice_to_open,
                          child: ExpandedButton(
                            enabled:
                                certificateState.defaultCertificate != null,
                            text: context.localizations.general_continue,
                            onTap: () => context.read<AuthBloc>().add(
                                  const AuthEvent
                                      .signInByDefaultCertificateEvent(),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
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

  bool _isThereCurrentModalShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
}
