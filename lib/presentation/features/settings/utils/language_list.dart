
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_list.freezed.dart';

@freezed
class Language with _$Language {
  const factory Language.es() = _Es;

  const factory Language.en() = _En;

  const factory Language.ca() = _Ca;

  const factory Language.ga() = _Ga;

  const factory Language.eu() = _Eu;
}

extension LanguageExtension on Language {
  String title() {
    return when(
      es: () => 'Español',
      en: () => 'English',
      ca: () => 'Catalá',
      ga: () => 'Galego',
      eu: () => 'Euskera',
    );
  }

  String languageCode() {
    return when(
      es: () => 'es',
      en: () => 'en',
      ca: () => 'ca',
      ga: () => 'gl',
      eu: () => 'eu',
    );
  }

  static List<Language> values() => [
        const Language.es(),
        const Language.en(),
        const Language.ca(),
        const Language.ga(),
        const Language.eu(),
      ];

  static Language fromLocale(String locale) {
    switch (locale) {
      case 'es':
        return const Language.es();
      case 'en':
        return const Language.en();
      case 'ca':
        return const Language.ca();
      case 'gl':
        return const Language.ga();
      case 'eu':
        return const Language.eu();
      default:
        return const Language.es();
    }
  }
}
