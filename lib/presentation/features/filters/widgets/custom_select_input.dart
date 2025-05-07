
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/bloc/bloc/app_filter_bloc.dart';

class CustomSelectInput extends StatelessWidget {
  final String overlayTitle;
  final String labelText;
  final Widget selectionMenu;
  final String? initialValue;
  final bool? isAppFilter;

  const CustomSelectInput({
    Key? key,
    required this.selectionMenu,
    required this.overlayTitle,
    required this.labelText,
    this.initialValue,
    this.isAppFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.space4),
      child: AFDropSelectInput(
        iconOverrideColor: AFTheme.of(context).colors.primary,
        initialValue: initialValue,
        labelText: labelText,
        onTap: () {
          if (isAppFilter != null && isAppFilter == true) {
            //it calls to getAppList only if apps are not loaded
            context
                .read<AppFilterBloc>()
                .add(const AppFilterEvent.getAppList());
          }

          return showModalAFOverlay(
            context: context,
            overlayBuilder: (context) => AFOverlay(
              header: AFOverlayHeaderNormal(
                title: overlayTitle,
                titleSemanticsLabel: overlayTitle,
                hasMediumThemeInCloseButton: true,
              ),
              content: AFOverlayContent(children: [
                selectionMenu,
              ]),
            ),
          );
        },
      ),
    );
  }
}
