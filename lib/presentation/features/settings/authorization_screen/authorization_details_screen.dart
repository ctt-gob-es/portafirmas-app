
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
import 'package:app_factory_ui/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/data_entry.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/model/authorization_status.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

import 'package:portafirmas_app/presentation/widget/server_internal_error_overlay.dart';

class AuthorizationDetailsScreen extends StatelessWidget {
  const AuthorizationDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color white = AFTheme.of(context).colors.primaryWhite;

    return BlocBuilder<AuthorizationScreenBloc, AuthorizationScreenState>(
      builder: (context, state) {
        return state.screenStatus.maybeWhen(
          initial: () {
            context.read<AuthorizationScreenBloc>().add(
                  const AuthorizationScreenEvent.loadAuthorizations(),
                );

            return const SizedBox.shrink();
          },
          loading: () => Scaffold(
            backgroundColor: white,
            body: const Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          error: (error) => Container(
            color: AFTheme.of(context).colors.primary300,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ServerInternalErrorOverlay(),
              ],
            ),
          ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
          success: () {
            AuthorizationStatus status =
                getAuthorizationStatus(state.authorization?.state ?? '');

            return Scaffold(
              backgroundColor: white,
              appBar: AFTopSectionBar.section(
                themeComponent: AFThemeComponent.medium,
                title: context.localizations.generic_detail,
                backButtonOverride: AFTopBarActionIcon(
                  isSecondary: false,
                  semanticsLabel: context.localizations.general_back,
                  iconPath: Assets.iconArrowLeft,
                  onTap: () {
                    context.read<AuthorizationScreenBloc>().add(
                          const AuthorizationScreenEvent.loadAuthorizations(),
                        );
                    context.pop();
                  },
                ),
              ),
              body: Container(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AFTitle(
                        brightness: AFThemeBrightness.light,
                        title: state.authorization?.sended != false
                            ? state.authorization?.authUser.authUsername ?? ''
                            : state.authorization?.user?.username ?? '',
                        subTitle: state.authorization?.sended != false
                            ? context.localizations
                                .authorization_details_screen_send_subtitle
                            : context.localizations
                                .authorization_details_screen_received_subtitle,
                        size: AFTitleSize.l,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      AFTitle(
                        brightness: AFThemeBrightness.light,
                        title: context.localizations.petition_information,
                        size: AFTitleSize.s,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const AFDivider.horizontal(
                        size: AFDividerSize.s,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            DataCardEntry(
                              section: context
                                  .localizations.authorization_state_text,
                              data: status == AuthorizationStatus.accepted
                                  ? context.localizations.active_text
                                  : status == AuthorizationStatus.pending
                                      ? context.localizations.pending_text
                                      : context.localizations.revoked_text,
                            ),
                            if (state.authorization?.sended == false &&
                                (status == AuthorizationStatus.accepted ||
                                    status == AuthorizationStatus.revoked))
                              DataCardEntry(
                                section: context.localizations
                                    .authorization_received_type_text,
                                data: context
                                    .localizations.petition_received_text,
                              ),
                            DataCardEntry(
                              section: context
                                  .localizations.authorization_type_user_text,
                              data: state.authorization?.type.toCapitalized() ??
                                  '',
                            ),
                            DataCardEntry(
                              section:
                                  context.localizations.date_starting_date_text,
                              data: state.authorization?.startDate ?? '',
                            ),
                            DataCardEntry(
                              section:
                                  context.localizations.date_ending_date_text,
                              data: state.authorization?.revDate ??
                                  context.localizations.date_empty_text,
                            ),
                            DataCardEntry(
                              section: context.localizations.observation_text,
                              data: state
                                      .authorization?.observations?.observations
                                      .toString() ??
                                  '',
                            ),
                          ],
                        ),
                      ),
                      ifAuthorizationAcceptedOrPendingSender(status, state)
                          ? state.authorization?.sended != false
                              ? ExpandedButton(
                                  text: context
                                      .localizations.cancel_petition_button,
                                  isTertiary: false,
                                  size: AFButtonSize.l,
                                  onTap: () {
                                    context.read<AuthorizationScreenBloc>().add(
                                          (const AuthorizationScreenEvent
                                              .revokeAuthorization(
                                            AuthorizationStatus.revoked,
                                          )),
                                        );
                                  },
                                )
                              : const SizedBox.shrink()
                          : status == AuthorizationStatus.pending
                              ? Column(
                                  children: [
                                    ExpandedButton(
                                      text: context.localizations.accept_text,
                                      isTertiary: false,
                                      size: AFButtonSize.l,
                                      onTap: () {
                                        context
                                            .read<AuthorizationScreenBloc>()
                                            .add(
                                              (const AuthorizationScreenEvent
                                                  .acceptAuthorization()),
                                            );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ExpandedButton(
                                      text: context.localizations.decline_text,
                                      isTertiary: true,
                                      size: AFButtonSize.l,
                                      onTap: () {
                                        context
                                            .read<AuthorizationScreenBloc>()
                                            .add((const AuthorizationScreenEvent
                                                .revokeAuthorization(
                                              AuthorizationStatus.rejected,
                                            )));
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
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

  bool ifAuthorizationAcceptedOrPendingSender(
    AuthorizationStatus status,
    AuthorizationScreenState state,
  ) {
    return status == AuthorizationStatus.accepted ||
        (status == AuthorizationStatus.pending &&
            state.authorization?.sended != false);
  }
}
