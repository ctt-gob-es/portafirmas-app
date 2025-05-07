
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class SignModalTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final String mainBtnText;
  final String iconPath;
  final Function? mainBtnFunction;
  final bool? secondaryBtnText;

  const SignModalTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mainBtnText,
    required this.iconPath,
    this.mainBtnFunction,
    this.secondaryBtnText = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      isReverse: false,
      hideTopBadge: true,
      header: title,
      description: subtitle,
      mainButtonText: mainBtnText,
      mainButtonFunction: mainBtnFunction ?? () => context.pop(),
      secondaryButtonText: mainBtnFunction != null && secondaryBtnText == true
          ? context.localizations.general_cancel
          : null,
      secondaryButtonFunction:
          mainBtnFunction != null && secondaryBtnText == true
              ? () => context.pop()
              : null,
      iconPath: iconPath,
    );
  }
}
