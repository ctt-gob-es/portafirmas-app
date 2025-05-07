
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/theme/colors.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';

class MultiSelectionFAB extends StatelessWidget {
  final bool isScrolled;

  const MultiSelectionFAB({
    super.key,
    required this.isScrolled,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getAppThemeColors().primary;
    final icon = SvgPicture.asset(Assets.iconLayers);

    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35, right: 14),
          child: !isScrolled
              ? FloatingActionButton.extended(
                  onPressed: () => _showCheckbox(context),
                  backgroundColor: bgColor,
                  label: Row(
                    children: [
                      Semantics(
                        excludeSemantics: true,
                        child: icon,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        context.localizations.selection_text,
                        style: AFTheme.defaultTheme.typoOnLight.bodyLg.copyWith(
                          fontSize: 12,
                          color: AppColors.getAppThemeColors().neutral1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              : FloatingActionButton(
                  onPressed: () => _showCheckbox(context),
                  backgroundColor: bgColor,
                  child: Semantics(
                    label: context.localizations.selection_text,
                    excludeSemantics: true,
                    child: icon,
                  ),
                ),
        ),
      ],
    );
  }

  void _showCheckbox(BuildContext context) {
    context.read<MultiSelectionRequestBloc>().add(
          const MultiSelectionRequestEvent.showCheckbox(
            true,
          ),
        );
  }
}
