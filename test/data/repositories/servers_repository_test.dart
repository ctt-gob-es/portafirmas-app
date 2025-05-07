import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/local/servers_local_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/server_remote_data_source_contract.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/data/repositories/servers_repository.dart';

import '../instruments/servers_instruments.dart';
import 'servers_repository_test.mocks.dart';

@GenerateMocks([
  ServersLocalDataSourceContract,
  ServerRemoteDataSourceContract,
])
void main() {
  late MockServersLocalDataSourceContract serversLocalDataSourceContract;
  late MockServerRemoteDataSourceContract serverRemoteDataSourceContract;

  late ServersRepository repository;

  setUp(() {
    serversLocalDataSourceContract = MockServersLocalDataSourceContract();
    serverRemoteDataSourceContract = MockServerRemoteDataSourceContract();

    repository = ServersRepository(
      serversLocalDataSourceContract,
      serverRemoteDataSourceContract,
    );
  });

  group('Get default server', () {
    test(
      'GIVEN server repository WHEN getDefaultServer call THEN return default server',
      () async {
        when(serversLocalDataSourceContract.getDefaultServer())
            .thenAnswer((_) => Future.value('Url'));

        final result = await repository.getDefaultServer();

        verify(serversLocalDataSourceContract.getDefaultServer()).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, 'Url'),
        );
      },
    );
    test(
      'GIVEN server repository WHEN getDefaultServer call with error THEN return error',
      () async {
        when(serversLocalDataSourceContract.getDefaultServer())
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.getDefaultServer();

        verify(serversLocalDataSourceContract.getDefaultServer()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('Set default server', () {
    test(
      'GIVEN server repository WHEN setDefaultServer call THEN return success',
      () async {
        when(serversLocalDataSourceContract.setDefaultServer(any))
            .thenAnswer((_) => Future.value());

        final result = await repository.setDefaultServer(givenServerEntity());

        verify(serversLocalDataSourceContract.setDefaultServer(any)).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (_) => DoNothingAction(),
        );
      },
    );
    test(
      'GIVEN server repository WHEN setDefaultServer call with error THEN return error',
      () async {
        when(serversLocalDataSourceContract.setDefaultServer(any))
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.setDefaultServer(givenServerEntity());

        verify(serversLocalDataSourceContract.setDefaultServer(any)).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('Add server', () {
    test(
      'GIVEN AddServer WHEN url server is valid THEN save server in local',
      () async {
        when(serverRemoteDataSourceContract.isAValidServer(
          url: anyNamed('url'),
        )).thenAnswer((realInvocation) async => true);
        when(serversLocalDataSourceContract.addServer(any, any))
            .thenAnswer((_) => Future.value(0));

        final result = await repository.addServer(
          'pre',
          'https://pre-portafirmas.redsara.es/pfmovil',
        );

        verify(serverRemoteDataSourceContract.isAValidServer(
          url: 'https://pre-portafirmas.redsara.es/pfmovil',
        )).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) {
            expect(data.alias, 'pre');
            expect(data.url, 'https://pre-portafirmas.redsara.es/pfmovil');
          },
        );
      },
    );
    test(
      'GIVEN AddServer WHEN url server is not valid THEN throws RepositoryError.badRequest',
      () async {
        when(serverRemoteDataSourceContract.isAValidServer(
          url: 'https://pre-portafirmas.redsara.es/pfmovil',
        )).thenAnswer((realInvocation) async => false);

        final result = await repository.addServer(
          'pre',
          'https://pre-portafirmas.redsara.es/pfmovil',
        );

        verify(serverRemoteDataSourceContract.isAValidServer(
          url: 'https://pre-portafirmas.redsara.es/pfmovil',
        )).called(1);

        result.when(
          failure: (error) => expect(error, const RepositoryError.badRequest()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );

    test(
      'GIVEN AddServer WHEN an unexpected error occurs THEN throws RepositoryError',
      () async {
        when(serverRemoteDataSourceContract.isAValidServer(
          url: anyNamed('url'),
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.addServer(
          'pre',
          'https://pre-portafirmas.redsara.es/pfmovil',
        );

        verify(serverRemoteDataSourceContract.isAValidServer(
          url: 'https://pre-portafirmas.redsara.es/pfmovil',
        )).called(1);

        result.when(
          failure: (error) => expect(error, isA<RepositoryError>()),
          success: (data) => fail('Should have returned an error result'),
        );
      },
    );
  });

  group('Get server list', () {
    test(
      'GIVEN server repository WHEN getServers call THEN return success',
      () async {
        when(serversLocalDataSourceContract.getServers())
            .thenAnswer((_) => Future.value(givenServerLocalEntityList()));

        final result = await repository.getServers();

        verify(serversLocalDataSourceContract.getServers()).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) => expect(data, givenServerEntityList()),
        );
      },
    );

    test(
      'GIVEN server repository WHEN getServers call with error THEN return error',
      () async {
        when(serversLocalDataSourceContract.getServers())
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.getServers();

        verify(serversLocalDataSourceContract.getServers()).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
  });

  group('Modify server', () {
    test(
      'GIVEN server repository WHEN modifyServer call THEN return success',
      () async {
        when(serverRemoteDataSourceContract.isAValidServer(
          url: anyNamed('url'),
        )).thenAnswer((_) async => true);
        when(serversLocalDataSourceContract.modifyServer(any, any, any))
            .thenAnswer((_) => Future.value(
                  // ignore: void_checks
                  givenServerLocalEntity(),
                ));

        final result = await repository.modifyServer(
          givenServerEntity().databaseIndex,
          givenServerEntity().alias,
          givenServerEntity().url,
        );

        verify(serverRemoteDataSourceContract.isAValidServer(
          url: givenServerEntity().url,
        )).called(1);
        verify(serversLocalDataSourceContract.modifyServer(
          any,
          any,
          any,
        )).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (data) {
            expect(data.databaseIndex, givenServerEntity().databaseIndex);
            expect(data.alias, givenServerEntity().alias);
            expect(data.url, givenServerEntity().url);
          },
        );
      },
    );

    test(
      'GIVEN server repository WHEN modifyServer call with error THEN return error',
      () async {
        when(serverRemoteDataSourceContract.isAValidServer(
          url: anyNamed('url'),
        )).thenAnswer((_) async => true);
        when(serversLocalDataSourceContract.modifyServer(any, any, any))
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.modifyServer(
          givenServerEntity().databaseIndex,
          givenServerEntity().alias,
          givenServerEntity().url,
        );

        verify(serverRemoteDataSourceContract.isAValidServer(
          url: givenServerEntity().url,
        )).called(1);
        verify(serversLocalDataSourceContract.modifyServer(
          any,
          any,
          any,
        )).called(1);

        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned an error result'),
        );
      },
    );
  });

  group('Delete server', () {
    test(
      'GIVEN server repository WHEN deleteServer call THEN return success',
      () async {
        when(serversLocalDataSourceContract.deleteServer(
          any,
        )).thenAnswer((_) => Future.value());

        final result = await repository.deleteServer(0);

        verify(serversLocalDataSourceContract.deleteServer(
          any,
        )).called(1);

        result.when(
          failure: (error) => fail('Should have returned a success result'),
          success: (_) => DoNothingAction(),
        );
      },
    );

    test(
      'GIVEN server repository WHEN deleteServer call with error THEN return error',
      () async {
        when(serversLocalDataSourceContract.deleteServer(
          any,
        )).thenThrow(Exception('Unexpected error'));

        final result = await repository.deleteServer(0);

        verify(serversLocalDataSourceContract.deleteServer(
          any,
        )).called(1);
        result.when(
          failure: (error) =>
              expect(error, const RepositoryError.serverError()),
          success: (data) => fail('Should have returned a error result'),
        );
      },
    );
    group('Get servers migrated', () {
      test(
        'GIVEN servers repository WHEN getServersMigrated call THEN return success with data',
        () async {
          when(serversLocalDataSourceContract.getServersMigrated())
              .thenAnswer((_) async => true);

          final result = await repository.getServersMigrated();

          verify(serversLocalDataSourceContract.getServersMigrated());

          result.when(
            failure: (error) => fail('Should have returned a success result'),
            success: (data) => expect(data, true),
          );
        },
      );

      test(
        'GIVEN servers repository WHEN getServersMigrated call with error THEN return failure',
        () async {
          when(serversLocalDataSourceContract.getServersMigrated())
              .thenThrow(Exception('Unexpected error'));

          final result = await repository.getServersMigrated();

          verify(serversLocalDataSourceContract.getServersMigrated());

          result.when(
            failure: (error) => expect(error, isA<RepositoryError>()),
            success: (data) => fail('Should have returned a failure result'),
          );
        },
      );
    });

    group('Set servers migrated', () {
      test(
        'GIVEN servers repository WHEN setServersMigrated call THEN return success',
        () async {
          when(serversLocalDataSourceContract.setServersMigrated())
              .thenAnswer((_) {
            return Future.value();
          });

          final result = await repository.setServersMigrated();

          verify(serversLocalDataSourceContract.setServersMigrated()).called(1);

          result.when(
            failure: (error) => fail('Should have returned a success result'),
            success: (_) => expect(true, true),
          );
        },
      );

      test(
        'GIVEN servers repository WHEN setServersMigrated call with error THEN return failure',
        () async {
          when(serversLocalDataSourceContract.setServersMigrated())
              .thenThrow(Exception('Unexpected error'));

          final result = await repository.setServersMigrated();

          verify(serversLocalDataSourceContract.setServersMigrated());

          result.when(
            failure: (error) => expect(error, isA<RepositoryError>()),
            success: (_) => fail('Should have returned a failure result'),
          );
        },
      );
    });
  });
}
