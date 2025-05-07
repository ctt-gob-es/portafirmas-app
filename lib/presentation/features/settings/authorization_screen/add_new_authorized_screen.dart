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
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/utils/error_utils.dart';
import 'package:portafirmas_app/app/utils/formate_data.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/new_authorization_user_entity.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/authorization_search_screen.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

//TODO: check if the setState can change into Bloc
class AddNewAuthorized extends StatefulWidget {
  const AddNewAuthorized({super.key});

  @override
  State<AddNewAuthorized> createState() => _AddNewAuthorizedState();
}

class _AddNewAuthorizedState extends State<AddNewAuthorized> {
  final FocusNode _focusSearch = FocusNode();
  final TextEditingController controller = TextEditingController();
  late bool selectedType = true;
  late String selectedValue = '';
  late String observation = '';
  late DateTime? startDate = DateTime.now();
  late DateTime? expDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusSearch;
    controller.addListener(showSearchedUsers);
  }

  @override
  void dispose() {
    _focusSearch.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AFTheme.of(context).colors.primaryWhite,
        appBar: AFTopSectionBar.section(
          themeComponent: AFThemeComponent.medium,
          title: context.localizations.new_authorized_text,
          backButtonOverride: AFTopBarActionIcon(
            isSecondary: false,
            iconPath: Assets.iconX,
            semanticsLabel: context.localizations.general_back,
            onTap: () => authorizationStateLoad(context),
          ),
        ),
        body: BlocConsumer<AuthorizationScreenBloc, AuthorizationScreenState>(
          listener: (context, state) {
            if (state.screenStatus.isSuccess()) {
              showHelpOverlay(context);
            }
            if (state.screenStatus
                .isErrorType(const RepositoryError.serverError())) {
              ErrorUtils.showErrorOverlay(context);
            } else if (state.screenStatus.isErrorType(
              const RepositoryError.addNewAuthorizedException(),
            )) {
              showHelpOverlayError(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AFTitle(
                      brightness: AFThemeBrightness.light,
                      title: context.localizations.user_text,
                      size: AFTitleSize.s,
                    ),
                    const SizedBox(height: 15),
                    Focus(
                      focusNode: _focusSearch,
                      child: AFSearch(
                        hintText: context.localizations.textfield_hint_text,
                        controller: controller,
                      ),
                    ),
                    Visibility(
                      visible: !_focusSearch.hasFocus ||
                          context.read<UsersSearchBloc>().state.selectedUser !=
                              null,
                      replacement:
                          AuthorizationSearchScreen(controller: controller),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 35),
                          AFTitle(
                            brightness: AFThemeBrightness.light,
                            title:
                                context.localizations.authorization_time_text,
                            size: AFTitleSize.s,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: AFDateInput(
                                  labelText:
                                      context.localizations.date_start_text,
                                  onChangeDate: (date) {
                                    startDate = date;
                                  },
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: AFDateInput(
                                  labelText:
                                      context.localizations.date_end_text,
                                  onChangeDate: (date) {
                                    expDate = date;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          AFTitle(
                            brightness: AFThemeBrightness.light,
                            title:
                                context.localizations.authorization_type_text,
                            size: AFTitleSize.s,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: AFRadioButton(
                                  title:
                                      context.localizations.delegate_user_text,
                                  value: !selectedType,
                                  onTap: () => setState(() {
                                    selectedType = false;
                                    selectedValue = context
                                        .localizations.delegate_user_text;
                                  }),
                                ),
                              ),
                              Expanded(
                                child: AFRadioButton(
                                  title: context
                                      .localizations.substitute_user_text,
                                  value: selectedType,
                                  onTap: () => setState(() {
                                    selectedType = true;
                                    selectedValue = context
                                        .localizations.substitute_user_text;
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          AFTitle(
                            brightness: AFThemeBrightness.light,
                            title: context.localizations.observation_text,
                            size: AFTitleSize.s,
                          ),
                          const SizedBox(height: 25),
                          AFTextInbox(
                            labelText: context.localizations
                                .authorization_details_screen_observation_textbox,
                            onChanged: (data) {
                              observation = data;
                            },
                            maxLength: 130,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Visibility(
          visible: !_focusSearch.hasFocus ||
              context.read<UsersSearchBloc>().state.selectedUser != null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 12,
            ),
            child: ExpandedButton(
              text: context.localizations.send_petition_button,
              isTertiary: false,
              size: AFButtonSize.l,
              onTap: () {
                final suggestedUsers =
                    context.read<UsersSearchBloc>().state.suggestedUsers.first;
                context.read<AuthorizationScreenBloc>().add(
                      AuthorizationScreenEvent.addAuthorization(
                        NewAuthorizationUserEntity(
                          type: selectedValue.isEmpty
                              ? context.localizations.substitute_user_text
                              : selectedValue,
                          nif: suggestedUsers.dni,
                          id: suggestedUsers.id,
                          observations: observation,
                          startDate:
                              formatDateYMDHM(startDate ?? DateTime.now()),
                          expDate: formatDateYMDHM(expDate ?? DateTime.now()),
                        ),
                      ),
                    );
              },
            ),
          ),
        ),
      ),
    );
  }

  void authorizationStateLoad(BuildContext context) {
    context.read<UsersSearchBloc>().add(const UsersSearchEvent.clearResults());
    context
        .read<ValidationScreenBloc>()
        .add(const ValidationScreenEvent.loadUsers());
    context.pop();
  }

  void showSearchedUsers() {
    setState(() {
      context.read<UsersSearchBloc>().add(
            UsersSearchEvent.searchTextChanged(
              controller.text,
              ValidatorAuthorization.authorization,
            ),
          );
    });
  }
}

@visibleForTesting
showHelpOverlay(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: AFTheme.of(context).colors.primaryWhite,
    isScrollControlled: true,
    context: context,
    shape: AFOverlayBottomSheetShapeBorder(),
    builder: (context) => ModalTemplate(
      isReverse: false,
      header: context.localizations.request_send_success,
      description: context.localizations.petition_description_success(
        context.read<UsersSearchBloc>().state.suggestedUsers.first.name,
      ),
      iconPath: Assets.iconCheckCircle,
      mainButtonText: context.localizations.general_understood,
      mainButtonFunction: () {
        context.read<AuthorizationScreenBloc>().add(
              const AuthorizationScreenEvent.loadAuthorizations(),
            );
        context.go(RoutePath.authorizationScreen);
      },
    ),
  );
}

@visibleForTesting
showHelpOverlayError(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: AFTheme.of(context).colors.primaryWhite,
    isScrollControlled: true,
    context: context,
    shape: AFOverlayBottomSheetShapeBorder(),
    builder: (context) => ModalTemplate(
      isReverse: false,
      header: context.localizations.request_send_failed,
      description: context.localizations.petition_description_failed(
        context.read<UsersSearchBloc>().state.suggestedUsers.first.name,
      ),
      iconPath: Assets.iconXCircle,
      mainButtonText: context.localizations.general_understood,
      mainButtonFunction: () => Navigator.pop(context),
    ),
  );
}
