
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portafirmas_app/app/constants/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AFTheme.of(context).colors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(
              flex: 1,
            ),
            Center(child: SvgPicture.asset(Assets.logoSpainGob)),
            const Spacer(
              flex: 1,
            ),
            const Divider(
              color: Colors.white,
              endIndent: 15,
              indent: 15,
            ),
            const Spacer(
              flex: 1,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(Assets.logoUEWhite),
                SvgPicture.asset(Assets.logoPRTRWhite),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            SvgPicture.asset(Assets.logoSpainDigitalWhite),
            const Spacer(
              flex: 2,
            ),
            SvgPicture.asset(Assets.logoPortafirmasWhite),
            const Spacer(
              flex: 10,
            ),
          ],
        ),
      ),
    );
  }
}
