
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
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/widgets/authorization_received_section.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/widgets/authorization_sended_section.dart';

class AuthorizationsScreen extends StatelessWidget {
  const AuthorizationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int tabs = 2;

    return Scaffold(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      appBar: AFTopSectionBar.section(
        themeComponent: AFThemeComponent.medium,
        title: context.localizations.authorization_text,
        backButtonOverride: AFTopBarActionIcon(
          isSecondary: false,
          semanticsLabel: context.localizations.general_back,
          iconPath: Assets.iconChevronLeft,
          onTap: () => context.pop(),
        ),
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: tabs,
        child: Scaffold(
          appBar: AFTabs(
            brightness: AFThemeBrightness.light,
            tabs: [
              AFTab(
                text: context.localizations.petition_received_plural_text,
              ),
              AFTab(
                text: context.localizations.petition_send_text,
              ),
            ],
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              AuthorizationReceived(),
              AuthorizationSend(),
            ],
          ),
        ),
      ),
    );
  }
}
