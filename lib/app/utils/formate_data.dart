
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:intl/intl.dart';

String formattedDateYearMonthDay(DateTime date, String localeName) {
  return DateFormat('dd/MM/yy', localeName).format(date);
}

String formatDateYMDH(DateTime date, String localeName) {
  return DateFormat('dd/MM/yyyy · HH:mm:ss').format(date);
}

String formatDateYMDHM(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

String capitalizeFirstLetter(String inputString) {
  return inputString.replaceFirst(inputString[0], inputString[0].toUpperCase());
}

String formattedDateDayMonthYear(String date) {
  try {
    DateTime parsedDate = DateFormat('dd/MM/yyyy HH:mm').parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

    return formattedDate;
  } catch (e) {
    return e.toString();
  }
}
