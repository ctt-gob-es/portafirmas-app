/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/pick_file_repository_contract.dart';

part 'add_certificate_bloc.freezed.dart';
part 'add_certificate_event.dart';
part 'add_certificate_state.dart';

class AddCertificateBloc
    extends Bloc<AddCertificateEvent, AddCertificateState> {
  final CertificateRepositoryContract _certificateRepository;
  final PickFileRepositoryContract _fileRepository;

  AddCertificateBloc({
    required CertificateRepositoryContract certificateRepository,
    required PickFileRepositoryContract fileRepositoryContract,
  })  : _certificateRepository = certificateRepository,
        _fileRepository = fileRepositoryContract,
        super(AddCertificateState.initial()) {
    on<AddCertificateEvent>((event, emit) async {
      await event.when(addCertificate: (context) async {
        emit(state.copyWith(screenStatus: const ScreenStatus.loading()));

        final certificateResult =
            await _fileRepository.getCertificateFileContent();

        final certificateContent =
            certificateResult.whenOrNull(success: (path) => path);

        if (certificateContent == null) {
          emit(
            state.copyWith(screenStatus: const ScreenStatus.initial()),
          );
        } else {
          if (!context.mounted) {
            emit(state.copyWith(screenStatus: const ScreenStatus.error()));

            return;
          }

          final result = await _certificateRepository.addCertificate(
            context: context,
            certificate: certificateContent,
          );

          result.when(
            failure: (e) =>
                emit(state.copyWith(screenStatus: ScreenStatus.error(e))),
            success: (_) => emit(
              state.copyWith(screenStatus: const ScreenStatus.success()),
            ),
          );
        }
      });
    });
  }
}
