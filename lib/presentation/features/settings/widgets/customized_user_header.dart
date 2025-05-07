
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/theme/af_theme.dart';
import 'package:app_factory_ui/theme/enums/af_component_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/theme/fonts.dart';

class AFHeaderProcessCustomized extends StatelessWidget {
  final AFThemeComponent themeComponent;
  final String title;
  final String caption;
  final String? semanticTitle;
  final String? semanticCaption;
  final String iconAsset;
  final String? semanticButton;
  final EdgeInsetsGeometry? padding;

  const AFHeaderProcessCustomized({
    Key? key,
    required this.themeComponent,
    required this.title,
    this.semanticTitle,
    required this.caption,
    this.semanticCaption,
    required this.iconAsset,
    this.semanticButton,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Container(
        width: double.infinity,
        padding: padding,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                width: 40,
                height: 40,
                iconAsset,
                excludeFromSemantics: true,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: AFTheme.defaultTheme.typoOnLight.bodyLgBold
                            .copyWith(
                          fontSize: 18,
                          fontFamily: AppFonts.fontFamilyHeadings,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        caption,
                        overflow: TextOverflow.ellipsis,
                        style: AFTheme.defaultTheme.typoOnLight.bodyLg
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
