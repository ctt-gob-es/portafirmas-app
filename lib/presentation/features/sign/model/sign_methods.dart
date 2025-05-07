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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/utils/error_utils.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_request.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_modals.dart';

class SignMethods {
  //Sign listener: listens for signbloc state changes
  static void signListener(
    BuildContext context,
    SignState state,
    bool isDetailScreen,
  ) {
    state.screenStatus.whenOrNull(
      error: (e) {
        if (e is InvalidSignature) {
          SignModals.showErrorInvalidSignature(context);

          return;
        }
        if (e is AnyProblemWithSignature) {
          //  SignModals.showErrorOverlayGenericSignatureProblem(context);
          ErrorUtils.showErrorOverlay(context);
          return;
        } else if (e is DocSignatureFailed) {
          SignModals.showErrorSignatureModal(context);

          return;
        }

        switch (state.action) {
          case ActionType.revoke:
            SignModals.showErrorOverlay(
              context,
              state.screenStatus.isTimeExpired()
                  ? state.isSingleRequest ?? false
                      ? context.localizations.error_message_timeExpired_request
                      : context.localizations.error_message_timeExpired_requests
                  : state.isSingleRequest ?? false
                      ? context.localizations.revoke_request_failed
                      : context.localizations.revoke_requests_failed,
              state.screenStatus.isTimeExpired() ? true : false,
            );
            break;
          case ActionType.signVb:
            if (state.successfulSignaturesAndApprovals() > 0) {
              SignModals.showErrorOverlay(
                context,
                '${context.localizations.sign_validate_requests_signed_reqs(state.successfulSignatures(), state.successfulApprovals())}${context.localizations.sign_validate_requests_not_signed_reqs(state.failedSignatures(), state.failedApprovals())}',
                true,
              );
            } else if (state.screenStatus.isTimeExpired()) {
              SignModals.showErrorOverlay(
                context,
                context.localizations.error_message_timeExpired_requests,
                true,
              );
            } else {
              SignModals.showErrorSignatureModal(context);

              return;
            }
            break;
          case ActionType.validate:
            SignModals.showErrorOverlay(
              context,
              state.screenStatus.isTimeExpired()
                  ? state.isSingleRequest ?? false
                      ? context.localizations.error_message_timeExpired_request
                      : context.localizations.error_message_timeExpired_requests
                  : state.isSingleRequest ?? false
                      ? context.localizations.validate_request_failed
                      : context.localizations.validate_requests_failed,
              state.screenStatus.isTimeExpired() ? true : false,
            );
            break;
          case null:
            break;
        }
      },
      success: () {
        switch (state.action) {
          case ActionType.revoke:
            _loadRequestsAndShowModalEndReject(
              context,
              isDetailScreen,
              state.rejectedReqsLength ?? 0,
            );
            break;
          case ActionType.signVb:
            _signOrShowSuccessMsg(context, isDetailScreen);
            break;
          case ActionType.validate:
            SignModals.showModalEndValidate(
              context,
              state.isSingleRequest ?? true,
              state.validatedReqsLength ?? 0,
              isDetailScreen,
            );
            break;
          case null:
            break;
        }
      },
    );
  }

  static void finishProcess(BuildContext context, bool isDetailScreen) {
    if (isDetailScreen) {
      context.read<DetailRequestBloc>().add(
            const DetailRequestEvent.footerVisibility(),
          );
    } else {
      _exitMultiSelection(context);
      context.read<RequestsBloc>().add(const RequestsEvent.reloadRequests(
            requestStatus: RequestStatus.pending,
          ));
    }
  }

  static void _loadRequestsAndShowModalEndReject(
    BuildContext context,
    bool isDetailScreen,
    int rejectedReqs,
  ) {
    finishProcess(context, isDetailScreen);
    SignModals.showModalEndReject(context, rejectedReqs);
  }

  static void _signOrShowSuccessMsg(
    BuildContext context,
    bool isDetailScreen,
  ) async {
    final signBloc = context.read<SignBloc>();
    if (signBloc.state.signUrl != null) {
      //Sign with clave
      final result = await context.push(
        isDetailScreen
            ? RoutePath.detailSignWithClave
            : RoutePath.requestsSignWithClave,
        extra: signBloc.state.signUrl,
      );
      if (result != null) {
        //Success signing with clave
        result == true
            ? signBloc.add(SignEvent.postSignRequest(
                signedReqs: signBloc.state.preSignedReqsWithClave
                        ?.map((e) => SignedRequest(
                              id: e,
                              status: true,
                              signedDocuments: [],
                            ))
                        .toList() ??
                    [],
                signMethod: const AuthMethod.clave(),
              ))
            //Error signing with clave
            : signBloc.add(const SignEvent.showSigningError());
      }
    } else {
      //Success post-signing requests, show success modal
      _loadRequestsAndShowModalSignEnd(
        context,
        signBloc.state.successfulSignatures(),
        signBloc.state.successfulApprovals(),
        isDetailScreen,
      );
    }
  }

  static void _loadRequestsAndShowModalSignEnd(
    BuildContext context,
    int successfulSignatures,
    int successfulApprovals,
    bool isDetailScreen,
  ) {
    int totalSuccessful = successfulSignatures + successfulApprovals;
    finishProcess(context, isDetailScreen);

    if (totalSuccessful == 0) {
      SignModals.showErrorOverlay(
        context,
        isDetailScreen
            ? context.localizations.sign_validate_request_failed
            : context.localizations.sign_validate_requests_failed,
        false,
      );
    } else {
      SignModals.showModalEndSign(
        context,
        totalSuccessful == 1
            ? context.localizations.detail_sign_module_final_text_simple
            : context.localizations.detail_sign_module_final_text(
                successfulSignatures,
                successfulApprovals,
              ),
      );
    }
  }

  static void _exitMultiSelection(BuildContext context) {
    context.read<MultiSelectionRequestBloc>().add(
          const MultiSelectionRequestEvent.initialState(),
        );
  }
}
