
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/theme/af_theme_lib.dart';
import 'package:flutter/material.dart';

class CustomizedAFDataCardData extends StatelessWidget {
  final String value;
  final String data;

  const CustomizedAFDataCardData({
    Key? key,
    required this.value,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AFTheme.of(context).colors.disableBlack,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AFTheme.of(context).colors.neutral90,
            ),
          ),
        ],
      ),
    );
  }
}
