
/* Copyright (C) 2024 SGAD Secretaria General de Administración Digital, Ministerio para la Transformación Digital y de la Función Pública
 * This program is licensed and may be used, modified and redistributed under the terms of the European Public License (EUPL), either version 1.2 or (at your option) any later
 * version as soon as they are approved by the European Commission.
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
 * ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and more details.
 * You should have received a copy of the EUPL1.2 license along with this program; if not,
 * you may find it at http://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863
*/

import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';

class SignWithClaveScreen extends StatelessWidget {
  final String signUrl;
  const SignWithClaveScreen({super.key, required this.signUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AFTopSectionBar.action(
        themeComponent: AFThemeComponent.medium,
      ),
      body: InAppWebView(
        key: const Key('signWebViewKey'),
        initialUrlRequest: URLRequest(
          url: WebUri(signUrl),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
          maximumZoomScale: 1,
          clearCache: true,
          clearSessionCache: true,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url;

          //Signature with clave done successfully
          if (uri.toString().contains(WebViewLiterals.signSuccessUrl)) {
            if (GoRouter.of(context).location ==
                    RoutePath.detailSignWithClave ||
                GoRouter.of(context).location ==
                    RoutePath.requestsSignWithClave) {
              context.pop(true);
            }
          }

          //Error signing with clave
          if (uri.toString().contains(WebViewLiterals.koUrl) ||
              (uri.toString().contains(WebViewLiterals.errorUrl) &&
                  !uri.toString().contains(WebViewLiterals.transactionId))) {
            context.pop(false);
          }

          return NavigationActionPolicy.ALLOW;
        },
        onReceivedHttpError: (controller, request, errorResponse) {
          // Handle HTTP errors here
          context.pop(false);
        },
        onReceivedError: (controller, request, error) {
          context.pop(false);
        },
      ),
    );
  }
}
