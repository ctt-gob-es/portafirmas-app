import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/data/repositories/auth_repository.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';
import 'package:portafirmas_app/domain/repository_contracts/portafirmas_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/servers_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/splash/splash_bloc/splash_bloc.dart';

import 'splash_bloc_test.mocks.dart';

@GenerateMocks([
  PortafirmasRepositoryContract,
  AuthRepository,
  ServersRepositoryContract,
])
void main() {
  late MockPortafirmasRepositoryContract portafirmasRepo;
  late MockAuthRepository authRepo;
  late MockServersRepositoryContract serversRepo;
  late SplashBloc bloc;

  setUp(() {
    portafirmasRepo = MockPortafirmasRepositoryContract();
    authRepo = MockAuthRepository();
    serversRepo = MockServersRepositoryContract();
    bloc = SplashBloc(
      portafirmasRepositoryContract: portafirmasRepo,
      authRepository: authRepo,
      serversRepositoryContract: serversRepo,
    );
  });

  blocTest(
    'GIVEN a SplashBloc WHEN unSplashInNMilliseconds event is called THEN splashed state must show welcomeTour true and isFirstTime false',
    setUp: () {
      when(portafirmasRepo.getWelcomeTourIsFinish())
          .thenAnswer((_) async => const Result.success(true));
      when(authRepo.isUserFirstTime())
          .thenAnswer((_) async => const Result.success(false));
      when(authRepo.getLastAuthMethod())
          .thenAnswer((_) async => const Result.success(null));
      when(authRepo.setFirstTime())
          .thenAnswer((_) async => const Result.success(true));
    },
    build: () => bloc,
    act: (SplashBloc bloc) {
      bloc.add(const SplashEvent.unSplashInNMilliseconds(0));
    },
    wait: const Duration(milliseconds: 10), // Agrega un pequeño delay
    expect: () => [
      const SplashState.splashed(
        welcomeTourIsFinished: true,
        isFirstTime: false,
        isLogged: false,
      ),
    ],
  );

  blocTest<SplashBloc, SplashState>(
    'GIVEN a SplashBloc WHEN unSplashInNMilliseconds event is called THEN splashed state must show welcomeTour false and isFirstTime true',
    build: () => bloc,
    setUp: () {
      when(portafirmasRepo.getWelcomeTourIsFinish()).thenAnswer(
        (_) async => const Result.success(false),
      );
      when(authRepo.isUserFirstTime()).thenAnswer(
        (_) async => const Result.success(true),
      );
      when(authRepo.getLastAuthMethod()).thenAnswer(
        (_) async => const Result.success(null),
      );
      when(authRepo.setFirstTime()).thenAnswer(
        (_) async => const Result.success(true),
      );
    },
    wait: const Duration(milliseconds: 10), // Agrega un pequeño delay
    act: (bloc) {
      bloc.add(const SplashEvent.unSplashInNMilliseconds(0));
    },

    expect: () => [
      const SplashState.splashed(
        welcomeTourIsFinished: false,
        isFirstTime: true,
        isLogged: false,
      ),
    ],
  );

  blocTest<SplashBloc, SplashState>(
    'when getLastAuthMethod fails, isLogged must be false',
    build: () => bloc,
    setUp: () {
      when(portafirmasRepo.getWelcomeTourIsFinish()).thenAnswer(
        (_) async => const Result.success(false),
      );
      when(authRepo.isUserFirstTime()).thenAnswer(
        (_) async => const Result.success(true),
      );
      when(authRepo.getLastAuthMethod()).thenAnswer(
        (_) async =>
            const Result.failure(error: RepositoryError.unknownError()),
      );
      when(authRepo.setFirstTime()).thenAnswer(
        (_) async => const Result.success(true),
      );
    },
    wait: const Duration(milliseconds: 10), // Agrega un pequeño delay
    act: (bloc) {
      bloc.add(const SplashEvent.unSplashInNMilliseconds(0));
    },

    expect: () => [
      const SplashState.splashed(
        welcomeTourIsFinished: false,
        isFirstTime: true,
        isLogged: false,
      ),
    ],
  );

  blocTest<SplashBloc, SplashState>(
    'when getLastAuthMethod has data and previously selected server is not available, isLogged must be false',
    build: () => bloc,
    setUp: () {
      when(portafirmasRepo.getWelcomeTourIsFinish()).thenAnswer(
        (_) async => const Result.success(true),
      );
      when(authRepo.isUserFirstTime()).thenAnswer(
        (_) async => const Result.success(false),
      );
      when(authRepo.getLastAuthMethod()).thenAnswer(
        (_) async => const Result.success(AuthMethod.certificate()),
      );
      when(authRepo.setFirstTime()).thenAnswer(
        (_) async => const Result.success(true),
      );
      when(serversRepo.getDefaultServer()).thenAnswer(
        (_) async => const Result.success('server'),
      );
      when(serversRepo.getEmmServer()).thenAnswer(
        (_) async => Result.success(
          ServerEntity(
            databaseIndex: 10000,
            alias: 'alias',
            url: 'anotherServer',
            isFromEmm: true,
          ),
        ),
      );
      when(serversRepo.getServers()).thenAnswer(
        (_) async => const Result.success([]),
      );
      when(authRepo.logOut(false))
          .thenAnswer((_) async => const Result.success(true));
    },
    wait: const Duration(milliseconds: 10), // Agrega un pequeño delay
    act: (bloc) {
      bloc.add(const SplashEvent.unSplashInNMilliseconds(0));
    },

    expect: () => [
      const SplashState.splashed(
        welcomeTourIsFinished: true,
        isFirstTime: false,
        isLogged: false,
      ),
    ],
  );
}
