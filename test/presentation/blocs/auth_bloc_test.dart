import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/auth_status.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/models/result_login_certificate.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/models/login_clave_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/authentication_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/authentication/auth_bloc/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthenticationRepositoryContract, BuildContext])
void main() {
  late MockAuthenticationRepositoryContract mockRepositoryAuthContract;
  late MockBuildContext myContext;
  late AuthBloc authBloc;
  const loginClave = LoginClaveEntity(url: 'url', cookies: {});

  setUp(() {
    mockRepositoryAuthContract = MockAuthenticationRepositoryContract();
    myContext = MockBuildContext();
    authBloc = AuthBloc(
      repositoryContract: mockRepositoryAuthContract,
    );
  });

  blocTest(
    'GIVEN auth bloc in Android, WHEN we login user by cert success, then the user auth status is logged in',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(mockRepositoryAuthContract.loginWithDefaultCertificate()).thenAnswer(
        (_) async => const ResultLoginDefaultCertificate.success(''),
      );

      when(mockRepositoryAuthContract.setLastAuthMethod(any)).thenAnswer(
        (_) async => const Result.success(true),
      );

      bloc.add(const AuthEvent.signInByDefaultCertificateEvent());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus:
            UserAuthStatus.loggedIn(dni: '', loggedWithClave: false),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc in Android, WHEN we login user by cert with error, then the screen status is error',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(mockRepositoryAuthContract.loginWithDefaultCertificate()).thenAnswer(
        (_) async => const ResultLoginDefaultCertificate.failure(
          error: RepositoryError.serverError(),
        ),
      );

      bloc.add(const AuthEvent.signInByDefaultCertificateEvent());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.error(RepositoryError.serverError()),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc in Android, WHEN log out, THEN user session ends',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      when(mockRepositoryAuthContract.logOut(false))
          .thenAnswer((_) async => const Result.success(true));

      bloc.add(const AuthEvent.signOutEvent());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.initial(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  //Sign in with clave tests

  blocTest(
    'GIVEN auth bloc, WHEN login with clave succeed, THEN user status logged in',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.loginWithClave()).thenAnswer(
        (_) async => const Result.success(loginClave),
      );

      bloc.add(const AuthEvent.signInByClave());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.success(),
        userAuthStatus: UserAuthStatus.urlLoaded(
          loginData: loginClave,
        ),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc, WHEN login with clave fails, THEN user status will be error',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.loginWithClave()).thenAnswer(
        (_) async => const Result.failure(
          error: RepositoryError.serverError(),
        ),
      );

      bloc.add(const AuthEvent.signInByClave());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.error(RepositoryError.serverError()),
        userAuthStatus: UserAuthStatus.error(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.error(RepositoryError.serverError()),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc, WHEN successLoginByClave is called, THEN user status will be logged in',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.setLastAuthMethod(any)).thenAnswer(
        (_) async => const Result.success(true),
      );
      bloc.add(const AuthEvent.successLoginByClave(
        nif: 'nif',
        sessionId: 'sessionId',
      ));
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.success(),
        userAuthStatus:
            UserAuthStatus.loggedIn(dni: 'nif', loggedWithClave: true),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc, WHEN errorLoginByClave is called, THEN user auth status will be error and then unidentified',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      bloc.add(const AuthEvent.errorLoginByClave());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.initial(),
        userAuthStatus: UserAuthStatus.error(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.initial(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );
  blocTest(
    'GIVEN auth bloc, WHEN signInByCertificateEvent is called, THEN user auth status will be success and then unidentified',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.loginWithCertificate(myContext))
          .thenAnswer((_) async => const Result.success('data'));
      when(mockRepositoryAuthContract
              .setLastAuthMethod(const AuthMethod.certificate()))
          .thenAnswer((_) async => const Result.success(true));
      bloc.add(AuthEvent.signInByCertificateEvent(myContext));
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus:
            UserAuthStatus.loggedIn(dni: 'data', loggedWithClave: false),
        isWelcomeTourFinished: false,
      ),
    ],
  );
  blocTest(
    'GIVEN auth bloc, WHEN signInByCertificateEvent is called, THEN user auth status will be Failure',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.loginWithCertificate(myContext))
          .thenAnswer((_) async => const Result.failure(
                error: RepositoryError.invalidCertificate(),
              ));
      bloc.add(AuthEvent.signInByCertificateEvent(myContext));
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.error(RepositoryError.invalidCertificate()),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );
  blocTest(
    'GIVEN auth bloc, WHEN trySignInWithLastMethod is called, THEN user auth certificate result will be Success',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      bloc.add(AuthEvent.trySignInWithLastMethod(myContext));

      when(mockRepositoryAuthContract.getLastAuthMethod()).thenAnswer(
        (_) async => const Result.success(
          AuthMethod.certificate(),
        ),
      );
      when(mockRepositoryAuthContract.loginWithCertificate(myContext))
          .thenAnswer(
        (_) async => const Result.success(
          'data',
        ),
      );
      when(mockRepositoryAuthContract
              .setLastAuthMethod(const AuthMethod.certificate()))
          .thenAnswer((_) async => const Result.success(true));
      bloc.add(AuthEvent.signInByCertificateEvent(myContext));
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus:
            UserAuthStatus.loggedIn(dni: 'data', loggedWithClave: false),
        isWelcomeTourFinished: false,
      ),
    ],
  );
  blocTest(
    'GIVEN auth bloc, WHEN trySignInWithLastMethod is called, THEN user auth clave access result will be Success',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      bloc.add(AuthEvent.trySignInWithLastMethod(myContext));

      when(mockRepositoryAuthContract.getLastAuthMethod()).thenAnswer(
        (_) async => const Result.success(
          AuthMethod.clave(),
        ),
      );
      when(mockRepositoryAuthContract.loginWithClave()).thenAnswer(
        (_) async => const Result.success(
          loginClave,
        ),
      );
      when(mockRepositoryAuthContract
              .setLastAuthMethod(const AuthMethod.clave()))
          .thenAnswer((_) async => const Result.success(true));
      bloc.add(const AuthEvent.signInByClave());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.success(),
        userAuthStatus: UserAuthStatus.urlLoaded(
          loginData: loginClave,
        ),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.urlLoaded(
          loginData: loginClave,
        ),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.success(),
        userAuthStatus: UserAuthStatus.urlLoaded(
          loginData: loginClave,
        ),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc, WHEN trySignInWithLastMethod is called, THEN user auth null access result will be Error',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.getLastAuthMethod()).thenAnswer(
        (_) async => const Result.success(null),
      );
      bloc.add(AuthEvent.trySignInWithLastMethod(myContext));
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.error(null),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );
  blocTest(
    'GIVEN auth bloc, WHEN trySignInWithLastMethod is called, THEN user auth  access result will be Failure',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      when(mockRepositoryAuthContract.getLastAuthMethod()).thenAnswer(
        (_) async =>
            const Result.failure(error: RepositoryError.notFoundResource()),
      );
      bloc.add(AuthEvent.trySignInWithLastMethod(myContext));
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.loading(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
      const AuthState(
        screenStatus: ScreenStatus.error(RepositoryError.notFoundResource()),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc, WHEN setOnBoardingValue is called, THEN receive value of Onboarding',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      bloc.add(const AuthEvent.resetState());
    },
    expect: () => [
      const AuthState(
        screenStatus: ScreenStatus.initial(),
        userAuthStatus: UserAuthStatus.unidentified(),
        isWelcomeTourFinished: false,
      ),
    ],
  );

  blocTest(
    'GIVEN auth bloc, WHEN resetState is called, THEN state will be initial',
    build: () => authBloc,
    act: (AuthBloc bloc) {
      bloc.add(const AuthEvent.resetState());
    },
    expect: () => [AuthState.initial()],
  );
}
