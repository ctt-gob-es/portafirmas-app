
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
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/presentation/widget/custom_title_subtitle_box.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

class CertAddedSuccessScreen extends StatelessWidget {
  const CertAddedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color white = AFTheme.of(context).colors.primaryWhite;

    return Scaffold(
      backgroundColor: white,
      appBar: AFTopSectionBar.action(
        themeComponent: AFThemeComponent.medium,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.space3,
                left: Spacing.space2,
                bottom: Spacing.space6,
              ),
              child: SvgPicture.asset(
                width: 70,
                height: 70,
                Assets.iconSuccessCheck,
                excludeFromSemantics: true,
              ),
            ),
            CustomTitleSubtitleBox(
              title: context.localizations.cert_added_title,
              subtitle: context.localizations.cert_added_subtitle,
              titleSize: AFTitleSize.l,
            ),
            const Spacer(),
            SafeArea(
              top: false,
              child: ExpandedButton(
                text: context.localizations.general_continue,
                onTap: () => context.go(RoutePath.certificatesListIOS),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
