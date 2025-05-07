
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/forms/af_input/af_text_inbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class RejectPetitionModal extends StatefulWidget {
  final List<String> requestIds;
  const RejectPetitionModal({super.key, required this.requestIds});

  @override
  State<RejectPetitionModal> createState() => _RejectPetitionModalState();
}

class _RejectPetitionModalState extends State<RejectPetitionModal> {
  String _reason = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ModalTemplate(
        isReverse: false,
        description: widget.requestIds.length == 1
            ? context.localizations.request_reject_module_text_simple
            : context.localizations
                .request_reject_module_text(widget.requestIds.length),
        mainButtonText: context.localizations.generic_button_reject,
        mainButtonFunction: () {
          context.read<SignBloc>().add(SignEvent.revokeRequests(
                requestIds: widget.requestIds,
                reason: _reason,
              ));

          context.pop();
        },
        secondaryButtonText: context.localizations.general_cancel,
        secondaryButtonFunction: () => context.pop(),
        iconPath: Assets.iconCheckCircle,
        header: context.localizations.request_reject_module_title,
        moreChildrens: [
          AFTextInbox(
            labelText: context.localizations.detail_reject_module_input_label,
            hintText: context.localizations.detail_reject_module_input_comment,
            onChanged: (p0) => _reason = p0,
          ),
        ],
      ),
    );
  }
}
