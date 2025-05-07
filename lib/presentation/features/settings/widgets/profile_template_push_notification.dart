
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
import 'package:app_factory_ui/switch/af_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';

class ProfileTemplatePushNotifications extends StatelessWidget {
  final String leftIcon;
  final bool switchValue;
  final Function(bool) onSwitchChange;
  final String text;

  const ProfileTemplatePushNotifications({
    Key? key,
    required this.leftIcon,
    required this.switchValue,
    required this.onSwitchChange,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      constraints: const BoxConstraints(minHeight: 56, maxHeight: 60),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.2,
            color: AFTheme.of(context).colors.primary,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            leftIcon,
            excludeFromSemantics: true,
            color: AFTheme.of(context).colors.linkLight,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Semantics(
              excludeSemantics: true,
              child: Text(
                text,
                style: AFTheme.of(context)
                    .typoOnDark
                    .titlesSmBold
                    .copyWith(color: AFTheme.of(context).colors.primaryBlack),
              ),
            ),
          ),
          Semantics(
            label: switchValue
                ? context.localizations.enabled_text
                : context.localizations.disabled_text,
            child: AFSwitch(
              enabled: true,
              semantics: text,
              value: switchValue,
              onChanged: onSwitchChange,
              brightness: AFThemeBrightness.light,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
