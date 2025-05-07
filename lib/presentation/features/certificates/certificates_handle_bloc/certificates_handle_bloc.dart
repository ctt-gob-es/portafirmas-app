
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/presentation/features/certificates/certificates_handle_bloc/certificate_status_check.dart';

import 'package:portafirmas_app/domain/models/certificate_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';

part 'certificates_handle_event.dart';
part 'certificates_handle_state.dart';
part 'certificates_handle_bloc.freezed.dart';

class CertificatesHandleBloc
    extends Bloc<CertificatesHandleEvent, CertificatesHandleState> {
  final CertificateRepositoryContract _repository;
  CertificatesHandleBloc({
    required CertificateRepositoryContract repositoryContract,
  })  : _repository = repositoryContract,
        super(CertificatesHandleState.initial()) {
    on<CertificatesHandleEvent>((event, emit) async {
      await event.when(
        checkCertificates: () async {
          emit(
            state.copyWith(
              certificateCheck: const CertificateStatusCheck.loading(),
              attemptsSelectCertificate: 0,
            ),
          );
          final result = await _repository.checkCertificates();

          result.when(
            failure: (error) => emit(
              state.copyWith(
                certificateCheck: CertificateStatusCheck.error(error),
              ),
            ),
            hasCertificateSelected: (defaultCertificate) => emit(
              state.copyWith(
                certificateCheck:
                    const CertificateStatusCheck.goToCertificateServerScreen(),
                defaultCertificate: defaultCertificate,
              ),
            ),
            noCertificateSelected: () => emit(
              state.copyWith(
                certificateCheck:
                    const CertificateStatusCheck.goToCertificateServerScreen(),
                defaultCertificate: null,
              ),
            ),
            userHasNoCertificatesOnIOS: () => emit(
              state.copyWith(
                certificateCheck:
                    const CertificateStatusCheck.goToAddCertificate(),
              ),
            ),
          );
        },
        chooseDefaultCertificate: (context) async {
          emit(
            state.copyWith(
              selectDefaultCertificateStatus: const ScreenStatus.loading(),
            ),
          );
          final result = await _repository.changeDefaultCertificate(context);

          result.when(
            failure: (error) => emit(
              state.copyWith(
                selectDefaultCertificateStatus: ScreenStatus.error(error),
              ),
            ),
            success: (selectedCert) async {
              emit(
                state.copyWith(
                  selectDefaultCertificateStatus: const ScreenStatus.success(),
                  attemptsSelectCertificate:
                      state.attemptsSelectCertificate + 1,
                  defaultCertificate: selectedCert ?? state.defaultCertificate,
                ),
              );

              if (selectedCert != null) {
                await _repository.setCertificateDefault(selectedCert);
              }
            },
          );
        },
        reloadDefaultCertificate: () async {
          emit(
            state.copyWith(
              certificateCheck: const CertificateStatusCheck.loading(),
            ),
          );
          final result = await _repository.getDefaultCertificate();

          result.when(
            failure: (error) => emit(
              state.copyWith(
                certificateCheck: CertificateStatusCheck.error(error),
              ),
            ),
            success: (cert) => emit(
              state.copyWith(
                certificateCheck: const CertificateStatusCheck.idle(),
                defaultCertificate: cert,
              ),
            ),
          );
        },
      );
    });
  }
}
