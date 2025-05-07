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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/utils/formate_data.dart';
import 'package:portafirmas_app/domain/models/auth_data_entity.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/model/authorization_status.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/widgets/empty_authorization_section.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/custom_subtitle.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/modal_error_session_expired.dart';

class AuthorizationSend extends StatelessWidget {
  const AuthorizationSend({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationScreenBloc, AuthorizationScreenState>(
      listener: (context, state) {
        if (state.screenStatus.isSessionExpiredError()) {
          ModalErrorSessionExpired.modalSessionExpired(context);
        }
      },
      builder: (context, state) {
        return Container(
          color: AFTheme.of(context).colors.primaryWhite,
          child: state.listOfAuthorizationsSend.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: CustomSubtitleBox(
                        subtitle:
                            context.localizations.petition_send_tab_subtitle,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: state.listOfAuthorizationsSend.length,
                        (context, index) {
                          AuthDataEntity data =
                              state.listOfAuthorizationsSend[index];
                          AuthorizationStatus status = getAuthorizationStatus(
                            data.state ?? '',
                          );

                          return ListTile(
                            title: AFMenu.normal(
                              text: data.authUser.authUsername,
                              information: data.revDate != null
                                  ? context
                                          .localizations.date_ending_date_text +
                                      formattedDateDayMonthYear(
                                        data.revDate.toString(),
                                      )
                                  : context.localizations.date_empty_text,
                              label: status == AuthorizationStatus.revoked
                                  ? AFLabel.error(
                                      themeComponent: AFThemeComponent.medium,
                                      text: context.localizations.inactive_text,
                                    )
                                  : status == AuthorizationStatus.pending
                                      ? AFLabel.warning(
                                          themeComponent:
                                              AFThemeComponent.medium,
                                          text: context
                                              .localizations.pending_text,
                                        )
                                      : AFLabel.success(
                                          themeComponent:
                                              AFThemeComponent.medium,
                                          text:
                                              context.localizations.active_text,
                                        ),
                              onTap: () {
                                context.read<AuthorizationScreenBloc>().add(
                                      AuthorizationScreenEvent
                                          .getSelectedAuthorization(
                                        data,
                                      ),
                                    );

                                context
                                    .go(RoutePath.authorizationDetailsScreen);
                              },
                              rightIconAsset: Assets.iconChevronRight,
                            ),
                          );
                        },
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 34,
                              horizontal: 14,
                            ),
                            child: ExpandedButton(
                              text: context
                                  .localizations.add_new_authorized_button,
                              isTertiary: false,
                              size: AFButtonSize.l,
                              onTap: () =>
                                  context.go(RoutePath.addAuthorizedScreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : EmptyAuthorizationSection(
                  afTitle: AFTitle(
                    brightness: AFThemeBrightness.light,
                    title: context.localizations.petition_send_alert_message,
                    size: AFTitleSize.s,
                    align: AFTitleAlign.center,
                  ),
                  expandedButton: ExpandedButton(
                    text: context.localizations.add_new_authorized_button,
                    isTertiary: false,
                    size: AFButtonSize.l,
                    onTap: () => context.go(RoutePath.addAuthorizedScreen),
                  ),
                  child: SvgPicture.asset(Assets.iconAlertCircle),
                ),
        );
      },
    );
  }
}
