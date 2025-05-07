/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:af_setup/af_setup.dart';
import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:dynatrace/dynatrace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/authentication_screen_envelope.dart';
import 'package:portafirmas_app/presentation/features/initial_access/widgets/access_first_time_buttons.dart';
import 'package:portafirmas_app/presentation/features/initial_access/widgets/access_normal_buttons.dart';
import 'package:portafirmas_app/presentation/features/initial_access/widgets/first_time_overlay.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({Key? key}) : super(key: key);

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  bool get isFirstTime => context.read<SplashBloc>().state.isFirstTime;
  bool get isLogged => context.read<SplashBloc>().state.isLogged;

  @override
  void initState() {
    super.initState();
    //When first access, ask user for dynatrace permissions
    if (isFirstTime) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Dynatrace.checkUserPermission(
          context,
          reportAccessibilityStatsAfterCheck: true,
        );
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showFirstTimeOverlay(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    checkRootStatus(context.localizations.security_alert, context.localizations.security_alert_subtitle, context.localizations.more_information, AppUrls.policyLink, const AFUpdateHeaderIcon(svg: Assets.iconAlert), context);

    return AuthenticationEnvelope(
      builder: (context, state) {
        return ScreenWithLoader(
          loading: state.screenStatus.isLoading(),
          child: Scaffold(
            backgroundColor: AFTheme.of(context).colors.primaryWhite,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        color: AFTheme.of(context).colors.primary200,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: Spacing.space18,
                              left: Spacing.space6,
                              bottom: Spacing.space8,
                              right: Spacing.space6,
                            ),
                            child: RichText(
                              text: TextSpan(
                                spellOut: false,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${context.localizations.app_title},\n',
                                    style: AFTheme
                                        .defaultTheme.typoOnLight.bodyLgBold
                                        .copyWith(fontSize: 28),
                                  ),
                                  TextSpan(
                                    text: context.localizations.login_subtitle,
                                    style: AFTheme
                                        .defaultTheme.typoOnLight.bodyLg
                                        .copyWith(fontSize: 28),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.space4,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            bool smallScreen = false;
                            if (constraints.maxHeight < 220) {
                              smallScreen = true;
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: smallScreen
                                        ? Spacing.space6
                                        : Spacing.space12,
                                    bottom: smallScreen
                                        ? Spacing.space1
                                        : Spacing.space3,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.logoPortafirmas,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: smallScreen
                                        ? Spacing.space1
                                        : Spacing.space4,
                                    bottom: smallScreen
                                        ? Spacing.space1
                                        : Spacing.space4,
                                  ),
                                  child: SvgPicture.asset(
                                    fit: BoxFit.contain,
                                    Assets.logoPlanUE,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: !isLogged
                              ? AccessFirstTimeButtons(
                                  onTapAccess: () =>
                                      context.go(RoutePath.selectServer),
                                  onTapHelp: () => _showHelpOverlay(context),
                                )
                              : AccessNormalButtons(
                                  onTapAccess: () =>
                                      context.read<AuthBloc>().add(
                                            AuthEvent.trySignInWithLastMethod(
                                              context,
                                            ),
                                          ),
                                  onTapHelp: () => _showHelpOverlay(context),
                                  onTapChangeAuthMethod: () =>
                                      context.go(RoutePath.authentication),
                                  onTapManageServers: () =>
                                      context.go(RoutePath.changeServer),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHelpOverlay(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => ModalTemplate(
        isReverse: false,
        description: context.localizations.login_help_sheet_content_1,
        mainButtonText: context.localizations.general_understood,
        mainButtonFunction: () => Navigator.pop(context),
        iconPath: Assets.iconKey,
        titleSemanticsLabel:
            '${context.localizations.external_link} ${context.localizations.login_help_sheet_content_2}',
        header: context.localizations.login_help_sheet_title,
        linkText: context.localizations.login_help_sheet_content_2,
        onTapLinkText: () => launchUrlString(
          AppUrls.supportLink,
          mode: LaunchMode.externalApplication,
        ),
      ),
    );
  }

  void _showFirstTimeOverlay(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => const FirstTimeOverlay(),
    );
  }
}
