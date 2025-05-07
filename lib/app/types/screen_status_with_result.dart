
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

part 'screen_status_with_result.freezed.dart';

/// Represents the different statuses of a screen.
@freezed
class ScreenStatusWithResult<T> with _$ScreenStatusWithResult<T> {
  /// Represents the initial status of a screen.
  const factory ScreenStatusWithResult.initial() = _Initial<T>;

  /// Represents the loading status of a screen.
  const factory ScreenStatusWithResult.loading() = _Loading<T>;

  /// Represents the success status of a screen.
  const factory ScreenStatusWithResult.success(T data) = _Success<T>;

  /// Represents the error status of a screen.
  const factory ScreenStatusWithResult.error([String? error]) = _Error<T>;
}

/// Provides utility methods for the `ScreenStatus` class.
extension ScreenStatusExtension on ScreenStatusWithResult {
  /// Returns `true` if the current status is `loading`, otherwise `false`.
  bool isLoading() => maybeWhen(orElse: () => false, loading: () => true);

  bool isError() => maybeWhen(orElse: () => false, error: (_) => true);

  bool isSuccess() => maybeWhen(orElse: () => false, success: (_) => true);
}
