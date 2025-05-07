
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

class AddOverlayError extends StatelessWidget {
  final String serverName;
  final Function() onRetryTap;

  const AddOverlayError({
    Key? key,
    required this.serverName,
    required this.onRetryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      isReverse: false,
      hideTopBadge: true,
      description: context.localizations.add_server_modal_error_sub(serverName),
      mainButtonText: context.localizations.general_try_again,
      mainButtonFunction: () => context.pop(),
      iconPath: Assets.iconUserX,
      // TODO(Team): Check with Figma for correct text
      header: context.localizations.add_server_modal_error_title,
    );
  }
}
