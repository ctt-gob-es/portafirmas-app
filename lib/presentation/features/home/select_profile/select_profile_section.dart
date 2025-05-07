
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
import 'package:portafirmas_app/data/repositories/models/user_role.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';

class SelectProfileSection extends StatefulWidget {
  final List<UserRole> profiles;
  final UserRole? selectedProfile;

  const SelectProfileSection({
    super.key,
    required this.profiles,
    required this.selectedProfile,
  });

  @override
  State<SelectProfileSection> createState() => _SelectProfileSectionState();
}

class _SelectProfileSectionState extends State<SelectProfileSection> {
  String? itemSelected;

  @override
  Widget build(BuildContext context) {
    ProfileBloc profileBloc = context.read<ProfileBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AFTitle(
                  isHeader: true,
                  brightness: AFThemeBrightness.light,
                  title: context.localizations.select_profile_title,
                  size: AFTitleSize.xl,
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      excludeSemantics: true,
                      button: true,
                      selected: itemSelected == null &&
                          widget.selectedProfile == null,
                      label: context.localizations.signer_user_text,
                      child: AFRadioButton(
                        textDetectTap: true,
                        title: context.localizations.signer_user_text,
                        onTap: () {
                          profileBloc.add(
                            const ProfileEvent.profileSelected(null),
                          );
                          setState(() {
                            itemSelected = null;
                          });
                        },
                        value: itemSelected == null &&
                            widget.selectedProfile == null,
                      ),
                    ),
                    ...widget.profiles
                        .map(
                          (item) => Semantics(
                            excludeSemantics: true,
                            button: true,
                            selected: widget.selectedProfile != null
                                ? (item.dni == widget.selectedProfile?.dni)
                                : item.dni == itemSelected,
                            label:
                                '${context.localizations.validator_of_user_text}${item.userName}',
                            child: AFRadioButton(
                              textDetectTap: true,
                              title:
                                  '${context.localizations.validator_of_user_text}${item.userName}',
                              onTap: () {
                                profileBloc.add(
                                  ProfileEvent.profileSelected(
                                    item.dni,
                                  ),
                                );
                                setState(() {
                                  itemSelected = item.dni;
                                });
                              },
                              value: widget.selectedProfile != null
                                  ? (item.dni == widget.selectedProfile?.dni)
                                  : item.dni == itemSelected,
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AFNotification.info(
                  type: AFNotificationType.halfTone,
                  title: context.localizations.request_notification_title,
                  message: context.localizations.request_notification_message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
