
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:portafirmas_app/presentation/features/add_certificate/add_certificate_bloc/add_certificate_bloc.dart';

import 'package:portafirmas_app/presentation/features/certificates/certificates_warning_screen_android.dart';

class CertificatesWarningScreenAndroidProvider extends StatelessWidget {
  final _getIt = GetIt.instance;
  CertificatesWarningScreenAndroidProvider({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getIt<AddCertificateBloc>(),
      child: const CertificatesWarningScreenAndroid(),
    );
  }
}
