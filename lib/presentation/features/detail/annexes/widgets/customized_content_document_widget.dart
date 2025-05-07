
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
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/theme/fonts.dart';

class CustomizedContentDocumentSimple extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String? subtitle;
  final String semanticTitle;
  final String semanticSubtitle;
  final String icon;

  const CustomizedContentDocumentSimple({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.semanticTitle,
    required this.semanticSubtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AFTheme.of(context).colors.primaryWhite,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      Assets.iconFileText,
                      width: 24,
                      height: 24,
                      excludeFromSemantics: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          semanticsLabel: semanticTitle,
                          style: AFTheme.of(context)
                              .typoOnLight
                              .heading6
                              .copyWith(
                                color: AFTheme.of(context).colors.primaryBlack,
                                fontFamily: AppFonts.fontFamily,
                              ),
                        ),
                        Text(
                          subtitle ?? '',
                          semanticsLabel: semanticSubtitle,
                          style:
                              AFTheme.of(context).typoOnLight.bodySm.copyWith(
                                    color: AFTheme.of(context).colors.neutral70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    excludeFromSemantics: true,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const AFDivider.horizontal(),
            ],
          ),
        ),
      ),
    );
  }
}
