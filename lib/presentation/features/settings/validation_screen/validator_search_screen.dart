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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/models/user_search.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/validator_button.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class ValidatorSearchScreen extends StatelessWidget {
  const ValidatorSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color white = AFTheme.of(context).colors.primaryWhite;
    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: white,
      appBar: AFTopSectionBar.section(
        themeComponent: AFThemeComponent.medium,
        title: context.localizations.new_validator_text,
        backButtonOverride: AFTopBarActionIcon(
          isSecondary: false,
          iconPath: Assets.iconX,
          onTap: () => authorizationStateLoad(context),
        ),
      ),
      body: BlocConsumer<UsersSearchBloc, UsersSearchState>(
        listener: (context, state) {
          if (state.isUserAdded) {
            showHelpOverlay(context, white, state);
          }
          if (state.screenStatus
              .isErrorType(const RepositoryError.serverError())) {
            showHelpOverlayError(
              context,
              state,
              context.localizations.something_went_wrong_modal_title,
              context.localizations.server_internal_error_description,
            );
          } else if (state.screenStatus.isError()) {
            showHelpOverlayError(
              context,
              state,
              context.localizations.request_send_failed,
              context.localizations.add_new_validator_modal_failed(
                state.selectedUser?.name ?? 'Unknown user',
              ),
            );
          }
        },
        builder: (ctx, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AFTitle(
                            brightness: AFThemeBrightness.light,
                            title: context.localizations.user_text,
                            size: AFTitleSize.s,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          AFSearch(
                            hintText: context.localizations.textfield_hint_text,
                            controller: controller,
                            action: () {
                              if (controller.text.isNotEmpty) {
                                context.read<UsersSearchBloc>().add(
                                      UsersSearchEvent.searchTextChanged(
                                        controller.text,
                                        ValidatorAuthorization.validator,
                                      ),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: context
                                .read<UsersSearchBloc>()
                                .state
                                .numberOfResults >
                            0,
                        replacement: Visibility(
                          visible: controller.text.isNotEmpty &&
                              state.suggestedUsers.every(
                                (user) => !user.name.toLowerCase().contains(
                                      controller.text.toLowerCase(),
                                    ),
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: SvgPicture.asset(
                                        Assets.iconAlertCircle,
                                      ),
                                    ),
                                    AFTitle(
                                      brightness: AFThemeBrightness.light,
                                      title: context
                                          .localizations.error_result_text,
                                      subTitle: context
                                          .localizations.error_result_text_tip,
                                      size: AFTitleSize.l,
                                      align: AFTitleAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AFTitle(
                              brightness: AFThemeBrightness.light,
                              title:
                                  '${state.numberOfResults} ${context.localizations.result_text}',
                              size: AFTitleSize.s,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) => AFMenuList.selectOne(
                      shrinkWrap: true,
                      preSelectedItem: state.selectedUser,
                      elements: state.suggestedUsers,
                      onItemTap: (user) {
                        context
                            .read<UsersSearchBloc>()
                            .add(UsersSearchEvent.selectedUser(user));
                      },
                      itemBuilder: (
                        BuildContext context,
                        UserSearch user,
                        AFThemeBrightness brightness,
                        Function() onTap,
                        bool isSelected,
                      ) {
                        return AFMenu.oneSelect(
                          text: user.name,
                          onTap: onTap,
                          isSelected: isSelected,
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible:
                        controller.text.isNotEmpty && state.numberOfResults > 0,
                    child: ValidatorButtonWidget(state: state),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

@visibleForTesting
showHelpOverlay(BuildContext context, Color white, state) {
  return showModalBottomSheet(
    backgroundColor: white,
    isScrollControlled: true,
    context: context,
    shape: AFOverlayBottomSheetShapeBorder(),
    builder: (context) => ModalTemplate(
      isReverse: false,
      header: context.localizations.add_validator_success,
      description: context.localizations
          .add_new_validator_modal(state.selectedUser.name.toString()),
      iconPath: Assets.iconCheckCircle,
      mainButtonText: context.localizations.general_understood,
      mainButtonFunction: () {
        context.read<ValidationScreenBloc>().add(
              const ValidationScreenEvent.loadUsers(),
            );
        context.go(RoutePath.validationScreen);
      },
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

@visibleForTesting
showHelpOverlayError(
  BuildContext context,
  state,
  String header,
  String description,
) {
  return showModalBottomSheet(
    backgroundColor: AFTheme.of(context).colors.primaryWhite,
    isScrollControlled: true,
    context: context,
    shape: AFOverlayBottomSheetShapeBorder(),
    builder: (context) => ModalTemplate(
      isReverse: false,
      header: header,
      description: description,
      iconPath: Assets.iconXCircle,
      mainButtonText: context.localizations.general_understood,
      mainButtonFunction: () => context.pop(),
    ),
  );
}
