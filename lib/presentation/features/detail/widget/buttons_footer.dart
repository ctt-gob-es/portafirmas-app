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
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificates_handle_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_type_extension.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_methods.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_modals.dart';

class ButtonsFooter extends StatelessWidget {
  final RequestEntity request;

  const ButtonsFooter({
    super.key,
    required this.request,
  });

  @override
  Widget build(context) {
    final CertificateEntity? cert =
        context.read<CertificatesHandleBloc>().state.defaultCertificate;
    final String? certName = cert?.alias ?? cert?.holderName;

    return BlocConsumer<SignBloc, SignState>(
      listener: (context, state) =>
          SignMethods.signListener(context, state, true),
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 150,
              maxWidth: 164,
              maxHeight: 48,
            ),
            child: context.read<ProfileBloc>().state.selectedProfile !=
                    null //is validator profile
                ? state.isLoading(ActionType.validate)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AFButton.secondary(
                        enabled: !state.isLoadingAny(),
                        sizeButton: AFButtonSize.m,
                        onPressed: () {
                          return SignModals.showModalValidate(
                            context,
                            [request.id],
                          );
                        },
                        text: context.localizations.generic_button_validate,
                      )
                //is signer profile
                : state.isLoading(ActionType.signVb)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AFButton.secondary(
                        sizeButton: AFButtonSize.m,
                        onPressed: () {
                          return SignModals.showModalSign(
                            context: context,
                            signReqs:
                                request.type.isSignature() ? [request] : [],
                            approvalReqs:
                                request.type.isApproval() ? [request] : [],
                            description:
                                '${context.localizations.sign_validate_subtitle_simple}${certName != null ? context.localizations.sign_validate_cert_name(certName) : context.localizations.sign_validate_cloud_certificate}',
                          );
                        },
                        text: context.localizations.generic_button_sign,
                        semanticsLabel: context.localizations.sign_approve_text,
                      ),
          ),
          const SizedBox(
            width: 10,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 150,
              maxWidth: 164,
              maxHeight: 48,
            ),
            child: AFButton.terciaryPrimary(
              sizeButton: AFButtonSize.m,
              onPressed: () =>
                  SignModals.showModalReject(context, [request.id]),
              text: context.localizations.generic_button_reject,
            ),
          ),
        ],
      ),
    );
  }
}
