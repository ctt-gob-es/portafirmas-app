
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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class RequiredUpdateScreen extends StatelessWidget {
  final String version;
  const RequiredUpdateScreen({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AFTopHomeBar.lateral(
        logoPath: Assets.logoPortafirmas,
        themeComponent: AFThemeComponent.light,
      ),
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: AFButton.primary(
              sizeButton: AFButtonSize.m,
              text: context.localizations.error_update_button,
              onPressed: () => _openAppStore(context),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(),
          const SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: AFEmpty(
              alignment: AFEmptyAlignment.center,
              iconPath: Assets.iconDownload,
              title: '${context.localizations.error_update_app_title}$version',
              subtitle: context.localizations.error_update_app_subtitle,
            ),
          ),
        ],
      ),
    );
  }

  void _openAppStore(BuildContext context) {
    launchUrl(
      Uri.parse(
        AppUrls.getUrlUpdateApp(
          Theme.of(context).platform == TargetPlatform.android,
        ),
      ),
      mode: LaunchMode.externalApplication,
    );
  }
}
