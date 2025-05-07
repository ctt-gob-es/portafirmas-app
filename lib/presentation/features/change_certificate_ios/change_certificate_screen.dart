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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/widgets/certificate_card.dart';
import 'package:portafirmas_app/presentation/features/change_certificate_ios/change_certificate_bloc/change_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/change_certificate_ios/delete_certificate_success_overlay.dart';
import 'package:portafirmas_app/presentation/widget/list_item_selectable.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

class ChangeCertificateScreen extends StatelessWidget {
  const ChangeCertificateScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCertificateBloc, AddCertificateState>(
      listener: (context, stateAddCertificate) {
        stateAddCertificate.screenStatus.whenOrNull(
          success: () {
            context
                .read<ChangeCertificateBloc>()
                .add(const ChangeCertificateEvent.loadAllCertificates());
            context.go(RoutePath.addNewCertificateSuccess);
          },
          error: (e) => context.go(RoutePath.addNewCertificateError),
        );
      },
      builder: (context, stateAddCertificate) {
        return BlocConsumer<ChangeCertificateBloc, ChangeCertificateState>(
          listener: (context, state) {
            state.certificateChangeDefaultStatus.whenOrNull(success: () {
              context.read<CertificatesHandleBloc>().add(
                    const CertificatesHandleEvent.reloadDefaultCertificate(),
                  );
              context.pop();
            });
            state.certificateDeleteStatus.whenOrNull(
              success: (CertificateEntity certName) {
                context.read<CertificatesHandleBloc>().add(
                      const CertificatesHandleEvent.reloadDefaultCertificate(),
                    );
                _showSuccessDeleteOverlay(
                  context,
                  certName.holderName,
                );
              },
            );
          },
          builder: (context, stateChangeCertificate) {
            return ScreenWithLoader(
              loading: stateAddCertificate.screenStatus.isLoading() ||
                  stateChangeCertificate.certificateListStatus.isLoading() ||
                  stateChangeCertificate.certificateChangeDefaultStatus
                      .isLoading(),
              child: ListItemSelectableScreen<CertificateEntity>(
                onAddTap: () => context.read<AddCertificateBloc>().add(
                      AddCertificateEvent.addCertificate(context: context),
                    ),
                isComplete:
                    stateChangeCertificate.certificateListStatus.isSuccess(),
                screenTitle: context.localizations.certificate_list_title,
                screenSubtitle: context.localizations.certificate_list_subtitle,
                itemList: stateChangeCertificate.certificates,
                emptyWidget: AFNotification.error(
                  type: AFNotificationType.halfTone,
                  title: context.localizations.certificate_empty_title,
                  message: context.localizations.certificate_empty_subtitle,
                ),
                itemBuilder:
                    (BuildContext context, CertificateEntity certificate) {
                  final bool isSelected =
                      stateChangeCertificate.preselectedCertificate == null
                          ? context
                                  .read<CertificatesHandleBloc>()
                                  .state
                                  .defaultCertificate ==
                              certificate
                          : stateChangeCertificate.preselectedCertificate ==
                              certificate;

                  return CertificateCard(
                    certificate: certificate,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<ChangeCertificateBloc>().add(
                            ChangeCertificateEvent.changePreselectedCertificate(
                              certificate,
                            ),
                          );
                    },
                  );
                },
                secondaryButtonText: context.localizations.cert_list_delete,
                onSecondaryActionTap: () => context
                    .read<ChangeCertificateBloc>()
                    .add(const ChangeCertificateEvent
                        .deletePreselectedCertificate()),
                hideSecondaryAction:
                    stateChangeCertificate.preselectedCertificate == null,
                mainButtonText: context.localizations.general_save,
                onMainActionTap: () => context
                    .read<ChangeCertificateBloc>()
                    .add(const ChangeCertificateEvent
                        .setPreselectedCertificateDefault()),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSuccessDeleteOverlay(
    BuildContext context,
    String certName,
  ) async {
    await showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (context) => DeleteCertificateSuccessOverlay(certName: certName),
    ).whenComplete(() {
      if (!context.mounted) return;
      context.read<ChangeCertificateBloc>().add(
            const ChangeCertificateEvent.preselectedCertificateDeletedShow(),
          );
    });
  }
}
