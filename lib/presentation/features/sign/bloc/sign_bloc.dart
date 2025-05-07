/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';
import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/models/post_sign_req_entity.dart';
import 'package:portafirmas_app/domain/models/pre_sign_req_entity.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/revoked_request_entity.dart';
import 'package:portafirmas_app/domain/models/validate_petition_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/sign_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/detail/model/signed_request.dart';

part 'sign_bloc.freezed.dart';
part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  final RequestRepositoryContract _requestRepository;
  final SignRepositoryContract _signRepository;
  SignBloc({
    required RequestRepositoryContract repositoryContract,
    required SignRepositoryContract signRepositoryContract,
  })  : _requestRepository = repositoryContract,
        _signRepository = signRepositoryContract,
        super(SignState.initial()) {
    on<SignEvent>((event, emit) async {
      await event.when(
        preSignRequest: (requests, approvedReqs) =>
            _getSignMethodAndSignRequests(
          requests,
          emit,
          approvedReqs,
        ),
        signRequest: (preSignedReqs) => _signRequests(preSignedReqs, emit),
        postSignRequest: (List<SignedRequest> signedReqs, idMethod) =>
            _postSignRequests(signedReqs, emit, idMethod),
        revokeRequests: (List<String> requestIds, reason) =>
            _revokeRequests(requestIds, reason, emit),
        validateRequests: (requestIds) => _validateRequests(requestIds, emit),
        approveReques:
            (List<String> requestIds, List<RequestEntity>? signRequests) =>
                _approveRequest(
          requestIds,
          emit,
          signRequests,
        ),
        showSigningError: () async => emit(state.copyWith(
          screenStatus: const ScreenStatus.error(),
          signUrl: null,
        )),
      );
    });
  }

  FutureOr<void> _getSignMethodAndSignRequests(
    List<RequestEntity> requests,
    Emitter<SignState> emit,
    List<ApprovedRequestEntity>? approvedReqs,
  ) async {
    emit(SignState.initial().copyWith(
      screenStatus: const ScreenStatus.loading(),
      action: ActionType.signVb,
      isSingleRequest: (requests.length == 1),
      approvedReqs: approvedReqs,
    ));

    final AuthMethod? idMethod = await _signRepository.getAuthMethod();

    await idMethod?.when(
      certificate: () async => await _preSignRequestsCert(requests, emit),
      clave: () async =>
          await _preSignRequestsClave(requests.map((e) => e.id).toList(), emit),
    );
  }

  FutureOr<void> _preSignRequestsCert(
    List<RequestEntity> requests,
    Emitter<SignState> emit,
  ) async {
    //Pre signs requests and then calls sign event
    final res = await _signRepository.preSignWithCert(
      signReqs: requests
          .map((req) => SignRequestPetitionRemoteEntity.fromDetailRequest(req))
          .toList(),
    );

    res.when(
      failure: (e) => emit(state.copyWith(
        screenStatus: ScreenStatus.error(e),
        action: ActionType.signVb,
        isSingleRequest: (requests.length == 1),
      )),
      success: (data) {
        add(SignEvent.signRequest(preSignedRequests: data));
      },
    );
  }

  FutureOr<void> _preSignRequestsClave(
    List<String> requestIds,
    Emitter<SignState> emit,
  ) async {
    //Get sign url and then open webview to sign requests with clave
    final signedReq =
        await _signRepository.preSignWithClave(requestIds: requestIds);

    signedReq.when(
      failure: (e) => emit(state.copyWith(
        screenStatus: ScreenStatus.error(e),
        action: ActionType.signVb,
        isSingleRequest: (requestIds.length == 1),
      )),
      success: (data) => emit(data.status
          ? state.copyWith(
              signUrl: data.signUrl,
              preSignedReqsWithClave: requestIds,
              screenStatus: const ScreenStatus.success(),
            )
          : state.copyWith(
              screenStatus: const ScreenStatus.error(),
              action: ActionType.signVb,
              isSingleRequest: (requestIds.length == 1),
            )),
    );
  }

  FutureOr<void> _signRequests(
    List<PreSignReqEntity> preSignedReqs,
    Emitter<SignState> emit,
  ) async {
    //Sign petitions locally
    List<SignedRequest> signedReqs =
        await Stream.fromIterable(preSignedReqs).asyncMap((req) async {
      final signedReq =
          await _signRepository.signWithCert(preSignedRequest: req);

      return await signedReq.when(
        failure: (e) async => SignedRequest(
          id: req.requestId,
          signedDocuments: null,
          status: req.status,
        ),
        success: (data) async => data,
      );
    }).toList();
    //Last step, post sign with the sign result
    add(SignEvent.postSignRequest(
      signedReqs: signedReqs,
      signMethod: const AuthMethod.certificate(),
    ));
  }

  FutureOr<void> _postSignRequests(
    List<SignedRequest> signedReqs,
    Emitter<SignState> emit,
    AuthMethod signMethod,
  ) async {
    await signMethod.when(
      certificate: () async => await _postSignWithCert(signedReqs, emit),
      clave: () async =>
          await _postSignWithClave(signedReqs.map((e) => e.id).toList(), emit),
    );
  }

  FutureOr<void> _postSignWithCert(
    List<SignedRequest> signedReqs,
    Emitter<SignState> emit,
  ) async {
    //Call post sign with cert to finish signature process
    final postSignResult = await _signRepository.postSignWithCert(
      signedReqs: signedReqs
          .skipWhile((r) => r.signedDocuments == null)
          .map((req) => SignRequestPetitionRemoteEntity.fromSignedRequest(req))
          .toList(),
    );

    postSignResult.when(
      failure: (e) => emit(state.copyWith(screenStatus: ScreenStatus.error(e))),
      success: (data) => emit(state.copyWith(
        screenStatus: data.any((sign) => !sign.status)
            ? const ScreenStatus.error()
            : const ScreenStatus.success(),
        action: ActionType.signVb,
        isSingleRequest: signedReqs.length == 1,
        signedReqs: data,
      )),
    );
  }

  FutureOr<void> _postSignWithClave(
    List<String> requestIds,
    Emitter<SignState> emit,
  ) async {
    emit(state.copyWith(
      screenStatus: const ScreenStatus.loading(),
      signUrl: null,
    ));
    //Call post sign with clave to finish signature process
    final postSignResult = await _signRepository.postSignWithClave();

    postSignResult.when(
      failure: (e) => emit(state.copyWith(screenStatus: ScreenStatus.error(e))),
      success: (data) => emit(state.copyWith(
        screenStatus: data.status
            ? const ScreenStatus.success()
            : const ScreenStatus.error(),
        action: ActionType.signVb,
        isSingleRequest: requestIds.length == 1,
        signedReqs: requestIds
            .map((reqId) =>
                PostSignReqEntity(requestId: reqId, status: data.status))
            .toList(),
      )),
    );
  }

  FutureOr<void> _revokeRequests(
    List<String> requestIds,
    String? reason,
    Emitter<SignState> emit,
  ) async {
    emit(SignState.initial().copyWith(
      screenStatus: const ScreenStatus.loading(),
      action: ActionType.revoke,
      isSingleRequest: (requestIds.length == 1),
    ));

    final result = await _requestRepository.revokeRequests(
      reason: reason ?? '',
      requestIds: requestIds,
    );
    result.when(
      failure: (e) => emit(state.copyWith(screenStatus: ScreenStatus.error(e))),
      success: (data) {
        List<RevokedRequestEntity> notRejected =
            data.where((el) => !el.status).toList();
        if (notRejected.isEmpty) {
          emit(
            state.copyWith(
              screenStatus: const ScreenStatus.success(),
              rejectedReqsLength: data.length,
            ),
          );
        } else {
          emit(state.copyWith(screenStatus: const ScreenStatus.error()));
        }
      },
    );
  }

  FutureOr<void> _validateRequests(
    List<String> requestIds,
    Emitter<SignState> emit,
  ) async {
    emit(
      SignState.initial().copyWith(
        screenStatus: const ScreenStatus.loading(),
        action: ActionType.validate,
        isSingleRequest: (requestIds.length == 1),
      ),
    );
    final result = await _requestRepository.validatePetition(id: requestIds);

    result.when(
      failure: (e) => emit(
        state.copyWith(
          screenStatus: ScreenStatus.error(e),
        ),
      ),
      success: (data) {
        List<ValidatePetitionEntity> notValidated =
            data.where((e) => !e.status).toList();
        if (notValidated.isEmpty) {
          emit(
            state.copyWith(
              screenStatus: const ScreenStatus.success(),
              validatedReqsLength: data.length,
            ),
          );
        } else {
          emit(state.copyWith(screenStatus: const ScreenStatus.error()));
        }
      },
    );
  }

  FutureOr<void> _approveRequest(
    List<String> requestIds,
    Emitter<SignState> emit,
    List<RequestEntity>?
        signRequests, //If there is signRequest, it will be signed after the success approval of requestsIds
  ) async {
    emit(SignState.initial().copyWith(
      screenStatus: const ScreenStatus.loading(),
      isSingleRequest: (requestIds.length == 1),
      action: ActionType.signVb,
    ));

    final result = await _requestRepository.approveRequests(
      requestIds: requestIds,
    );
    result.when(
      failure: (error) =>
          emit(state.copyWith(screenStatus: const ScreenStatus.error())),
      success: (data) => signRequests == null
          ? emit(
              state.copyWith(
                screenStatus: const ScreenStatus.success(),
                approvedReqs: data,
              ),
            )
          : //signs requests (only when approval and sign requests were selected at once)
          add(SignEvent.preSignRequest(
              signRequests: signRequests,
              approvedReqs: data,
            )),
    );
  }
}
