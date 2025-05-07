
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
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';

class ErrorRequest extends StatelessWidget {
  const ErrorRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      child: SvgPicture.asset(
                        Assets.iconAlertCircle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: AFTitle(
                        brightness: AFThemeBrightness.light,
                        align: AFTitleAlign.center,
                        title: context.localizations.request_send_failed,
                        size: AFTitleSize.xxl,
                        subTitle:
                            context.localizations.request_send_failed_text,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 219,
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Color del borde
                      width: 1.0, // Ancho del borde
                    ), // Radio de la esquina del borde
                  ),
                  child: Text(
                    context.localizations.request_failed_max_time,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16).add(
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          ),
          child: ExpandedButton(
            text: context.localizations.general_retry,
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
