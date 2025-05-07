
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/buttons/af_button/button_component.dart';
import 'package:app_factory_ui/buttons/af_button/enums/button_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/data/repositories/models/user_search.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';

class ValidatorButtonWidget extends StatelessWidget {
  final UsersSearchState state;

  const ValidatorButtonWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AFButton.secondary(
        onPressed: () {
          context.read<UsersSearchBloc>().add(
                UsersSearchEvent.handleValidator(
                  state.selectedUser ??
                      const UserSearch(
                        dni: '',
                        id: '',
                        name: '',
                      ),
                ),
              );
        },
        text: context.localizations.add_new_validator_button,
        enabled: state.isButtonEnabled,
        sizeButton: AFButtonSize.l,
      ),
    );
  }
}
