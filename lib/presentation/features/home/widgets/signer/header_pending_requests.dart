
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
import 'package:app_factory_ui/checkbox/af_checkbox_square.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/theme/fonts.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chips_box.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_card.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/multiselection/checkbox_state.dart';

class HeaderPendingRequests extends StatefulWidget {
  final List<RequestEntity> requestExpiresToday;
  final int requestCount;
  final bool hasFilters;
  final bool isValidatorProfile;

  final Function(RequestEntity requestEntity) onTapRequest;
  const HeaderPendingRequests({
    Key? key,
    required this.requestExpiresToday,
    required this.requestCount,
    required this.onTapRequest,
    required this.hasFilters,
    required this.isValidatorProfile,
  }) : super(key: key);

  @override
  State<HeaderPendingRequests> createState() {
    return _HeaderPendingRequestsState();
  }
}

class _HeaderPendingRequestsState extends State<HeaderPendingRequests> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiSelectionRequestBloc, MultiSelectionRequestState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Filters
            const FilterChipsBox(
              requestStatus: RequestStatus.pending,
            ),
            if (widget.requestExpiresToday.isNotEmpty)
              AFAccordionItem.child(
                showDivider: false,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                title: context.localizations.request_list_title_expires_today(
                  widget.requestExpiresToday.length,
                ),
                onTap: () => setState(() {
                  isExpanded = !isExpanded;
                }),
                isExpanded: isExpanded,
                child: Column(
                  children: [
                    for (final request in widget.requestExpiresToday)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: state.showCheckbox &&
                                widget.requestExpiresToday.isNotEmpty
                            ? Row(
                                children: [
                                  AFCheckboxSquare(
                                    enabled: true,
                                    value: state.selectedRequests[request] ??
                                        false,
                                    onTap: () => isCheckBoxSelected(
                                      context,
                                      state,
                                      request,
                                    ),
                                  ),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 390),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: RequestCard(
                                        requestStatus: RequestStatus.pending,
                                        requestData: request,
                                        onTap: () => isCheckBoxSelected(
                                          context,
                                          state,
                                          request,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : RequestCard(
                                requestStatus: RequestStatus.pending,
                                requestData: request,
                                onTap: () => widget.onTapRequest(request),
                              ),
                      ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: 24,
              ),
              alignment: Alignment.centerLeft,
              child: widget.requestCount > 0 && widget.hasFilters
                  ? Text(
                      context.localizations
                          .request_list_title_found(widget.requestCount),
                      style: AFTheme.of(context).typoOnLight.heading6.copyWith(
                            fontFamily: AppFonts.fontFamily,
                            fontSize: 18,
                          ),
                    )
                  : (widget.requestCount > 0
                      ? Text(
                          context.localizations
                              .request_list_title_all(widget.requestCount),
                          style:
                              AFTheme.of(context).typoOnLight.heading6.copyWith(
                                    fontFamily: AppFonts.fontFamily,
                                    fontSize: 18,
                                  ),
                        )
                      : const SizedBox.shrink()),
            ),
          ],
        );
      },
    );
  }
}
