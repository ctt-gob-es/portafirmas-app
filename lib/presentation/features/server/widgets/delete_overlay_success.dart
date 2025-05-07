
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
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';

import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class DeleteOverlaySuccess extends StatelessWidget {
  final Function() onDeleteTap;
  const DeleteOverlaySuccess({super.key, required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      isReverse: false,
      hideTopBadge: true,
      header: context.localizations.edit_server_delete,
      description: context.localizations.delete_server_text,
      secondaryButtonText: context.localizations.general_cancel,
      secondaryButtonFunction: () => context.pop(),
      mainButtonText: context.localizations.edit_server_delete,
      mainButtonFunction: onDeleteTap,
      iconPath: Assets.iconTrashDelete,
    );
  }
}
