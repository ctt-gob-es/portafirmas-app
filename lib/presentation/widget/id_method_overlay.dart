
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
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/utils/phone_data.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IdMethodOverlay extends StatelessWidget {
  final bool isClaveRegister;
  final Function() onTapHelp;
  const IdMethodOverlay({
    super.key,
    required this.isClaveRegister,
    required this.onTapHelp,
  });

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      overrideIconColor: AFTheme.of(context).colors.a2,
      description: isClaveRegister
          ? null
          : context.localizations.choose_id_overlay_clave_sub,
      mainButtonFunction: () => DoNothingAction(),
      iconPath: Assets.iconClave,
      header: isClaveRegister
          ? context.localizations.choose_id_register
          : context.localizations.general_need_help,
      moreChildrens: isClaveRegister
          ? [
              ExpandedButton(
                text: context.localizations.choose_id_overlay_in_person,
                isTertiary: true,
                onTap: () => launchUrlString(
                  AppUrls.inPersonLink,
                  mode: LaunchMode.externalApplication,
                ),
                iconRight: Assets.iconExternalLink,
              ),
              const SizedBox(
                height: Spacing.space3,
              ),
              ClearButton(
                text: context.localizations.choose_id_overlay_youtube,
                onTap: () => launchUrlString(
                  AppUrls.youtubeChannelLink,
                  mode: LaunchMode.externalApplication,
                ),
              ),
              const SizedBox(
                height: Spacing.space3,
              ),
              SafeArea(
                top: false,
                child: ClearButton(
                  text: context.localizations.general_need_help,
                  onTap: onTapHelp,
                ),
              ),
            ]
          : [
              ExpandedButton(
                text: context.localizations.general_clave_portal,
                isTertiary: true,
                size: AFButtonSize.l,
                onTap: () => launchUrlString(
                  AppUrls.clavePortal,
                  mode: LaunchMode.externalApplication,
                ),
                iconRight: Assets.iconExternalLink,
              ),
              const SizedBox(
                height: Spacing.space3,
              ),
              ExpandedButton(
                text: context.localizations.general_call_060,
                isTertiary: true,
                onTap: () => makePhoneCall('060'),
              ),
              const SizedBox(
                height: Spacing.space3,
              ),
              SafeArea(
                top: false,
                child: ExpandedButton(
                  text: context.localizations.general_contact_form,
                  isTertiary: true,
                  onTap: () => launchUrlString(
                    AppUrls.contactFormUrl,
                    mode: LaunchMode.externalApplication,
                  ),
                  iconRight: Assets.iconExternalLink,
                ),
              ),
            ],
      isReverse: false,
    );
  }
}
