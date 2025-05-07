
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/cards/data_card/af_data_card.dart';
import 'package:app_factory_ui/cards/data_card/content/af_data_card_title.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';

import 'package:portafirmas_app/app/constants/assets.dart';

class ServerCard extends StatelessWidget {
  final ServerEntity server;
  final bool isSelected;

  final bool selectedByDefaultMark;

  final Function()? onTap;
  const ServerCard({
    Key? key,
    required this.server,
    required this.isSelected,
    this.onTap,
    this.selectedByDefaultMark = false,
  }) : super(key: key);

  String get _iconPath {
    if (selectedByDefaultMark) {
      return Assets.iconCheck;
    } else if (isSelected) {
      return Assets.iconRadioButtonOn;
    } else {
      return Assets.iconRadioButtonOff;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: server.getSemantics(isSelected, context),
      excludeSemantics: true,
      child: AFDataCard(
        title: AFDataCardTitle(
          title: server.getTitle(isSelected, context),
          subtitle: server.getSubtitle(isSelected, context),
          iconRightAsset: _iconPath,
        ),
        //Saves currently selected server
        onTap: onTap,
      ),
    );
  }
}
