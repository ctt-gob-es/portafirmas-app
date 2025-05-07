
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this);
}

extension ContextExtensions on BuildContext {
  void openPage({required Widget page, String? routeName}) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(name: routeName),
        ),
      );

  /// Close the actual page
  void close() => Navigator.pop(this);

  /// Get the previous route
  String get previousRoute => GoRouter.of(this).location;

  /// Navigate to a location with the previous route as prefix
  void goWithRoute(String pageName, {Object? extra}) {
    final String previousRoute = this.previousRoute;
    final routePrefix = previousRoute == '/' ? '' : previousRoute;

    go('$routePrefix/$pageName', extra: extra);
  }
}
