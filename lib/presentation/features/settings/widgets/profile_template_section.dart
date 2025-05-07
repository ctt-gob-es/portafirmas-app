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
import 'package:app_factory_ui/menu/af_menu_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/model/profile_model_helper.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/profile_template_push_notification.dart';

class ProfileTemplateSection extends StatefulWidget {
  final List<ProfileModelHelper> contentList;
  final String? headerText;

  const ProfileTemplateSection({
    super.key,
    required this.contentList,
    this.headerText,
  });

  @override
  State<ProfileTemplateSection> createState() => _ProfileTemplateSectionState();
}

class _ProfileTemplateSectionState extends State<ProfileTemplateSection>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AuthBloc>().state.userAuthStatus.whenOrNull(
        loggedIn: (dni, _) {
          context.read<PushBloc>().add(PushEvent.userPreferences(nif: dni));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.headerText != null)
            Semantics(
              header: true,
              label: widget.headerText,
              excludeSemantics: true,
              child: AFContentHeader(
                brightness: AFThemeBrightness.light,
                title: widget.headerText ?? '',
                showLine: true,
                isFixed: true,
              ),
            ),
          AFMenuList.normal(
            shrinkWrap: true,
            onItemTap: (config) => config.onTap(),
            elements: widget.contentList,
            itemBuilder:
                (context, ProfileModelHelper element, brightness, onTap) {
              return element.rightIcon != null
                  ? AFMenu.normal(
                      semanticsText: element.rightIcon ==
                              'assets/icons/external_link_icon.svg'
                          ? '${context.localizations.external_link} ${element.text}'
                          : element.text,
                      text: element.text,
                      iconAsset: element.leftIcon,
                      rightIconAsset: element.rightIcon,
                      onTap: onTap,
                      label: element.label,
                      information: element.information,
                    )
                  : element.isPush ?? false
                      ? const PushElement()
                      : AFMenuContent(
                          text: element.text,
                          semanticsText: element.text,
                          iconAsset: element.leftIcon,
                          label: element.label,
                          onSwitchChange: element.onSwitchChange,
                          switchValue: element.switchValue,
                          rightChildBuilder: (context) =>
                              element.rightIcon != null
                                  ? SvgPicture.asset(
                                      element.rightIcon ?? '',
                                    )
                                  : const SizedBox.shrink(),
                          onTap: onTap,
                        );
            },
          ),
        ],
      ),
    );
  }
}

class PushElement extends StatefulWidget {
  const PushElement({
    super.key,
  });

  @override
  State<PushElement> createState() => _PushElementState();
}

class _PushElementState extends State<PushElement> {
  @override
  void initState() {
    context.read<AuthBloc>().state.userAuthStatus.whenOrNull(
      loggedIn: (dni, _) {
        context.read<PushBloc>().add(PushEvent.userPreferences(nif: dni));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PushBloc, PushState>(
      builder: (context, state) {
        bool isSwitchSelected = state.maybeWhen(
          waitingNotifications: () => true,
          unMutingNotifications: () => true,
          hasNewNotification: (_, __) => true,
          orElse: () => false,
        );

        return ProfileTemplatePushNotifications(
          leftIcon: Assets.iconBell,
          switchValue: isSwitchSelected,
          onSwitchChange: (value) {
            context.read<AuthBloc>().state.userAuthStatus.whenOrNull(
              loggedIn: (dni, loggedWithClave) {
                const FlutterSecureStorage().write(
                  key: dni,
                  value: value.toString(),
                );
                context.read<PushBloc>().add(
                      value
                          ? const PushEvent.unMuteNotifications()
                          : const PushEvent.muteNotifications(),
                    );
              },
            );
          },
          text: context.localizations.push_notifications_text,
        );
      },
    );
  }
}
