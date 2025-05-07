import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/constants/initial_servers.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/certificate_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/migration_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/servers_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/server/select_server_bloc/select_server_bloc.dart';

import '../../data/instruments/servers_instruments.dart';
import 'servers_bloc_test.mocks.dart';

@GenerateMocks([
  ServersRepositoryContract,
  MigrationRepositoryContract,
  CertificateRepositoryContract,
])
void main() {
  late MockServersRepositoryContract serversRepository;
  late MockMigrationRepositoryContract migrationRepository;
  late MockCertificateRepositoryContract certificateRepository;
  late SelectServerBloc bloc;

  setUp(() {
    serversRepository = MockServersRepositoryContract();
    migrationRepository = MockMigrationRepositoryContract();
    certificateRepository = MockCertificateRepositoryContract();
    bloc = SelectServerBloc(
      serversRepository: serversRepository,
      migrationRepository: migrationRepository,
      certificateRepository: certificateRepository,
      isFromInstallation: false,
    );
  });

  group('Pending requests', () {
    blocTest(
      'GIVEN servers bloc initial, WHEN select server, then change server selected',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        bloc.add(SelectServerEvent.selectServer(givenServerEntity()));
      },
      expect: () => [
        SelectServerState.initial()
            .copyWith(preSelectedServer: givenServerEntity()),
      ],
    );
  });
  group('Load servers', () {
    blocTest(
      'GIVEN servers bloc initial, WHEN load servers with null default server, then load servers',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.getServers())
            .thenAnswer((_) async => Result.success(givenServerEntityList()));

        when(serversRepository.getDefaultServer())
            .thenAnswer((_) async => const Result.success(null));

        when(serversRepository.getEmmServer()).thenAnswer(
          (_) async => const Result.success(null),
        );

        bloc.add(const SelectServerEvent.loadServers());
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, ...givenServerEntityList()],
        ),
      ],
    );

    blocTest(
      'GIVEN servers bloc initial, WHEN load servers with non null default server, then load servers',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.getServers())
            .thenAnswer((_) async => Result.success(givenServerEntityList()));

        when(serversRepository.getDefaultServer()).thenAnswer(
          (_) async => Result.success(givenServerEntityList().first.url),
        );

        when(serversRepository.getEmmServer()).thenAnswer(
          (_) async => const Result.success(null),
        );

        bloc.add(const SelectServerEvent.loadServers());
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: givenServerEntityList().first,
          selectedServerFinal: givenServerEntityList().first,
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, ...givenServerEntityList()],
        ),
      ],
    );

    blocTest(
      'GIVEN servers bloc initial, WHEN load servers with error, then emit error',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.getServers()).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));

        when(serversRepository.getDefaultServer()).thenAnswer(
          (_) async => Result.success(givenServerEntityList().first.url),
        );

        when(serversRepository.getEmmServer()).thenAnswer(
          (_) async => const Result.success(null),
        );

        bloc.add(const SelectServerEvent.loadServers());
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus:
              const ScreenStatus.error(RepositoryError.serverError()),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
      ],
    );
  });
  group('Set server default', () {
    blocTest(
      'GIVEN servers bloc initial, WHEN set server default, then set server default',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.setDefaultServer(any))
            .thenAnswer((_) async => const Result.success(null));

        bloc.add(const SelectServerEvent.setSelectedServerDefault());
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.loading(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: initialServers.first,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.success(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
      ],
    );
    blocTest(
      'GIVEN servers bloc initial, WHEN set server default with error, then error',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.setDefaultServer(any)).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));

        bloc.add(const SelectServerEvent.setSelectedServerDefault());
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.loading(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus:
              const ScreenStatus.error(RepositoryError.serverError()),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
      ],
    );
  });
  group('Add server', () {
    blocTest(
      'GIVEN servers bloc initial, WHEN add server, then add server',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.addServer(any, any))
            .thenAnswer((_) async => Result.success(givenServerEntity()));

        bloc.add(const SelectServerEvent.addServer(alias: 'alias', url: 'url'));
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, givenServerEntity()],
        ),
      ],
    );
    blocTest(
      'GIVEN servers bloc initial, WHEN add server with error, then error',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.addServer(any, any)).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));

        bloc.add(const SelectServerEvent.addServer(alias: 'alias', url: 'url'));
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus:
              const ScreenStatus.error(RepositoryError.serverError()),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
      ],
    );
  });
  group('Modify server', () {
    final initialState = SelectServerState.initial()
        .copyWith(servers: [...initialServers, givenServerEntity()]);
    blocTest(
      'GIVEN servers bloc initial, WHEN modify server, then modify server',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.modifyServer(any, any, any))
            .thenAnswer((_) async => Result.success(givenServerEntityNew()));

        bloc.emit(initialState);

        bloc.add(const SelectServerEvent.updateServer(
          dbIndex: 0,
          alias: 'alias',
          url: 'url',
        ));
      },
      expect: () => [
        initialState,
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, givenServerEntity()],
        ),
        SelectServerState(
          preSelectedServer: givenServerEntityNew(),
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, givenServerEntityNew()],
        ),
      ],
    );
    blocTest(
      'GIVEN servers bloc initial, WHEN modify server with error, then error',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.modifyServer(any, any, any)).thenAnswer(
          (_) async =>
              const Result.failure(error: RepositoryError.serverError()),
        );

        bloc.add(const SelectServerEvent.updateServer(
          dbIndex: 0,
          alias: 'alias',
          url: 'url',
        ));
      },
      expect: () => [
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus:
              const ScreenStatus.error(RepositoryError.serverError()),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
      ],
    );
  });

  group('Delete server', () {
    final initialState = SelectServerState.initial()
        .copyWith(servers: [...initialServers, givenServerEntity()]);
    blocTest(
      'GIVEN servers bloc initial, WHEN delete server, then delete server',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.deleteServer(
          any,
        )).thenAnswer((_) async => const Result.success(null));

        bloc.emit(initialState);

        bloc.add(const SelectServerEvent.deleteServer(0));
      },
      expect: () => [
        initialState,
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, givenServerEntity()],
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.success(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: initialServers,
        ),
      ],
    );
    blocTest(
      'GIVEN servers bloc initial, WHEN delete server with error, then error',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.deleteServer(
          any,
        )).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));

        bloc.emit(initialState);

        bloc.add(const SelectServerEvent.deleteServer(0));
      },
      expect: () => [
        initialState,
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.loading(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, givenServerEntity()],
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus:
              const ScreenStatus.error(RepositoryError.serverError()),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.initial(),
          servers: [...initialServers, givenServerEntity()],
        ),
      ],
    );
  });
  group('Migrate servers', () {
    final initialState = SelectServerState.initial();
    blocTest(
      'GIVEN servers bloc initial, WHEN migrate server, then migrate server',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.getServers())
            .thenAnswer((_) async => const Result.success([]));

        when(serversRepository.getDefaultServer())
            .thenAnswer((_) async => const Result.success(null));

        when(serversRepository.getServersMigrated())
            .thenAnswer((_) async => const Result.success(false));

        when(serversRepository.setServersMigrated())
            .thenAnswer((_) async => const Result.success(null));

        when(migrationRepository.migrateServers())
            .thenAnswer((_) async => const Result.success(null));

        when(migrationRepository.migrateDefaultCertificate())
            .thenAnswer((_) async => const Result.success(null));

        when(serversRepository.getEmmServer()).thenAnswer(
          (_) async => const Result.success(null),
        );

        bloc.emit(initialState);

        bloc.add(const SelectServerEvent.loadMigratedServers());
      },
      expect: () => [
        initialState,
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.loading(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.success(),
          servers: initialServers,
        ),
      ],
    );
    blocTest(
      'GIVEN servers bloc initial, WHEN delete server with error, then error',
      build: () => bloc,
      act: (SelectServerBloc bloc) {
        when(serversRepository.getServers())
            .thenAnswer((_) async => const Result.success([]));

        when(serversRepository.getDefaultServer())
            .thenAnswer((_) async => const Result.success(null));

        when(serversRepository.getDefaultServer())
            .thenAnswer((_) async => const Result.success(null));

        when(serversRepository.getServersMigrated())
            .thenAnswer((_) async => const Result.success(false));

        when(migrationRepository.migrateServers()).thenAnswer((_) async =>
            const Result.failure(error: RepositoryError.serverError()));

        when(migrationRepository.migrateDefaultCertificate())
            .thenAnswer((_) async => const Result.success(null));

        bloc.emit(initialState);

        bloc.add(const SelectServerEvent.loadMigratedServers());
      },
      expect: () => [
        initialState,
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus: const ScreenStatus.loading(),
          servers: initialServers,
        ),
        SelectServerState(
          preSelectedServer: initialServers.first,
          selectedServerFinal: null,
          serversDataStatus: const ScreenStatus.initial(),
          defaultServerStatus: const ScreenStatus.initial(),
          serversMigrationDataStatus:
              const ScreenStatus.error(RepositoryError.serverError()),
          servers: initialServers,
        ),
      ],
    );
  });
}
