/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

part 'screen_status.freezed.dart';

/// Represents the different statuses of a screen.
@freezed
class ScreenStatus with _$ScreenStatus {
  /// Represents the initial status of a screen.
  const factory ScreenStatus.initial() = _Initial;

  /// Represents the loading status of a screen.
  const factory ScreenStatus.loading() = _Loading;

  /// Represents the success status of a screen.
  const factory ScreenStatus.success() = _Success;

  /// Represents the success status of a screen.
  const factory ScreenStatus.loadingMore() = _LoadingMore;

  /// Represents the error status of a screen.
  const factory ScreenStatus.error([RepositoryError? error]) = _Error;
}

/// Provides utility methods for the `ScreenStatus` class.
extension ScreenStatusExtension on ScreenStatus {
  /// Returns `true` if the current status is `loading`, otherwise `false`.
  bool isLoading() => maybeWhen(orElse: () => false, loading: () => true);

  bool isLoadingMore() =>
      maybeWhen(orElse: () => false, loadingMore: () => true);

  bool isError() => maybeWhen(orElse: () => false, error: (_) => true);

  bool isSessionExpiredError() => maybeWhen(
        orElse: () => false,
        error: (e) => e == const RepositoryError.sessionExpired(),
      );

  bool isErrorType(RepositoryError type) => maybeWhen(
        orElse: () => false,
        error: (e) => e == type ? true : false,
      );

  bool isTimeExpired() => maybeWhen(
        orElse: () => false,
        error: (e) => e == const RepositoryError.isTimeExpired() ? true : false,
      );

  bool isSuccess() => maybeWhen(orElse: () => false, success: () => true);
}
