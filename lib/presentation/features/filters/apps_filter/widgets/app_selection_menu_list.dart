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
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/presentation/features/filters/apps_filter/bloc/bloc/app_filter_bloc.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/select_button.dart';
import 'package:portafirmas_app/presentation/widget/server_internal_error_overlay.dart';

class AppSelectionMenuList extends StatefulWidget {
  final RequestAppData? initialApp;
  final Function(RequestAppData) onChanged;

  const AppSelectionMenuList({
    super.key,
    required this.initialApp,
    required this.onChanged,
  });

  @override
  State<AppSelectionMenuList> createState() => _AppSelectionMenuListState();
}

class _AppSelectionMenuListState extends State<AppSelectionMenuList> {
  late String? selectedApp;

  @override
  void initState() {
    super.initState();
    selectedApp = widget.initialApp?.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppFilterBloc, AppFilterState>(
      listener: (context, state) {
        state.screenStatus
            .whenOrNull(error: (error) => _closeAndShowErrorOverlay(context));
      },
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: state.screenStatus.whenOrNull(
                success: () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: SingleChildScrollView(
                        child: AFMenuList.selectOne(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(bottom: Spacing.space4),
                          elements: state.appList ?? [],
                          preSelectedItem: widget.initialApp,
                          itemBuilder: ((
                            context,
                            app,
                            brightness,
                            onTap,
                            isSelected,
                          ) => //TODO: change to V4 design
                              Semantics(
                                excludeSemantics: true,
                                label: app.name,
                                image: false,
                                selected: isSelected,
                                button: true,
                                child: AFMenu.oneSelect(
                                  text: app.name,
                                  onTap: onTap,
                                  isBox: true,
                                  isSelected: isSelected,
                                ),
                              )),
                          onItemTap: (item) => setState(() {
                            selectedApp = item.name;
                          }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.space4),
                      child: SelectButton(
                        onTapSelect: () => popModal(state.appList),
                      ),
                    ),
                  ],
                ),
              ) ??
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
        );
      },
    );
  }

  void popModal(List<RequestAppData>? appList) {
    if (selectedApp != null && appList != null) {
      widget.onChanged(appList.firstWhere((app) => app.name == selectedApp));
      Navigator.pop(context, selectedApp);
    }
  }

  void _closeAndShowErrorOverlay(
    BuildContext context,
  ) {
    context.pop();
    showModalBottomSheet(
      backgroundColor: AFTheme.of(context).colors.primaryWhite,
      isScrollControlled: true,
      context: context,
      shape: AFOverlayBottomSheetShapeBorder(),
      builder: (ctx) => const ServerInternalErrorOverlay(),
    );
  }
}
