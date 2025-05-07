
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
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';

class NewVersionOverlay extends StatelessWidget {
  final String iconPath;
  final Function() onTapButton;

  const NewVersionOverlay({
    super.key,
    required this.iconPath,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AFOverlay(
        header: AFOverlayHeaderMessage(
          iconPath: iconPath,
          title: context.localizations.error_new_version_title,
          subtitle: context.localizations.error_new_version_subtitle,
        ),
        action: AFOverlayAction(
          buttonAxis: Axis.vertical,
          primaryActionText: context.localizations.error_update_button,
          primaryAction: onTapButton,
          secondaryActionText: context.localizations.skip_text,
          secondaryAction: () {
            //Exit splash screen
            context.read<SplashBloc>().add(
                  const SplashEvent.unSplashInNMilliseconds(1000),
                );
            context.pop();
          },
        ),
      ),
    );
  }
}
