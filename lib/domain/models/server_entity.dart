
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/extensions/localizations_extensions.dart';

part 'server_entity.freezed.dart';

@freezed
class ServerEntity with _$ServerEntity {
  factory ServerEntity({
    required int databaseIndex,
    required String alias,
    required String url,
    @Default(false) bool isDefault,
    @Default(false) bool isFixed,
    @Default(false) bool isFromEmm,
  }) = _ServerEntity;
}

extension ServerEntityExtension on ServerEntity {
  String getTitle(bool isSelected, BuildContext context) =>
      isDefault ? context.localizations.defaultServerName(this) : alias;

  String? getSubtitle(bool isSelected, BuildContext context) =>
      isDefault ? context.localizations.defaultServerSubtitle(this) : null;

  String getSemantics(bool isSelected, BuildContext context) =>
      '${isSelected ? context.localizations.selected_server : ''}. ${getTitle(isSelected, context)}. ${getSubtitle(isSelected, context)}. ${context.localizations.press_twice_to_select}';
}
