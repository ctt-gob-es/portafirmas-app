
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

// Part file that contains the generated code for the 'Result' class.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

part 'result.freezed.dart';

// Annotating the 'Result' class with '@freezed' to generate the necessary boilerplate code.
@freezed
class Result<T> with _$Result<T> {
  // Factory constructor for representing a failure.
  // Takes an instance of 'RepositoryError' as a required parameter.
  const factory Result.failure({required RepositoryError error}) = Failure<T>;

  // Factory constructor for representing a success.
  // Takes an instance of 'T' as the data.
  const factory Result.success(T data) = Success<T>;
}
