
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
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/filters/filter_chip.dart';

class FilterChipsBox extends StatelessWidget {
  final RequestStatus requestStatus;
  const FilterChipsBox({super.key, required this.requestStatus});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        RequestFilter? filters = state.getCurrentFilter(requestStatus);
        RequestsBloc bloc = context.read<RequestsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            if ((state.isSignerAndHasValidators) &&
                filters?.requestType == RequestTypeFilter.validated &&
                requestStatus == RequestStatus.pending) ...[
              AFTip.richText(
                children: [
                  AFTextSpan(context.localizations.request_tips_1),
                  AFTextSpan(
                    context.localizations.request_tips_2,
                    isBold: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
            if (state.hasFilterActive(requestStatus))
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: state.isOnlyOrderFilter(requestStatus) ? 0 : 24,
                ),
                child: Wrap(runSpacing: 8, spacing: 8, children: [
                  //Request type filter
                  if (requestStatus == RequestStatus.pending &&
                      state.pendingRequestsStatus.screenStatus !=
                          const ScreenStatus.initial() &&
                      _showFilter(filters, state))
                    FiltersChip(
                      label: filters?.requestType.getChip(context) ?? '',
                      onTapChip: () => bloc.add(
                        RequestsEvent.updateFilter(
                          newFilters:
                              state.getCleanRequestTypeFilter(requestStatus),
                          dniValidatorFilter: state.dniValidatorFilter,
                          checkedValidators: state.validatorsChecked,
                        ),
                      ),
                    )
                  else if (requestStatus != RequestStatus.pending &&
                      _showFilter(filters, state))
                    FiltersChip(
                      label: filters?.requestType.getChip(context) ?? '',
                      onTapChip: () => bloc.add(
                        RequestsEvent.updateFilter(
                          newFilters:
                              state.getCleanRequestTypeFilter(requestStatus),
                          dniValidatorFilter: state.dniValidatorFilter,
                          checkedValidators: state.validatorsChecked,
                        ),
                      ),
                    ),
                  //Input filter
                  if (filters?.inputFilter != null)
                    FiltersChip(
                      label: '"${filters?.inputFilter}"',
                      onTapChip: () => bloc.add(
                        RequestsEvent.updateFilter(
                          newFilters: state.getCleanInputFilter(
                            requestStatus,
                          ),
                          dniValidatorFilter: state.dniValidatorFilter,
                          checkedValidators: state.validatorsChecked,
                        ),
                      ),
                    ),
                  //Time interval filter
                  if (filters?.timeInterval != TimeIntervalFilter.all)
                    FiltersChip(
                      label: '"${filters?.timeInterval.getTitle(context)}"',
                      onTapChip: () => bloc.add(
                        RequestsEvent.updateFilter(
                          newFilters:
                              state.getCleanTimeIntervalFilter(requestStatus),
                          dniValidatorFilter: state.dniValidatorFilter,
                          checkedValidators: state.validatorsChecked,
                        ),
                      ),
                    ),
                  //App filter
                  if (filters?.app != null)
                    FiltersChip(
                      label:
                          '"${filters?.app?.id == '0' ? filters?.app?.name : filters?.app?.id}"',
                      onTapChip: () => bloc.add(
                        RequestsEvent.updateFilter(
                          newFilters: state.getCleanAppFilter(requestStatus),
                          dniValidatorFilter: state.dniValidatorFilter,
                          checkedValidators: state.validatorsChecked,
                        ),
                      ),
                    ),
                ]),
              ),
          ],
        );
      },
    );
  }

  bool _showFilter(RequestFilter? filters, RequestsState state) {
    final statusIsPendingAndFilterIsNotValidatedAndIsSignerAndHasValidators =
        requestStatus == RequestStatus.pending &&
            filters?.requestType != RequestTypeFilter.validated &&
            state.isSignerAndHasValidators;

    final statusIsNotPendingAndFilterIsNotAllAndStatusIsNotValidated =
        requestStatus != RequestStatus.pending &&
            filters?.requestType != RequestTypeFilter.all &&
            requestStatus != RequestStatus.validated;

    final statusIsValidatedAndRequestIsNotValidated =
        requestStatus == RequestStatus.validated &&
            filters?.requestType != RequestTypeFilter.validated;

    final statusIsPendingAndFilterIsNotAllAndHasNotValidatorsAndIsNotSigner =
        requestStatus == RequestStatus.pending &&
            filters?.requestType != RequestTypeFilter.all &&
            (!(state.hasValidators ?? false) && (state.isSigner ?? false));
    final statusIsPendingAndFilterIsNotValidatedAndIsNotSigner =
        requestStatus == RequestStatus.pending &&
            filters?.requestType != RequestTypeFilter.notValidated &&
            !(state.isSigner ?? false);

    return (statusIsPendingAndFilterIsNotValidatedAndIsSignerAndHasValidators) ||
        statusIsNotPendingAndFilterIsNotAllAndStatusIsNotValidated ||
        statusIsValidatedAndRequestIsNotValidated ||
        statusIsPendingAndFilterIsNotAllAndHasNotValidatorsAndIsNotSigner ||
        statusIsPendingAndFilterIsNotValidatedAndIsNotSigner;
  }
}
