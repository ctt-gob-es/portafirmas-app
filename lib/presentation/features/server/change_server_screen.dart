
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/presentation/features/server/widgets/server_card.dart';

import 'package:portafirmas_app/presentation/widget/list_item_selectable.dart';

class ChangeServerScreen extends StatelessWidget {
  final Function() onAddNewServer;
  final Function() onEditSelectedServer;
  final Function() onContinue;
  final Function(ServerEntity server) onSelectServer;

  final bool isFirstTime;

  final int selectedServerIndex;

  final List<ServerEntity> servers;
  final bool isSelectedServerDefault;

  const ChangeServerScreen({
    super.key,
    required this.onAddNewServer,
    required this.onEditSelectedServer,
    required this.onContinue,
    required this.onSelectServer,
    required this.selectedServerIndex,
    required this.servers,
    required this.isSelectedServerDefault,
    required this.isFirstTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListItemSelectableScreen(
      onAddTap: onAddNewServer,
      screenTitle: context.localizations.servers_title,
      screenSubtitle: context.localizations.servers_subtitle,
      itemList: servers,
      itemBuilder: (BuildContext context, ServerEntity server) {
        final isSelected = server.databaseIndex == selectedServerIndex;

        return ServerCard(
          server: server,
          isSelected: isSelected,
          onTap: () => onSelectServer(server),
        );
      },
      secondaryButtonText: context.localizations.servers_edit_servers,
      onSecondaryActionTap: onEditSelectedServer,
      hideSecondaryAction: false,
      mainButtonText: isFirstTime
          ? context.localizations.general_continue
          : context.localizations.general_save,
      onMainActionTap: onContinue,
      guideText: context.localizations.servers_text_guide,
    );
  }
}
