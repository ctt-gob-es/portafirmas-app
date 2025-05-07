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
import 'package:portafirmas_app/app/utils/screen_utils.dart';
import 'package:portafirmas_app/presentation/features/filters/bloc/bloc/filters_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/filter_init_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/custom_select_input.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/filters_buttons_box.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/filters_column.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/filters_selection_menu_list.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';

class FiltersScreen extends StatelessWidget {
  final FilterInitData initData;
  const FiltersScreen({
    super.key,
    required this.initData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        RequestsState requestsState = context.read<RequestsBloc>().state;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AFTheme.of(context).colors.primaryWhite,
          appBar: AFTopSectionBar.section(
            backButtonOverride: AFTopBarActionIcon(
              iconPath: Assets.iconX,
              onTap: () => context.pop(),
              semanticsLabel: context.localizations.general_back,
            ),
            title: context.localizations.filters_title,
            titleSemanticsLabel: context.localizations.filters_title,
            themeComponent: AFThemeComponent.medium,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.space4),
              child: state.screenStatus.whenOrNull(
                    success: () => Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ScreenUtils.isSmallScreen(context)
                              ? Spacing.space2
                              : Spacing.space8,
                        ),
                        AFTitle(
                          brightness: AFThemeBrightness.light,
                          title: context.localizations.filters_order,
                          semanticTitle: context.localizations.filters_order,
                          size: AFTitleSize.s,
                        ),
                        //Select Order
                        CustomSelectInput(
                          initialValue: requestsState
                                  .hasFilterActive(initData.requestStatus)
                              ? state.temporalFilters.order.getTitle(context)
                              : null,
                          labelText: context.localizations.filters_select_sort,
                          overlayTitle:
                              context.localizations.filters_select_order,
                          selectionMenu: FiltersSelectionMenuList(
                            initialFilter:
                                state.temporalFilters.order.getTitle(context),
                            onChanged: (selected) => context
                                .read<FiltersBloc>()
                                .add(FiltersEvent.selectedOrderFilter(
                                  orderFilter: OrderFilter.values.firstWhere(
                                    (e) => e.getTitle(context) == selected,
                                  ),
                                )),
                            elements: OrderFilter.values
                                .map((e) => e.getTitle(context))
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtils.isSmallScreen(context)
                              ? Spacing.space3
                              : Spacing.space6,
                        ),
                        AFTitle(
                          brightness: AFThemeBrightness.light,
                          title: context.localizations.filters_title,
                          semanticTitle: context.localizations.filters_title,
                          size: AFTitleSize.s,
                        ),
                        //RequestType, inputFilter, TimeInterval and App filters
                        FiltersColumn(
                          temporalFilters: state.temporalFilters,
                          isFiltersEdited: requestsState
                              .hasFilterActive(initData.requestStatus),
                        ),
                      ],
                    ),
                  ) ??
                  const Center(
                    heightFactor: 15,
                    child: CircularProgressIndicator(),
                  ),
            ),
          ),
          bottomNavigationBar: state.screenStatus.whenOrNull(
                loading: () => const SizedBox(),
              ) ??
              Padding(
                padding: const EdgeInsets.only(
                  left: Spacing.space4,
                  right: Spacing.space4,
                  bottom: Spacing.space4,
                  top: 0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FiltersButtonsBox(
                    onTapClear: () => _clearFilters(context),
                    onTapApply: () => _applyFiltersAndGoToHome(
                      context,
                      state.temporalFilters,
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }

  void _clearFilters(BuildContext context) {
    context.read<RequestsBloc>().add(const RequestsEvent.cleanFilters());

    bool hasValidator = (context.read<RequestsBloc>().state.hasValidators ??
        false || initData.requestStatus == RequestStatus.validated);
    context
        .read<FiltersBloc>()
        .add(FiltersEvent.resetFilters(hasValidators: hasValidator));
  }

  void _applyFiltersAndGoToHome(BuildContext context, RequestFilter filter) {
    RequestsBloc bloc = context.read<RequestsBloc>();

    bloc.add(RequestsEvent.updateFilter(
      newFilters: bloc.state.getUpdatedFilters(initData.requestStatus, filter),
      isSigner: !initData.isValidatorProfile,
      dniValidatorFilter: bloc.state.dniValidatorFilter,
      checkedValidators: true,
    ));
    context.pop();
  }
}
