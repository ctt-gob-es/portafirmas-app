
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
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chips_box.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/header_signed_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/switcher_request_list_empty_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/empty_request_list.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';

class SignedRequestsSection extends StatefulWidget {
  const SignedRequestsSection({Key? key}) : super(key: key);

  @override
  State<SignedRequestsSection> createState() => _SignedRequestsSectionState();
}

class _SignedRequestsSectionState extends State<SignedRequestsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RequestsBloc>()
        ..add(const RequestsEvent.checkFilters(RequestStatus.signed))
        ..add(const RequestsEvent.reloadRequests(
          requestStatus: RequestStatus.signed,
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestsBloc = context.read<RequestsBloc>();

    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        return SwitcherRequestListEmptyList(
          totalCount: state.signedRequestsStatus.requestsCount,
          requestList: RequestList(
            requestStatus: RequestStatus.signed,
            showError: state.signedRequestsStatus.screenStatus.isError(),
            onRetryAfterErrorTap: () =>
                requestsBloc.add(const RequestsEvent.loadMoreSignedRequests()),
            header: HeaderSignedRequests(
              hasFilters: state.hasFilterActive(RequestStatus.signed),
              requestCount: state.signedRequestsStatus.requestsCount ?? 0,
            ),
            isLoadingMoreItems:
                state.signedRequestsStatus.screenStatus.isLoading(),
            requestList: state.signedRequestsStatus.requests,
            onRequestTap: (request) {
              goDetailRequestPage(context, RequestStatus.signed, request);
            },
            onNeedMoreItems: () =>
                requestsBloc.add(const RequestsEvent.loadMoreSignedRequests()),
            onRefresh: () =>
                requestsBloc.add(const RequestsEvent.reloadRequests(
              requestStatus: RequestStatus.signed,
            )),
          ),
          emptyList: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Filters
              const FilterChipsBox(
                requestStatus: RequestStatus.signed,
              ),
              Expanded(
                child: state.hasFilterActive(RequestStatus.signed)
                    ? const EmptyRequestList
                        .emptySignedAndRejectedRequestsWithFilters()
                    : const EmptyRequestList.emptySignedRequests(),
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
