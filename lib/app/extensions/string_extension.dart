
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

extension StringExtension on String {
  String capitalized() =>
      substring(0, 1).toUpperCase() + substring(1).toLowerCase();

  List<String> splitName() {
    return split('-').first.trim().split(' ');
  }

  String capitalizeNameByWord() {
    return isEmpty ? '' : this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String getUsername() {
    List<String> splitUsername = splitName();

    String reversedName =
        '${splitUsername.removeLast().capitalizeNameByWord()} ${splitUsername.map((name) => name.capitalizeNameByWord()).join(' ')}';

    return reversedName;
  }
}
