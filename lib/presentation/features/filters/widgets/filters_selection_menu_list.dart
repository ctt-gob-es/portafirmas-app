
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
import 'package:portafirmas_app/app/constants/spacing.dart';
import 'package:portafirmas_app/presentation/features/filters/widgets/select_button.dart';

class FiltersSelectionMenuList extends StatefulWidget {
  final String initialFilter;
  final Function(String) onChanged;
  final List<String> elements;

  const FiltersSelectionMenuList({
    super.key,
    required this.initialFilter,
    required this.onChanged,
    required this.elements,
  });

  @override
  State<FiltersSelectionMenuList> createState() =>
      _FiltersSelectionMenuListState();
}

class _FiltersSelectionMenuListState extends State<FiltersSelectionMenuList> {
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AFMenuList.selectOne(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: Spacing.space4),
          elements: widget.elements,
          preSelectedItem: widget.initialFilter,
          itemBuilder: ((
            context,
            filter,
            brightness,
            onTap,
            isSelected,
          ) => //TODO: change to V4 design
              Semantics(
                excludeSemantics: true,
                image: false,
                button: true,
                label: filter,
                selected: isSelected,
                child: AFMenu.oneSelect(
                  text: filter,
                  onTap: onTap,
                  isBox: true,
                  isSelected: isSelected,
                ),
              )),
          onItemTap: (item) => setState(() {
            selectedFilter = item;
          }),
        ),
        SelectButton(
          onTapSelect: () => popModal(),
        ),
      ],
    );
  }

  void popModal() {
    widget.onChanged(selectedFilter);
    Navigator.pop(context, selectedFilter);
  }
}
