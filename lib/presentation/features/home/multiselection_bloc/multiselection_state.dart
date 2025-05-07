
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'multiselection_bloc.dart';

@freezed
class MultiSelectionRequestState with _$MultiSelectionRequestState {
  const factory MultiSelectionRequestState({
    required bool isSelected,
    required bool showCheckbox,
    required Map<RequestEntity, bool> selectedRequests,
    required bool isButtonEnabled,
  }) = _MultiSelectionRequestState;

  factory MultiSelectionRequestState.initial() =>
      const MultiSelectionRequestState(
        isSelected: false,
        showCheckbox: false,
        selectedRequests: {},
        isButtonEnabled: false,
      );
}

extension MultiSelectionRequestStateExtension on MultiSelectionRequestState {
  List<RequestEntity> approvalSelectedReqs() =>
      selectedRequests.keys.where((el) => el.type.isApproval()).toList();
  List<RequestEntity> signatureSelectedReqs() =>
      selectedRequests.keys.where((el) => el.type.isSignature()).toList();
}
