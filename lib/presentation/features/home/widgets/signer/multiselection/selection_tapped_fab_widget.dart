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
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/theme/colors.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_methods.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_modals.dart';

class MultiSelectionTapFAB extends StatelessWidget {
  final bool isSigner;
  final List<RequestEntity> requestList;

  const MultiSelectionTapFAB({
    super.key,
    required this.isSigner,
    required this.requestList,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = AppColors.getAppThemeColors().primary;
    Color white = AFTheme.of(context).colors.primaryWhite;
    final CertificateEntity? cert =
        context.read<CertificatesHandleBloc>().state.defaultCertificate;
    final String? certName = cert?.alias ?? cert?.holderName;

    return BlocBuilder<MultiSelectionRequestBloc, MultiSelectionRequestState>(
      builder: (context, selectionState) {
        final boxDecoration = BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: white.withOpacity(1),
              spreadRadius: 15,
              blurRadius: 15,
              offset: const Offset(15, 0),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              white.withOpacity(0),
              white.withOpacity(0.5),
            ],
          ),
        );

        return Container(
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 25),
            child: BlocConsumer<SignBloc, SignState>(
              listener: (context, state) =>
                  SignMethods.signListener(context, state, false),
              builder: (context, signState) {
                final shouldSelectAll =
                    !selectionState.selectedRequests.isNotEmpty ||
                        !selectionState.selectedRequests.containsValue(true);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              selectionState.selectedRequests.length == 1
                                  ? context.localizations
                                      .petition_selection_singular(
                                      selectionState.selectedRequests.length,
                                    )
                                  : context.localizations
                                      .petition_selection_plural(
                                      selectionState.selectedRequests.length,
                                    ),
                              textAlign: TextAlign.center,
                              style: AFTheme.defaultTheme.typoOnLight.bodyLgBold
                                  .copyWith(
                                fontSize: 16,
                                color:
                                    AppColors.getAppThemeColors().primaryBlack,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        !selectionState.isSelected &&
                                selectionState.selectedRequests.isEmpty
                            ? FloatingActionButton.extended(
                                onPressed: () => exitSelection(context),
                                backgroundColor: primaryColor,
                                label: Row(
                                  children: [
                                    Semantics(
                                      excludeSemantics: true,
                                      child: SvgPicture.asset(
                                        Assets.iconInvertedX,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      context.localizations.exit_text,
                                      style: AFTheme
                                          .defaultTheme.typoOnLight.bodyLg
                                          .copyWith(
                                        fontSize: 12,
                                        color: AppColors.getAppThemeColors()
                                            .neutral1,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : signState.isLoadingAny()
                                ? const SizedBox(
                                    width: 50,
                                  )
                                : FloatingActionButton(
                                    onPressed: () => exitSelection(context),
                                    backgroundColor: primaryColor,
                                    child: Semantics(
                                      label: context.localizations.exit_text,
                                      excludeSemantics: true,
                                      child: Semantics(
                                        excludeSemantics: true,
                                        child: SvgPicture.asset(
                                          Assets.iconInvertedX,
                                        ),
                                      ),
                                    ),
                                  ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      label: shouldSelectAll
                          ? context.localizations.select_all_text
                          : context.localizations.undo_all_selection_text,
                      excludeSemantics: false,
                      child: AFButton.link(
                        brightness: AFThemeBrightness.light,
                        semanticsLabel: shouldSelectAll
                            ? context.localizations.select_all_text
                            : context.localizations.undo_all_selection_text,
                        onPressed: () {
                          context.read<MultiSelectionRequestBloc>().add(
                                MultiSelectionRequestEvent.selectAllRequests(
                                  shouldSelectAll,
                                  requestList,
                                ),
                              );
                        },
                        text: shouldSelectAll
                            ? context.localizations.select_all_text
                            : context.localizations.undo_all_selection_text,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 34),
                        SizedBox(
                          height: 48,
                          width: 164,
                          child: isSigner
                              ? signState.isLoading(ActionType.signVb)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : AFButton.secondary(
                                      semanticsLabel: context
                                          .localizations.sign_approve_text,
                                      enabled: selectionState.isButtonEnabled &&
                                          !signState.isLoadingAny(),
                                      onPressed: () => SignModals.showModalSign(
                                        context: context,
                                        signReqs: selectionState
                                            .signatureSelectedReqs(),
                                        approvalReqs: selectionState
                                            .approvalSelectedReqs(),
                                        description: getModalDescription(
                                          context,
                                          selectionState
                                              .approvalSelectedReqs()
                                              .length,
                                          selectionState
                                              .signatureSelectedReqs()
                                              .length,
                                          certName,
                                        ),
                                      ),
                                      text: context
                                          .localizations.generic_button_sign,
                                      sizeButton: AFButtonSize.l,
                                    )
                              : signState.isLoading(ActionType.validate)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : AFButton.secondary(
                                      enabled: selectionState.isButtonEnabled &&
                                          !signState.isLoadingAny(),
                                      sizeButton: AFButtonSize.l,
                                      onPressed: () =>
                                          SignModals.showModalValidate(
                                        context,
                                        selectionState.selectedRequests.keys
                                            .map((e) => e.id)
                                            .toList(),
                                      ),
                                      text: context.localizations
                                          .generic_button_validate,
                                    ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 48,
                          width: 164,
                          child: signState.isLoading(ActionType.revoke)
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : AFButton.terciaryPrimary(
                                  onPressed: () => SignModals.showModalReject(
                                    context,
                                    selectionState.selectedRequests.keys
                                        .map((e) => e.id)
                                        .toList(),
                                  ),
                                  enabled: selectionState.isButtonEnabled &&
                                      !signState.isLoadingAny(),
                                  text: context
                                      .localizations.generic_button_reject,
                                  sizeButton: AFButtonSize.l,
                                ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void exitSelection(BuildContext context) {
    context.read<MultiSelectionRequestBloc>().add(
          const MultiSelectionRequestEvent.initialState(),
        );
  }

  String getModalDescription(
    BuildContext context,
    int approvalReqs,
    int signReqs,
    String? certName,
  ) {
    final String secondText = certName != null
        ? context.localizations.sign_validate_cert_name(certName)
        : context.localizations.sign_validate_cloud_certificate;

    return approvalReqs + signReqs <= 1
        ? '${context.localizations.sign_validate_subtitle_simple} $secondText'
        : '${context.localizations.sign_validate_subtitle_sign_reqs(signReqs)}${(approvalReqs > 0) && (signReqs > 0) ? ' ${context.localizations.y_text} ' : ''}${context.localizations.sign_validate_subtitle_approval_reqs(signReqs, approvalReqs)} $secondText';
  }
}
