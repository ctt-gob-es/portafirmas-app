
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
import 'package:flutter_svg/svg.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_card.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/multiselection/checkbox_state.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/loading_component.dart';
import 'package:portafirmas_app/app/constants/assets.dart';

class RequestList extends StatelessWidget {
  final Widget header;
  final RequestStatus requestStatus;
  final bool isLoadingMoreItems;
  final List<RequestEntity> requestList;
  final Function() onNeedMoreItems;
  final Function(RequestEntity request) onRequestTap;
  final bool showError;
  final Function() onRetryAfterErrorTap;
  final Function() onRefresh;
  final ScrollController? scrollController;

  const RequestList({
    super.key,
    required this.header,
    required this.isLoadingMoreItems,
    required this.requestList,
    required this.onNeedMoreItems,
    required this.onRequestTap,
    required this.requestStatus,
    required this.showError,
    required this.onRetryAfterErrorTap,
    required this.onRefresh,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (showError) {
      return _ErrorContent(onRetryTap: onRetryAfterErrorTap);
    }

    if (requestList.isEmpty && isLoadingMoreItems) {
      return const Center(
        child: LoadingComponent(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => await onRefresh(),
      child: ListView.builder(
        controller: scrollController,
        itemCount: requestList.length + 1 + (isLoadingMoreItems ? 1 : 0),
        itemBuilder: (context, index) {
          if (requestList.isEmpty) {
            onNeedMoreItems();
          }
          if (index == 0) {
            return header;
          } else if (index == requestList.length + 1) {
            // return loading
            return const Padding(
              padding: EdgeInsets.all(16),
              child: LoadingComponent(),
            );
          } else {
            int realIndex = index - 1;
            final request = requestList.elementAt(realIndex);
            if (realIndex > requestList.length - 3) {
              // Callback need more items in last 3 items
              onNeedMoreItems();
            }

            if (requestStatus != RequestStatus.pending) {
              context.read<MultiSelectionRequestBloc>().add(
                    const MultiSelectionRequestEvent.initialState(),
                  );
            }

            return BlocBuilder<MultiSelectionRequestBloc,
                MultiSelectionRequestState>(
              builder: (context, state) {
                return state.showCheckbox &&
                        requestStatus == RequestStatus.pending
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: MergeSemantics(
                          child: Row(
                            children: [
                              Semantics(
                                label: state.selectedRequests[request] ?? false
                                    ? context.localizations.selected_text
                                    : null,
                                excludeSemantics: true,
                                child: AFCheckboxSquare(
                                  enabled: true,
                                  value:
                                      state.selectedRequests[request] ?? false,
                                  onTap: () => isCheckBoxSelected(
                                    context,
                                    state,
                                    request,
                                  ),
                                ),
                              ),
                              Semantics(
                                label: request.getCardSemantics(
                                  context,
                                  requestStatus,
                                  state.selectedRequests[request] ?? false
                                      ? ''
                                      : context
                                          .localizations.press_twice_to_select,
                                ),
                                excludeSemantics: true,
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 390),
                                  child: RequestCard(
                                    isSelected:
                                        state.selectedRequests[request] ??
                                            false,
                                    onTap: () => isCheckBoxSelected(
                                      context,
                                      state,
                                      request,
                                    ),
                                    requestStatus: requestStatus,
                                    requestData: request,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Semantics(
                          label: request.getCardSemantics(
                            context,
                            requestStatus,
                            context.localizations.press_twice_to_open,
                          ),
                          excludeSemantics: true,
                          child: RequestCard(
                            onTap: () => onRequestTap(request),
                            requestStatus: requestStatus,
                            requestData: request,
                          ),
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final Function() onRetryTap;
  const _ErrorContent({Key? key, required this.onRetryTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(Assets.iconAlertCircle),
            const SizedBox(
              height: 27,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AFTitle(
                brightness: AFThemeBrightness.light,
                size: AFTitleSize.xxl,
                align: AFTitleAlign.center,
                title: context.localizations.general_problem_title,
                subTitle: context.localizations.error_getting_request_explain,
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ExpandedButton(
            onTap: onRetryTap,
            text: context.localizations.general_retry,
          ),
        ),
      ],
    );
  }
}
