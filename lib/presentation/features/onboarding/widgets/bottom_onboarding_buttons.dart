
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
import 'package:app_factory_ui/buttons/af_button/enums/button_size.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

class BottomOnBoardingButtons extends StatelessWidget {
  final Function() onTapSkip;
  final Function() onTapNext;
  final String nextBtnText;
  final bool isLastPage;
  const BottomOnBoardingButtons({
    Key? key,
    required this.onTapSkip,
    required this.onTapNext,
    required this.nextBtnText,
    required this.isLastPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.space4,
        right: Spacing.space4,
        top: Spacing.space1,
        bottom: Spacing.space10,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: Spacing.space3,
            ),
            isLastPage
                ? const SizedBox.shrink()
                : ClearButton(
                    text: context.localizations.skip_msg,
                    onTap: () => onTapSkip(),
                    size: AFButtonSize.l,
                    isaLink: false,
                  ),
            const SizedBox(
              height: Spacing.space2,
            ),
            SafeArea(
              top: false,
              child: ExpandedButton(
                size: AFButtonSize.l,
                text: nextBtnText,
                onTap: () => onTapNext(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
