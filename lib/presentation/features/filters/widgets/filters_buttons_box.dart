
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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

class FiltersButtonsBox extends StatelessWidget {
  final Function() onTapClear;
  final Function() onTapApply;
  const FiltersButtonsBox({
    Key? key,
    required this.onTapClear,
    required this.onTapApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: Spacing.space3,
        ),
        ClearButton(
          text: context.localizations.filters_clear_filters_button,
          onTap: onTapClear,
          size: AFButtonSize.m,
        ),
        const SizedBox(
          height: Spacing.space6,
        ),
        SafeArea(
          top: false,
          child: ExpandedButton(
            size: AFButtonSize.l,
            text: context.localizations.filters_apply_filters_button,
            onTap: onTapApply,
          ),
        ),
      ],
    );
  }
}
