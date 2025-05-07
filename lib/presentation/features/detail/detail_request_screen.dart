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
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/theme/colors.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/model/enum_document_type.dart';
import 'package:portafirmas_app/presentation/features/detail/annexes/widgets/document_widget.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/error/error_request_screen.dart';
import 'package:portafirmas_app/presentation/features/detail/model/request_type.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/buttons_footer.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/detail_content_header.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/detail_info_request.dart';
import 'package:portafirmas_app/presentation/features/detail/widget/signed_documents.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_type_extension.dart';
import 'package:portafirmas_app/presentation/widget/modal_error_session_expired.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailRequestScreen extends StatelessWidget {
  final RequestStatus requestStatus;

  const DetailRequestScreen({
    super.key,
    required this.requestStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailRequestBloc, DetailRequestState>(
      listener: (context, state) {
        if (state.screenStatus.isSessionExpiredError()) {
          ModalErrorSessionExpired.modalSessionExpired(context);
        }
      },
      builder: (context, state) {
        RequestEntity? requestContent = state.loadContent;

        return Scaffold(
          backgroundColor: AFTheme.of(context).colors.primaryWhite,
          appBar: AFTopSectionBar.section(
            themeComponent: AFThemeComponent.medium,
            title: context.localizations.generic_detail,
            size: AFTopSectionAppBarSize.normal,
            backButtonOverride: AFTopBarActionIcon(
              iconPath: Assets.iconArrowLeft,
              semanticsLabel: context.localizations.general_back,
              onTap: () => _reloadRequestsAndGoBack(context),
            ),
          ),
          bottomSheet: (state.isFooterActive &&
                      (requestStatus == RequestStatus.pending) &&
                      (requestContent != null)) &&
                  state.screenStatus.isSuccess()
              ? Container(
                  padding: const EdgeInsets.all(Spacing.space4),
                  color: AFTheme.of(context).colors.primaryWhite,
                  child: ButtonsFooter(
                    request: requestContent,
                  ),
                )
              : const SizedBox(
                  height: 10,
                ),
          body: state.screenStatus.maybeWhen(
            success: () => Builder(
              builder: (context) {
                return requestContent != null
                    ? SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(Spacing.space4).add(
                          state.isFooterActive
                              ? const EdgeInsets.only(bottom: 100)
                              : const EdgeInsets.only(bottom: 10),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
                                child: AFTitle(
                                  align: AFTitleAlign.left,
                                  brightness: AFThemeBrightness.light,
                                  title: requestContent.subject,
                                  size: AFTitleSize.l,
                                  subTitle:
                                      '${context.localizations.detail_subtitle}${requestContent.from}',
                                ),
                              ),
                              AFCustomContentHeader(
                                brightness: AFThemeBrightness.light,
                                title: context.localizations.generic_remarks,
                                semanticTitle:
                                    context.localizations.generic_remarks,
                                showLine: false,
                                isFixed: true,
                              ),
                              BodyHtml(requestContent: requestContent),
                              const SizedBox(height: 5),
                              if ((requestStatus == RequestStatus.signed) &&
                                  requestContent.type.isSignature())
                                SignedDocuments(
                                  docsList: requestContent.listDocs ?? [],
                                ),
                              Column(mainAxisSize: MainAxisSize.max, children: [
                                Theme(
                                  data: AFTheme.getTheme(
                                    themeData: AFTheme.defaultTheme.copyWith(
                                      colors: AppColors.getAppThemeColors()
                                          .copyWith(
                                        semanticWarning300:
                                            const Color(0xFFFFF1E5),
                                      ),
                                    ),
                                  ),
                                  child: AFCustomContentHeader(
                                    brightness: AFThemeBrightness.light,
                                    title: context.localizations
                                        .generic_documents_to_sign,
                                    showLine: false,
                                    isFixed: false,
                                    label: requestContent.type.label(context),
                                  ),
                                ),
                                ...requestContent.listDocs?.map(
                                      (doc) => DocumentWidget(
                                        doc: doc,
                                        documentType: DocumentType.doc,
                                      ),
                                    ) ??
                                    [],
                              ]),
                              AFCustomContentHeader(
                                brightness: AFThemeBrightness.light,
                                title:
                                    '${context.localizations.generic_annexes} (${getAnnexesList(requestContent.annexesList ?? []).length})',
                                rightIcon: getAnnexesList(
                                  requestContent.annexesList ?? [],
                                ).isNotEmpty
                                    ? SvgPicture.asset(
                                        Assets.iconChevronRight,
                                        excludeFromSemantics: true,
                                      )
                                    : null,
                                showLine: true,
                                onTap: () => getAnnexesList(
                                  requestContent.annexesList ?? [],
                                ).isNotEmpty
                                    ? context.go(
                                        RoutePath.annexes,
                                        extra: requestStatus,
                                      )
                                    : DoNothingAction(),
                              ),
                              AFCustomContentHeader(
                                brightness: AFThemeBrightness.light,
                                title: context.localizations.generic_addressee,
                                semanticTitle:
                                    context.localizations.generic_addressee,
                                showLine: true,
                                rightIcon: SvgPicture.asset(
                                  Assets.iconChevronRight,
                                  excludeFromSemantics: true,
                                ),
                                onTap: () => context.push(RoutePath.addressee),
                              ),
                              DetailsInfoRequest(
                                date: requestContent.lastModificationDate,
                                expiredDate: requestContent.expirationDate,
                                reference: requestContent.ref ?? '',
                                application: requestContent.application ?? '',
                                requestContent: requestContent,
                                status: requestStatus,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator());
              },
            ),
            error: (error) => const ErrorRequest(),
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  void _reloadRequestsAndGoBack(BuildContext context) {
    //Reload request list
    context
        .read<RequestsBloc>()
        .add(RequestsEvent.reloadRequests(requestStatus: requestStatus));
    context.pop();
  }
}

class BodyHtml extends StatelessWidget {
  const BodyHtml({
    super.key,
    required this.requestContent,
  });

  final RequestEntity requestContent;

  @override
  Widget build(BuildContext context) {
    final String message = requestContent.message ?? '';

    return Html(
      data: _formatMessage(message, context),
      style: {'a': Style(textDecoration: TextDecoration.underline)},
      onLinkTap: (url, _, __) {
        if (url != null) {
          launchUrlString(url, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  String _formatMessage(String text, BuildContext context) {
    final RegExp urlRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    return text.replaceAllMapped(urlRegExp, (match) {
      return '<a href="${match.group(0)}" aria-label=${context.localizations.external_link} ${match.group(0)}> ${match.group(0)}</a>';
    });
  }
}
