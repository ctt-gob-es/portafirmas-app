/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_methods.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_modal_template.dart';
import 'package:portafirmas_app/presentation/features/sign/widgets/reject_petition_modal.dart';

class SignModals {
  //Validation modals
  static void showModalValidate(BuildContext context, List<String> requestIds) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: requestIds.length == 1
            ? context.localizations.validate_module_title
            : context.localizations.validate_module_petitions_title,
        subtitle: requestIds.length == 1
            ? context.localizations.validate_module_subtitle
            : context.localizations
                .validate_module_petitions_subtitle(requestIds.length),
        mainBtnText: context.localizations.generic_button_validate,
        mainBtnFunction: () {
          context.pop();
          context.read<SignBloc>().add(
                SignEvent.validateRequests(
                  requestIds: requestIds,
                ),
              );
        },
        iconPath: Assets.iconCircleEdit,
        secondaryBtnText: true,
      ),
    );
  }

  static void showModalEndValidate(
    BuildContext context,
    bool isSingleRequest,
    int requestsLength,
    bool isDetailScreen,
  ) {
    SignMethods.finishProcess(context, isDetailScreen);
    _showBottomModal(
      context,
      SignModalTemplate(
        title: isSingleRequest
            ? context.localizations.validate_module_title_final_step
            : context.localizations.validate_multiple_module_title_final_step,
        subtitle: isSingleRequest
            ? context.localizations.validate_module_subtitle_final_step
            : context.localizations
                .validate_multiple_module_subtitle_final_step(
                requestsLength,
              ),
        mainBtnText: context.localizations.general_understood,
        secondaryBtnText: false,
        iconPath: Assets.iconCheckCircle,
      ),
    );
  }

  static void showErrorSignatureModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => SignModalTemplate(
        title: context.localizations.error_signing_document_title,
        subtitle: context.localizations.error_signing_document_subtitle,
        mainBtnText: context.localizations.general_understood,
        iconPath: Assets.iconUserX,
      ),
    );
  }

  //Rejection modals
  static void showModalReject(BuildContext context, List<String> requestIds) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => RejectPetitionModal(
        requestIds: requestIds,
      ),
    );
  }

  static void showModalEndReject(BuildContext context, int rejectedReqs) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: context.localizations.reject_module_final_title_simple,
        subtitle: rejectedReqs == 1
            ? context.localizations.reject_module_simple_subtitle
            : context.localizations.reject_module_plural_subtitle(rejectedReqs),
        mainBtnText: context.localizations.general_understood,
        secondaryBtnText: false,
        iconPath: Assets.iconCheckCircle,
      ),
    );
  }

  //Signature modals
  static void showModalSign({
    required BuildContext context,
    required List<RequestEntity> signReqs,
    required List<RequestEntity> approvalReqs,
    required String description,
  }) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: context.localizations.sign_validate_title,
        subtitle: description,
        mainBtnText: context.localizations.generic_button_sign,
        mainBtnFunction: () {
          context.pop();
          if (signReqs.isNotEmpty && approvalReqs.isEmpty) {
            //Signs signature requests
            context.read<SignBloc>().add(
                  SignEvent.preSignRequest(
                    signRequests: signReqs,
                  ),
                );
          } else if (signReqs.isEmpty && approvalReqs.isNotEmpty) {
            //Approves approval requests
            context.read<SignBloc>().add(
                  SignEvent.approveReques(
                    requestIds: approvalReqs.map((e) => e.id).toList(),
                  ),
                );
          } else {
            //Approves approval reqs and then signs signature reqs
            context.read<SignBloc>().add(
                  SignEvent.approveReques(
                    requestIds: approvalReqs.map((e) => e.id).toList(),
                    signRequest: signReqs,
                  ),
                );
          }
        },
        iconPath: Assets.iconCircleEdit,
        secondaryBtnText: true,
      ),
    );
  }

  static void showModalEndSign(
    BuildContext context,
    String description,
  ) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: context
            .localizations.generic_message_module_final_step_title_simple,
        subtitle: description,
        mainBtnText: context.localizations.general_understood,
        iconPath: Assets.iconCheckCircle,
      ),
    );
  }

//Error modals

  static void showErrorOverlayGenericSignatureProblem(BuildContext context) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: context.localizations.sign_validate_problem,
        subtitle: context.localizations.error_signing_document_subtitle,
        mainBtnText: context.localizations.general_understood,
        iconPath: Assets.iconUserX,
      ),
    );
  }

  static void showErrorOverlay(
    BuildContext context,
    String description,
    bool? problemTitle,
  ) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: problemTitle == true
            ? context.localizations.sign_validate_problem
            : context.localizations.error_text,
        subtitle: description,
        mainBtnText: context.localizations.general_understood,
        iconPath: Assets.iconCircleInfo,
      ),
    );
  }

  static void showErrorInvalidSignature(
    BuildContext context,
  ) {
    _showBottomModal(
      context,
      SignModalTemplate(
        title: context.localizations.error_message_invalid_signature_title,
        subtitle:
            context.localizations.error_message_invalid_signature_subtitle,
        mainBtnText: context.localizations.general_understood,
        iconPath: Assets.iconUserX,
      ),
    );
  }

  static void _showBottomModal(
    BuildContext context,
    SignModalTemplate modalTemplate,
  ) {
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => modalTemplate,
    );
  }
}
