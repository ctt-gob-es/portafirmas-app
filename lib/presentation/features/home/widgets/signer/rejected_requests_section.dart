
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
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/empty_request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chips_box.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/header_rejected_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/switcher_request_list_empty_list.dart';

class RejectedRequestsSection extends StatefulWidget {
  final bool isSigner;

  const RejectedRequestsSection({Key? key, required this.isSigner})
      : super(key: key);

  @override
  State<RejectedRequestsSection> createState() =>
      _RejectedRequestsSectionState();
}

class _RejectedRequestsSectionState extends State<RejectedRequestsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RequestsBloc>()
        ..add(const RequestsEvent.checkFilters(RequestStatus.rejected))
        ..add(const RequestsEvent.reloadRequests(
          requestStatus: RequestStatus.rejected,
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestsBloc = context.read<RequestsBloc>();

    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        return SwitcherRequestListEmptyList(
          totalCount: state.rejectedRequestsStatus.requestsCount,
          requestList: RequestList(
            requestStatus: RequestStatus.rejected,
            showError: state.rejectedRequestsStatus.screenStatus.isError(),
            onRetryAfterErrorTap: () =>
                requestsBloc.add(RequestsEvent.loadMoreRejectedRequests(
              isSigner: widget.isSigner,
            )),
            header: HeaderRejectedRequests(
              hasFilters: state.hasFilterActive(RequestStatus.rejected),
              requestCount: state.rejectedRequestsStatus.requestsCount ?? 0,
            ),
            isLoadingMoreItems:
                state.rejectedRequestsStatus.screenStatus.isLoading(),
            requestList: state.rejectedRequestsStatus.requests,
            onRequestTap: (request) {
              goDetailRequestPage(context, RequestStatus.rejected, request);
            },
            onNeedMoreItems: () => requestsBloc.add(
              RequestsEvent.loadMoreRejectedRequests(
                isSigner: widget.isSigner,
              ),
            ),
            onRefresh: () =>
                requestsBloc.add(const RequestsEvent.reloadRequests(
              requestStatus: RequestStatus.rejected,
            )),
          ),
          emptyList: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Filters
              const FilterChipsBox(
                requestStatus: RequestStatus.rejected,
              ),
              Expanded(
                child: state.hasFilterActive(RequestStatus.rejected)
                    ? const EmptyRequestList
                        .emptySignedAndRejectedRequestsWithFilters()
                    : const EmptyRequestList.emptyRejectedRequests(),
              ),
            ],
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
}
