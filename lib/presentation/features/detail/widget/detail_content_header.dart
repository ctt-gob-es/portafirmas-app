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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/theme/fonts.dart';

class AFCustomContentHeader extends StatelessWidget {
  final AFThemeBrightness brightness;
  final String title;
  final String? semanticTitle;
  final AFLabel? label;
  final bool showLine;
  final bool isFixed;
  final SvgPicture? rightIcon;
  final Function()? onTap;

  const AFCustomContentHeader({
    Key? key,
    required this.brightness,
    required this.title,
    this.semanticTitle,
    this.label,
    this.showLine = false,
    this.isFixed = true,
    this.rightIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        constraints:
            const BoxConstraints(minHeight: 56, maxHeight: double.infinity),
        decoration: BoxDecoration(
          border: showLine
              ? Border(
                  bottom: BorderSide(
                    color: AFTheme.of(context).colors.neutral6,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                button: rightIcon != null ? true : false,
                value: rightIcon != null
                    ? context.localizations.press_twice_to_open
                    : '',
                child: Text(
                  title,
                  style: AFTheme.of(context).typoOnDark.titlesSmBold.copyWith(
                        color: AFTheme.of(context).colors.primaryBlack,
                        fontFamily: AppFonts.fontFamilyHeadings,
                      ),
                ),
              ),
            ),
            label ?? const SizedBox.shrink(),
            rightIcon ?? const SizedBox.shrink(),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
