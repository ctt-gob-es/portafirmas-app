
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
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/presentation/features/filters/bloc/bloc/filters_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/widgets/app_selection_menu_list.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/custom_select_input.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/filters_selection_menu_list.dart';

class FiltersColumn extends StatelessWidget {
  final RequestFilter temporalFilters;
  final bool isFiltersEdited;

  const FiltersColumn({
    Key? key,
    required this.temporalFilters,
    required this.isFiltersEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Select Request type
        CustomSelectInput(
          initialValue: isFiltersEdited
              ? temporalFilters.requestType.getTitle(context)
              : null,
          isAppFilter: true,
          labelText: context.localizations.filters_select_request_type,
          overlayTitle: context.localizations.filters_select_request_type,
          selectionMenu: FiltersSelectionMenuList(
            initialFilter: temporalFilters.requestType.getTitle(context),
            onChanged: (selected) => context
                .read<FiltersBloc>()
                .add(FiltersEvent.selectedRequestTypeFilter(
                  requestTypeFilter: RequestTypeFilter.values.firstWhere(
                    (e) => e.getTitle(context) == selected,
                  ),
                )),
            elements: RequestTypeFilter.values
                .map((e) => e.getTitle(context))
                .toList(),
          ),
        ),
        const SizedBox(
          height: Spacing.space4,
        ),
        AFTextInput(
          labelText: context.localizations.filters_enter_topic,
          initialValue: temporalFilters.inputFilter,
          onChanged: (text) => _updateInputFilter(text, context),
        ),
        //Select time interval
        CustomSelectInput(
          initialValue: isFiltersEdited
              ? temporalFilters.timeInterval.getTitle(context)
              : null,
          isAppFilter: true,
          labelText: context.localizations.filters_select_time_interval,
          overlayTitle: context.localizations.filters_select_time_interval,
          selectionMenu: FiltersSelectionMenuList(
            initialFilter: temporalFilters.timeInterval.getTitle(context),
            onChanged: (selected) => context
                .read<FiltersBloc>()
                .add(FiltersEvent.selectedTimeIntervalFilter(
                  timeIntervalFilter: TimeIntervalFilter.values.firstWhere(
                    (e) => e.getTitle(context) == selected,
                  ),
                )),
            elements: TimeIntervalFilter.values
                .map((e) => e.getTitle(context))
                .toList(),
          ),
        ),
        //Select application
        CustomSelectInput(
          isAppFilter: true,
          initialValue: temporalFilters.app?.name,
          labelText: context.localizations.filters_application,
          overlayTitle: context.localizations.filters_application,
          selectionMenu: AppSelectionMenuList(
            initialApp: temporalFilters.app,
            onChanged: (selectedApp) => context
                .read<FiltersBloc>()
                .add(FiltersEvent.selectedAppFilter(app: selectedApp)),
          ),
        ),
      ],
    );
  }

  void _updateInputFilter(
    String inputText,
    BuildContext context,
  ) {
    if (inputText.length >= 3 || inputText == '') {
      String? input = inputText == '' ? null : inputText;
      context
          .read<FiltersBloc>()
          .add(FiltersEvent.updatedInputFilter(inputFilter: input));
    }
  }
}
