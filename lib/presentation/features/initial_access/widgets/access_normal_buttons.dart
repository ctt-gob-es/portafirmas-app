
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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';

import 'package:portafirmas_app/app/constants/spacing.dart';

class AccessNormalButtons extends StatelessWidget {
  final Function() onTapAccess;
  final Function() onTapChangeAuthMethod;
  final Function() onTapManageServers;
  final Function() onTapHelp;
  const AccessNormalButtons({
    super.key,
    required this.onTapAccess,
    required this.onTapHelp,
    required this.onTapChangeAuthMethod,
    required this.onTapManageServers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.space4,
        vertical: Spacing.space1,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AFButton.secondary(
              onPressed: onTapAccess,
              text: context.localizations.login_access_btn,
            ),
          ),
          const SizedBox(height: Spacing.space2),
          SizedBox(
            width: double.infinity,
            child: AFButton.terciaryPrimary(
              onPressed: onTapChangeAuthMethod,
              text: context.localizations.access_button_change_auth,
            ),
          ),
          const SizedBox(height: Spacing.space2),
          SizedBox(
            width: double.infinity,
            child: AFButton.terciaryPrimary(
              onPressed: onTapManageServers,
              text: context.localizations.access_button_server_manage,
            ),
          ),
          const SizedBox(height: Spacing.space2),
          SizedBox(
            width: double.infinity,
            child: AFButton.fantasmaPrimary(
              foregroundColorOverride: AFTheme.of(context).colors.linkLight,
              onPressed: onTapHelp,
              text: context.localizations.general_need_help,
            ),
          ),
        ],
      ),
    );
  }
}
