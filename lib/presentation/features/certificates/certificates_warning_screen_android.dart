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
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/widget/custom_title_subtitle_box.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/screen_with_loader.dart';

class CertificatesWarningScreenAndroid extends StatelessWidget {
  const CertificatesWarningScreenAndroid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCertificateBloc, AddCertificateState>(
      listener: (context, addCertificateState) {
        if (GoRouter.of(context).location ==
            RoutePath.certificateWarningAndroid) {
          addCertificateState.screenStatus
              .whenOrNull(success: () => context.pop());
        }
      },
      builder: (context, addCertificateState) {
        return BlocConsumer<CertificatesHandleBloc, CertificatesHandleState>(
          listener: (context, certificateHandleState) {
            if (GoRouter.of(context).location ==
                    RoutePath.certificateWarningAndroid &&
                certificateHandleState.defaultCertificate != null) {
              context.pop();
            }
          },
          builder: (context, certificateHandleState) {
            return ScreenWithLoader(
              loading: certificateHandleState.isLoading ||
                  addCertificateState.screenStatus.isLoading(),
              child: Scaffold(
                backgroundColor: AFTheme.of(context).colors.primaryWhite,
                appBar: AFTopSectionBar.section(
                  backButtonOverride: AFTopBarActionIcon(
                    iconPath: Assets.iconX,
                    semanticsLabel: context.localizations.general_back,
                    onTap: () => context.pop(),
                  ),
                  themeComponent: AFThemeComponent.medium,
                  actions: [
                    AFTopBarActionIcon(
                      iconPath: Assets.iconPlus,
                      semanticsLabel: context.localizations.add_certificate,
                      onTap: () {
                        context.read<AddCertificateBloc>().add(
                              AddCertificateEvent.addCertificate(
                                context: context,
                              ),
                            );
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: Spacing.space4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomTitleSubtitleBox(
                              title:
                                  context.localizations.certificate_list_title,
                              subtitle: context
                                  .localizations.certificate_not_found_subtitle,
                              titleSize: AFTitleSize.l,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Spacing.space4,
                        ),
                        if (certificateHandleState.attemptsSelectCertificate <=
                            1) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AFNotification.warning(
                              type: AFNotificationType.halfTone,
                              title: context.localizations
                                  .certificate_warning_has_certificates_installed_title,
                              message: context.localizations
                                  .certificate_warning_has_certificates_installed_subtitle,
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AFNotification.error(
                              type: AFNotificationType.halfTone,
                              title: context.localizations
                                  .certificate_error_problems_with_certificates_title,
                              message: context.localizations
                                  .certificate_error_problems_with_certificates_subtitle,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(Spacing.space4).add(
                            EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom,
                            ),
                          ),
                          child: ExpandedButton(
                            text: context.localizations.general_select,
                            onTap: () {
                              context.read<CertificatesHandleBloc>().add(
                                    CertificatesHandleEvent
                                        .chooseDefaultCertificate(
                                      context,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
