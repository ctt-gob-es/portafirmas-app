
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/theme/af_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/empty_request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chips_box.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/header_pending_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/multiselection/selection_fab_widget.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/multiselection/selection_tapped_fab_widget.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/switcher_request_list_empty_list.dart';

class PendingRequestsSection extends StatefulWidget {
  final bool isSigner;
  const PendingRequestsSection({Key? key, required this.isSigner})
      : super(key: key);

  @override
  State<PendingRequestsSection> createState() => _PendingRequestsSectionState();
}

class _PendingRequestsSectionState extends State<PendingRequestsSection> {
  final ScrollController scrollController = ScrollController();
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    Future.microtask(() {
      if (!mounted) return;
      context.read<RequestsBloc>()
        ..add(const RequestsEvent.checkFilters(RequestStatus.pending))
        ..add(const RequestsEvent.reloadRequests(
          requestStatus: RequestStatus.pending,
        ));
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestsBloc = context.read<RequestsBloc>();

    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AFTheme.of(context).colors.primaryWhite,
          body: SwitcherRequestListEmptyList(
            totalCount: state.pendingRequestsStatus.requestsCount,
            requestList: RequestList(
              scrollController: scrollController,
              requestStatus: RequestStatus.pending,
              showError: state.pendingRequestsStatus.screenStatus.isError(),
              onRetryAfterErrorTap: () => requestsBloc.add(
                RequestsEvent.loadMorePendingRequests(
                  isSigner: widget.isSigner,
                ),
              ),
              header: HeaderPendingRequests(
                hasFilters: state.hasFilterActive(RequestStatus.pending),
                requestExpiresToday: state.expiresTodayRequests,
                requestCount: state.pendingRequestsStatus.requestsCount ?? 0,
                onTapRequest: (entity) {
                  goDetailRequestPage(context, RequestStatus.pending, entity);
                },
                isValidatorProfile: !widget.isSigner,
              ),
              isLoadingMoreItems:
                  state.pendingRequestsStatus.screenStatus.isLoading(),
              requestList: state.allRequestsExceptExpiresToday,
              onRequestTap: (entity) => goDetailRequestPage(
                context,
                RequestStatus.pending,
                entity,
              ),
              onNeedMoreItems: () => requestsBloc.add(
                RequestsEvent.loadMorePendingRequests(
                  isSigner: widget.isSigner,
                ),
              ),
              onRefresh: () =>
                  requestsBloc.add(const RequestsEvent.reloadRequests(
                requestStatus: RequestStatus.pending,
              )),
            ),
            emptyList: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Filters
                const FilterChipsBox(
                  requestStatus: RequestStatus.pending,
                ),
                Expanded(
                  child: (state.hasValidators ?? false) &&
                          !state.hasFilterActive(RequestStatus.pending)
                      //user has validators and filters are NOT active
                      ? const EmptyRequestList.emptyPendingRequestValidated()
                      : const EmptyRequestList
                          .emptyPendingRequestNormalWithFilter(),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              state.pendingRequestsStatus.screenStatus.isError()
                  ? null
                  : state.pendingRequestsStatus.requestsCount == 0
                      ? null
                      : BlocBuilder<MultiSelectionRequestBloc,
                          MultiSelectionRequestState>(
                          builder: (context, multiSelectionState) {
                            return multiSelectionState.showCheckbox
                                ? MultiSelectionTapFAB(
                                    isSigner: widget.isSigner,
                                    requestList: [
                                      ...state.allRequestsExceptExpiresToday,
                                      ...state.expiresTodayRequests,
                                    ],
                                  )
                                : MultiSelectionFAB(isScrolled: isScrolled);
                          },
                        ),
        );
      },
    );
  }

  void goDetailRequestPage(
    BuildContext context,
    RequestStatus type,
    RequestEntity entity,
  ) {
    context.read<DetailRequestBloc>().add(
          DetailRequestEvent.fetchDataRequest(entity.id),
        );
    context.push(
      RoutePath.detailRequest,
      extra: type,
    );
  }

  void scrollListener() {
    if (scrollController.offset != scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      isScrolled = true;
    }
  }
}
