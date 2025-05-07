
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'sign_bloc.dart';

enum ActionType { signVb, validate, revoke }

@freezed
class SignState with _$SignState {
  const factory SignState({
    required ActionType? action,
    required ScreenStatus screenStatus,
    required bool? isSingleRequest,
    List<PostSignReqEntity>? signedReqs,
    List<ApprovedRequestEntity>? approvedReqs,
    List<String>? preSignedReqsWithClave,
    int? validatedReqsLength,
    int? rejectedReqsLength,
    String? signUrl,
  }) = _SignState;

  factory SignState.initial() => const SignState(
        action: null,
        screenStatus: ScreenStatus.initial(),
        isSingleRequest: null,
        signedReqs: null,
        approvedReqs: null,
        validatedReqsLength: null,
        rejectedReqsLength: null,
        signUrl: null,
      );
}

extension SignStateExtension on SignState {
  bool isLoading(ActionType type) =>
      screenStatus == const ScreenStatus.loading() && action == type;

  bool isLoadingAny() => screenStatus == const ScreenStatus.loading();

  int successfulSignatures() =>
      signedReqs?.where((el) => el.status).length ?? 0;

  int successfulApprovals() =>
      approvedReqs?.where((el) => el.status).length ?? 0;

  int successfulSignaturesAndApprovals() =>
      successfulApprovals() + successfulSignatures();

  int failedSignatures() => signedReqs?.where((el) => !el.status).length ?? 0;

  int failedApprovals() => approvedReqs?.where((el) => !el.status).length ?? 0;
}
