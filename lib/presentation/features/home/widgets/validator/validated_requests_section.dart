
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
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chips_box.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/switcher_request_list_empty_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/empty_request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/validator/header_validated_requests.dart';

class ValidatedRequestsSection extends StatefulWidget {
  const ValidatedRequestsSection({Key? key}) : super(key: key);

  @override
  State<ValidatedRequestsSection> createState() =>
      _ValidatedRequestsSectionState();
}

class _ValidatedRequestsSectionState extends State<ValidatedRequestsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RequestsBloc>()
        ..add(const RequestsEvent.checkFilters(RequestStatus.validated))
        ..add(const RequestsEvent.reloadRequests(
          requestStatus: RequestStatus.validated,
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestsBloc = context.read<RequestsBloc>();

    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        return SwitcherRequestListEmptyList(
          totalCount: state.validatedRequestsStatus.requestsCount,
          requestList: RequestList(
            requestStatus: RequestStatus.validated,
            showError: state.validatedRequestsStatus.screenStatus.isError(),
            onRetryAfterErrorTap: () => requestsBloc
                .add(const RequestsEvent.loadMoreValidatedRequests()),
            header: HeaderValidatedRequests(
              hasFilters: state.hasFilterActive(RequestStatus.validated),
              requestCount: state.validatedRequestsStatus.requestsCount ?? 0,
            ),
            isLoadingMoreItems:
                state.validatedRequestsStatus.screenStatus.isLoading(),
            requestList: state.validatedRequestsStatus.requests,
            onRequestTap: (entity) {
              goDetailRequestPage(context, RequestStatus.validated, entity);
            },
            onNeedMoreItems: () => requestsBloc
                .add(const RequestsEvent.loadMoreValidatedRequests()),
            onRefresh: () =>
                requestsBloc.add(const RequestsEvent.reloadRequests(
              requestStatus: RequestStatus.validated,
            )),
          ),
          emptyList: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Filters
              const FilterChipsBox(
                requestStatus: RequestStatus.validated,
              ),
              Expanded(
                child: !state.hasFilterActive(RequestStatus.validated)
                    ? const EmptyRequestList.emptyValidatedRequests()
                    : const EmptyRequestList.emptyPendingRequestValidated(),
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
