
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/app/types/screen_status_with_result.dart';
import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';

part 'change_certificate_event.dart';
part 'change_certificate_state.dart';
part 'change_certificate_bloc.freezed.dart';

class ChangeCertificateBloc
    extends Bloc<ChangeCertificateEvent, ChangeCertificateState> {
  final CertificateRepositoryContract _certificateRepositoryContract;

  ChangeCertificateBloc({
    required CertificateRepositoryContract certificateRepositoryContract,
  })  : _certificateRepositoryContract = certificateRepositoryContract,
        super(ChangeCertificateState.initial()) {
    on<ChangeCertificateEvent>((event, emit) async {
      await event.when(
        loadAllCertificates: () => _mapToLoadAllCertificates(event, emit),
        changePreselectedCertificate: (certificateEntity) =>
            _mapToChangePreselectedCertificate(event, emit, certificateEntity),
        setPreselectedCertificateDefault: () =>
            _mapToSetDefaultCertificate(event, emit),
        deletePreselectedCertificate: () =>
            _mapToDeletePreselectedCertificate(event, emit),
        preselectedCertificateDeletedShow: () =>
            _mapToPreselectedCertificateDeletedShow(event, emit),
      );
    });
  }

  Future<void> _mapToLoadAllCertificates(
    ChangeCertificateEvent event,
    Emitter<ChangeCertificateState> emit,
  ) async {
    emit(state.copyWith(certificateListStatus: const ScreenStatus.loading()));
    final result = await _certificateRepositoryContract.getAllCertificates();
    final resultDefaultCertificate =
        await _certificateRepositoryContract.getDefaultCertificate();
    result.when(
      failure: (e) => emit(
        state.copyWith(certificateListStatus: ScreenStatus.error(e)),
      ),
      success: (certs) => emit(state.copyWith(
        certificates: certs,
        preselectedCertificate:
            resultDefaultCertificate.whenOrNull(success: (cert) => cert),
        certificateListStatus: const ScreenStatus.success(),
      )),
    );
  }

  _mapToChangePreselectedCertificate(
    ChangeCertificateEvent event,
    Emitter<ChangeCertificateState> emit,
    CertificateEntity certificateEntity,
  ) {
    emit(state.copyWith(preselectedCertificate: certificateEntity));
  }

  Future<void> _mapToSetDefaultCertificate(
    ChangeCertificateEvent event,
    Emitter<ChangeCertificateState> emit,
  ) async {
    emit(state.copyWith(
      certificateChangeDefaultStatus: const ScreenStatus.loading(),
    ));
    final preSelectedCertificate = state.preselectedCertificate;
    if (preSelectedCertificate != null) {
      final result = await _certificateRepositoryContract
          .setCertificateDefault(preSelectedCertificate);
      result.when(
        failure: (e) => emit(state.copyWith(
          certificateChangeDefaultStatus: ScreenStatus.error(e),
        )),
        success: (_) => emit(state.copyWith(
          certificateChangeDefaultStatus: const ScreenStatus.success(),
        )),
      );
    } else {
      emit(state.copyWith(
        certificateChangeDefaultStatus: const ScreenStatus.initial(),
      ));
    }
  }

  Future<void> _mapToDeletePreselectedCertificate(
    ChangeCertificateEvent event,
    Emitter<ChangeCertificateState> emit,
  ) async {
    emit(state.copyWith(
      certificateDeleteStatus: const ScreenStatusWithResult.loading(),
    ));
    final preSelectedCertificate = state.preselectedCertificate;
    if (preSelectedCertificate != null) {
      final result = await _certificateRepositoryContract
          .deleteCertificate(preSelectedCertificate);
      result.when(
        failure: (e) => emit(
          state.copyWith(
            certificateDeleteStatus: const ScreenStatusWithResult.error(),
          ),
        ),
        success: (_) => emit(state.copyWith(
          certificates: [...state.certificates]..remove(preSelectedCertificate),
          preselectedCertificate: null,
          certificateDeleteStatus:
              ScreenStatusWithResult.success(preSelectedCertificate),
        )),
      );
    } else {
      emit(state.copyWith(
        certificateDeleteStatus: const ScreenStatusWithResult.initial(),
      ));
    }
  }

  Future<void> _mapToPreselectedCertificateDeletedShow(
    ChangeCertificateEvent event,
    Emitter<ChangeCertificateState> emit,
  ) {
    emit(state.copyWith(
      certificateDeleteStatus: const ScreenStatusWithResult.initial(),
    ));

    return Future.value();
  }
}
