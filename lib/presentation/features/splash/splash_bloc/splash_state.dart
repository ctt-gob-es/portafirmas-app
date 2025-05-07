
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

part of 'splash_bloc.dart';

/// The `SplashState` class represents the current state of the splash screen.
@freezed
class SplashState with _$SplashState {
  /// Creates an instance of `SplashState` representing an initial state.
  const factory SplashState.initial() = _Initial;

  /// Creates an instance of `SplashState` representing a splashed state.
  const factory SplashState.splashed({
    required bool welcomeTourIsFinished,
    required bool isFirstTime,
    @Default(false) bool isLogged,
  }) = _Splashed;
}

extension SplashStateExtension on SplashState {
  bool get isFirstTime =>
      when(initial: () => false, splashed: (_, isFirstTime, __) => isFirstTime);

  bool get isLogged =>
      when(initial: () => false, splashed: (_, __, isLogged) => isLogged);
}
