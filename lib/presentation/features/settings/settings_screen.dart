
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
import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/extensions/string_extension.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/app/utils/clave_utils.dart';
import 'package:portafirmas_app/app/utils/logout.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/presentation/features/app_version/bloc/app_version_bloc.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/model/profile_model_helper.dart';
import 'package:portafirmas_app/presentation/features/settings/utils/language_list.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/customized_user_header.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/profile_template_section.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthorizationScreenBloc authorizationBloc =
        context.read<AuthorizationScreenBloc>();
    CertificatesHandleBloc certificateBloc =
        context.read<CertificatesHandleBloc>();
    CertificateEntity? certificate = certificateBloc.state.defaultCertificate;
    String claveId = context.read<AuthBloc>().state.userAuthStatus.toString();

    bool loggedInWithClave =
        context.read<AuthBloc>().state.userAuthStatus.isLoggedInWithClave();

    return Scaffold(
      appBar: AFTopSectionBar.section(
        themeComponent: AFThemeComponent.medium,
        title: context.localizations.profile_text,
        backButtonOverride: AFTopBarActionIcon(
          iconPath: Assets.iconX,
          semanticsLabel: context.localizations.general_back,
          onTap: () => context.go(RoutePath.requestsScreen),
        ),
      ),
      body: Container(
        color: AFTheme.of(context).colors.primaryWhite,
        child: Padding(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AFTheme.of(context).colors.primary200,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AFHeaderProcessCustomized(
                      title: loggedInWithClave
                          ? IdentificationClaveUtils.getDni(claveId)
                          : certificate?.holderName.getUsername() ?? '',
                      caption: loggedInWithClave
                          ? ''
                          : defaultTargetPlatform == TargetPlatform.iOS &&
                                  certificate?.alias == null
                              ? certificate?.holderName.toString() ?? ''
                              : certificate != null
                                  ? certificate.alias.toString()
                                  : '',
                      themeComponent: AFThemeComponent.light,
                      iconAsset: Assets.iconUserCircle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ProfileTemplateSection(
                  headerText: context
                      .localizations.settings_screen_configuration_title,
                  contentList: getConfigurationList(
                    context,
                    authorizationBloc.state.listOfAuthorizations
                        .where((l) =>
                            l.state?.toLowerCase() ==
                                StatusAuthorization.pendingStatus &&
                            l.sended != true)
                        .toList(),
                    context.read<ProfileBloc>().state,
                  ),
                ),
                ProfileTemplateSection(
                  headerText: context.localizations.help_text,
                  contentList: getHelpList(context),
                ),
                ProfileTemplateSection(
                  headerText:
                      context.localizations.settings_screen_information_title,
                  contentList: getGeneralInformationList(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        child: SvgPicture.asset(Assets.logoPlanUE),
                      ),
                      const SizedBox(height: 10),
                      ExpandedButton(
                        text: context.localizations.logout_text,
                        isTertiary: true,
                        size: AFButtonSize.l,
                        onTap: () => context.logout(deleteLastAuthMethod: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<ProfileModelHelper> getConfigurationList(
    BuildContext context,
    listOfAuthorizations,
    ProfileState profileState,
  ) =>
      [
        if (profileState.profiles.isNotEmpty)
          ProfileModelHelper(
            text: context.localizations.profiles_text,
            onTap: () => context.go(RoutePath.profileScreen),
            leftIcon: Assets.iconUsers,
            rightIcon: Assets.iconChevronRight,
          ),
        if (!profileState.isProxyVersionUnder25()) ...[
          ProfileModelHelper(
            text: context.localizations.settings_screen_validators_menu,
            onTap: () => context.go(RoutePath.validationScreen),
            leftIcon: Assets.iconValidadores,
            rightIcon: Assets.iconChevronRight,
          ),
          ProfileModelHelper(
            text: context.localizations.settings_screen_authorizations_menu,
            onTap: () => context.go(RoutePath.authorizationScreen),
            leftIcon: Assets.iconAutorizados,
            rightIcon: Assets.iconChevronRight,
            label: listOfAuthorizations.isNotEmpty
                ? AFLabel.error(
                    themeComponent: AFThemeComponent.dark,
                    text: listOfAuthorizations.length.toString(),
                  )
                : null,
          ),
        ],
        ProfileModelHelper(
          text: context.localizations.language_text,
          onTap: () => context.go(RoutePath.languageScreen),
          leftIcon: Assets.iconFlag,
          rightIcon: Assets.iconChevronRight,
          label: AFLabel.info(
            text: LanguageExtension.fromLocale(
              Localizations.localeOf(context).languageCode,
            ).languageCode().toUpperCase(),
          ),
        ),
        ProfileModelHelper(
          onTap: () => DoNothingAction(),
          leftIcon: Assets.iconBell,
          isPush: true,
          text: context.localizations.push_notifications_text,
        ),
      ];

  List<ProfileModelHelper> getHelpList(BuildContext context) => [
        ProfileModelHelper(
          text: context.localizations.questions_text,
          onTap: () => launchUrlString(
            AppUrls.frequentlyQuestionsLink,
            mode: LaunchMode.externalApplication,
          ),
          leftIcon: Assets.iconHelp,
          rightIcon: Assets.iconExternalLink,
        ),
        ProfileModelHelper(
          text: context.localizations.support_text,
          onTap: () => launchUrlString(
            AppUrls.supportLink,
            mode: LaunchMode.externalApplication,
          ),
          leftIcon: Assets.iconTool,
          rightIcon: Assets.iconExternalLink,
        ),
      ];

  List<ProfileModelHelper> getGeneralInformationList(BuildContext context) => [
        ProfileModelHelper(
          text: context.localizations.policy_text,
          onTap: () async {
            final uri = await AFPrivacyPolicy.getPrivacyPolicyUri();
            launchUrlString(
              uri.toString(),
              mode: LaunchMode.externalApplication,
            );
          },
          leftIcon: Assets.iconLock,
          rightIcon: Assets.iconExternalLink,
        ),
        ProfileModelHelper(
          text: context.localizations.accesibility_text,
          onTap: () => launchUrlString(
            AppUrls.accesibilityLink,
            mode: LaunchMode.externalApplication,
          ),
          leftIcon: Assets.iconAccesibility,
          rightIcon: Assets.iconExternalLink,
        ),
        ProfileModelHelper(
          text: context.localizations.legal_warning_text,
          onTap: () => launchUrlString(
            AppUrls.legalWarningLink,
            mode: LaunchMode.externalApplication,
          ),
          leftIcon: Assets.iconShield,
          rightIcon: Assets.iconExternalLink,
        ),
        ProfileModelHelper(
          text: context.localizations
              .version_text(context.read<AppVersionBloc>().state.getVersion()),
          onTap: () => DoNothingAction(),
          leftIcon: Assets.iconSmartphone,
        ),
      ];
}
