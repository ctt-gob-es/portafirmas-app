
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
import 'package:lottie/lottie.dart';

class ExplainAddCertificatePage extends StatelessWidget {
  final String animation, title, description;

  const ExplainAddCertificatePage({
    super.key,
    required this.animation,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          AFTitle(
            brightness: AFThemeBrightness.light,
            title: title,
            size: AFTitleSize.l,
            align: AFTitleAlign.left,
            subTitle: description,
          ),
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: Lottie.asset(animation),
          ),
        ],
      ),
    );
  }
}
