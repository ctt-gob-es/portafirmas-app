/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/theme/colors/af_theme_data_colors.dart';
import 'package:flutter/material.dart';

class AppColors {
  // TODO DELETE
  static Color sectionColorDataEntries = const Color.fromRGBO(24, 54, 78, 0.6);

  // TODO DELETE
  static Color dataColorDataEntries = const Color.fromRGBO(14, 32, 47, 1);

  AppColors._();

  static AFThemeDataColors getAppThemeColors() => AFThemeDataColors(
        primary: const Color(0xFF224D70),
        secondary: const Color(0xFF224D70),
        complementary: const Color(0xFF0E8195),
        neutralBase: const Color(0xFF161616),
        a1: const Color(0xFF54CF8F),
        a2: const Color(0xFFF5852A),
        a3: const Color(0xFF0266B3),
        a4: const Color(0xFF42D7F8),
        a5: const Color(0xFFFFCE00),
        a6: const Color(0xFFFAE47A),
        semanticInfo: const Color(0xFF0057FF),
        semanticInfo100: const Color(0xFFE5EEFF),
        semanticInfo300: const Color(0xFFA8C6FF),
        semanticError: const Color(0xFFCC1C00),
        semanticError100: const Color(0xFFFFE9E5),
        semanticError300: const Color(0xFFFFB6A8),
        semanticSuccess: const Color(0xFF3BC47C),
        semanticSuccess100: const Color(0xFFEBF9F2),
        semanticSuccess300: const Color(0xFFBCEBD4),
        semanticWarning: const Color(0xFFFFA154),
        semanticWarning100: const Color(0xFFFFF1E5),
        semanticWarning300: const Color(0xFFFFD0A8),
        linkDark: const Color(0xFF14BAD7),
        linkVisitedDark: const Color(0xFF7D02DE),
        linkLight: const Color(0xFF0E8196),
        linkVisitedLight: const Color(0xFFA63DF9),
      );
}
