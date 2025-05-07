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
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/domain/models/login_clave_entity.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';

class LoginClaveBodyScreen extends StatefulWidget {
  final LoginClaveEntity data;

  const LoginClaveBodyScreen({super.key, required this.data});

  @override
  State<LoginClaveBodyScreen> createState() => _LoginClaveBodyScreenState();
}

class _LoginClaveBodyScreenState extends State<LoginClaveBodyScreen> {
  late InAppWebViewController? webViewController;
  late CookieManager cookieManager;
  late int expiresDate;

  @override
  void initState() {
    super.initState();

    webViewController = InAppWebViewController.fromPlatform(
      platform: PlatformInAppWebViewController.static(),
    );
    webViewController?.platform.clearAllCache();
    cookieManager = CookieManager.instance();
    cookieManager.deleteAllCookies();

    expiresDate =
        DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        key: const Key('webViewKey'),
        initialUrlRequest: URLRequest(
          url: WebUri(widget.data.url),
          headers: widget.data.cookies,
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
          sharedCookiesEnabled: true,
          maximumZoomScale: 1,
          clearCache: true,
          clearSessionCache: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
          _addCookieToWebview(WebUri(widget.data.url));
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final uri = navigationAction.request.url;

          if (uri.toString().contains(WebViewLiterals.loginSuccessUrl)) {
            context.read<AuthBloc>().add(
                  AuthEvent.successLoginByClave(
                    nif: uri.toString().split('dni=')[1],
                    sessionId:
                        widget.data.cookies[WebViewLiterals.cookie] ?? '',
                  ),
                );
          }
          final uriString = uri.toString();

          if (uriString.contains(WebViewLiterals.koUrl) ||
              uriString.contains(WebViewLiterals.errorUrl)) {
            if (uriString.contains(WebViewLiterals.validationError)) {
              _showAuthorizationErrorLoginByClave(context, uriString);
            } else {
              _showServerErrorLoginByClave(context);
            }
          }

          return NavigationActionPolicy.ALLOW;
        },
        onReceivedError: (controller, request, error) {
          _showServerErrorLoginByClave(context);
        },
      ),
    );
  }

  void _showAuthorizationErrorLoginByClave(
    BuildContext context,
    String message,
  ) {
    context
        .read<AuthBloc>()
        .add(AuthEvent.errorLoginByClaveUnauthorizeServerAccess(message));
  }

  void _showServerErrorLoginByClave(BuildContext context) {
    context.read<AuthBloc>().add(
          const AuthEvent.errorLoginByClave(),
        );
  }

  void _addCookieToWebview(WebUri? url) async {
    await cookieManager.setCookie(
      url: url ?? WebUri(''),
      name: WebViewLiterals.sessionCookieName,
      value: widget.data.cookies[WebViewLiterals.cookie]?.split('=')[1] ?? '',
      expiresDate: expiresDate,
      isHttpOnly: true,
      isSecure: true,
    );
  }
}
