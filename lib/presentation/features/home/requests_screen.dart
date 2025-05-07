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
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/filter_init_data.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/pending_requests_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/rejected_requests_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/signed_requests_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/validator/validated_requests_section.dart';
import 'package:portafirmas_app/presentation/features/push/widgets/notification_handler.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/widget/modal_error_session_expired.dart';

class RequestsScreen extends StatelessWidget {
  final bool isSigner;
  const RequestsScreen({Key? key, required this.isSigner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthorizationScreenBloc authorizationBloc =
        context.read<AuthorizationScreenBloc>();

    return NotificationHandler(
      child: BlocConsumer<RequestsBloc, RequestsState>(
        listener: (context, state) => modalSessionExpired(state, context),
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Builder(
                builder: (context) {
                  return Scaffold(
                    backgroundColor: AFTheme.of(context).colors.primaryWhite,
                    appBar: AFTopHomeAnimatedBar.lateral(
                      appName: AppLiterals.appName,
                      animationType: const AnimationType.lottie(
                        path: Assets.animatedLogoPortafirmas,
                      ),
                      action1: AFTopBarActionIcon(
                        iconPath: Assets.iconRefresh,
                        semanticsLabel:
                            context.localizations.error_update_button,
                        onTap: () => context.read<RequestsBloc>().add(
                              const RequestsEvent.reloadRequests(
                                requestStatus: null,
                              ),
                            ),
                      ),
                      action2: AFTopBarActionIcon(
                        semanticsLabel: context.localizations.filters_title,
                        iconPath: Assets.iconFilter,
                        onTap: () => context.go(
                          RoutePath.filtersScreen,
                          extra: FilterInitData(
                            requestStatus: state.getTabRequestStatus(
                              DefaultTabController.of(context).index,
                            ),
                            initFilter: state.getInitFilter(
                              DefaultTabController.of(context).index,
                            ),
                            isValidatorProfile: !isSigner,
                          ),
                        ),
                        isSecondary: state.hasFilterActive(
                              state.getTabRequestStatus(
                                DefaultTabController.of(context).index,
                              ),
                            ) &&
                            state.requestCountIsNotEmpty,
                      ),
                      action3: AFTopBarActionIcon(
                        semanticsLabel: context.localizations.profile_text,
                        iconPath: _getIconByUserRol(),
                        notificationCount:
                            _showIconCount(authorizationBloc.state) ? 1 : null,
                        onTap: () => context.go(RoutePath.settingsScreen),
                      ),
                      themeComponent: AFThemeComponent.medium,
                      bottom: AFTabs(
                        isScrollable: true,
                        brightness: AFThemeBrightness.light,
                        tabs: isSigner
                            ? [
                                AFTab(
                                  text: context.localizations.pending_tab_text,
                                ),
                                AFTab(
                                  text: context.localizations.signed_tab_text,
                                ),
                                AFTab(
                                  text: context.localizations.rejected_tab_text,
                                ),
                              ]
                            : [
                                AFTab(
                                  text: context.localizations.pending_tab_text,
                                ),
                                AFTab(
                                  text:
                                      context.localizations.validated_tab_text,
                                ),
                                AFTab(
                                  text: context.localizations.rejected_tab_text,
                                ),
                              ],
                      ),
                    ),
                    body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: isSigner
                          ? const [
                              PendingRequestsSection(
                                isSigner: true,
                              ),
                              SignedRequestsSection(),
                              RejectedRequestsSection(
                                isSigner: true,
                              ),
                            ]
                          : const [
                              PendingRequestsSection(
                                isSigner: false,
                              ),
                              ValidatedRequestsSection(),
                              RejectedRequestsSection(
                                isSigner: false,
                              ),
                            ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void modalSessionExpired(RequestsState state, BuildContext context) {
    if (state.pendingRequestsStatus.screenStatus.isSessionExpiredError() ||
        state.signedRequestsStatus.screenStatus.isSessionExpiredError() ||
        state.rejectedRequestsStatus.screenStatus.isSessionExpiredError() ||
        state.validatedRequestsStatus.screenStatus.isSessionExpiredError()) {
      ModalErrorSessionExpired.modalSessionExpired(context);
    }
  }

  String _getIconByUserRol() {
    return isSigner ? Assets.iconUser : Assets.iconUserCheck;
  }

  bool _showIconCount(AuthorizationScreenState state) {
    return state.pendingAuthorizations.isNotEmpty;
  }
}
