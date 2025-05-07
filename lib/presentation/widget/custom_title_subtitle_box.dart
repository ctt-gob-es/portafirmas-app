
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
import 'package:portafirmas_app/app/constants/spacing.dart';

class CustomTitleSubtitleBox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final AFTitleSize titleSize;
  final bool? centered;

  const CustomTitleSubtitleBox({
    super.key,
    required this.title,
    this.subtitle,
    required this.titleSize,
    this.centered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.space2),
      child: Column(
        crossAxisAlignment: centered == true
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          AFTitle(
            brightness: AFThemeBrightness.light,
            title: title,
            size: titleSize,
            align: centered == true ? AFTitleAlign.center : AFTitleAlign.left,
          ),
          if (subtitle != null) ...[
            const SizedBox(
              height: Spacing.space2,
            ),
            Text(
              subtitle ?? '',
              style: AFTheme.of(context).typoOnLight.bodyMd,
            ),
          ],
        ],
      ),
    );
  }
}
