import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/authorizations_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/model/authorization_status.dart';

import '../../data/instruments/request_data_instruments.dart';
import 'authorization_screen_bloc_test.mocks.dart';

@GenerateMocks([AuthorizationsRepositoryContract])
void main() {
  late AuthorizationScreenBloc authorizationScreenBloc;
  late MockAuthorizationsRepositoryContract repository;

  setUp(() {
    repository = MockAuthorizationsRepositoryContract();
    authorizationScreenBloc =
        AuthorizationScreenBloc(repositoryContract: repository);
  });

  group('Authorization Screen bloc test', () {
    blocTest(
      'GIVEN authorization screen bloc, WHEN I call the event the authorizations send are loaded',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        when(repository.getAuthorizationsList()).thenAnswer((_) async {
          return Result.success(givenAuthorization());
        });
        bloc.add(const AuthorizationScreenEvent.loadAuthorizations());
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: givenAuthorization(),
          listOfAuthorizationsSend: givenAuthorization(),
          listOfAuthorizationsReceived: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
      ],
    );

    blocTest(
      'GIVEN bad request WHEN I call the event the authorizations THEN show me the Result.failure',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        when(repository.getAuthorizationsList()).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.badRequest());
        });
        bloc.add(const AuthorizationScreenEvent.loadAuthorizations());
      },
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.error(RepositoryError.badRequest()),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
      ],
    );

    blocTest(
      'GIVEN authorization screen bloc, WHEN I call the event I get an authorization',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        bloc.add(
          AuthorizationScreenEvent.getSelectedAuthorization(
            givenAuthDataList()[0],
          ),
        );
      },
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsReceived: [],
          listOfAuthorizationsSend: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: [],
          listOfAuthorizationsReceived: [],
          listOfAuthorizationsSend: [],
          authorization: givenAuthDataList()[0],
          newAuthorization: newUserEntity(),
        ),
      ],
    );

    blocTest(
      'GIVEN authorization screen bloc, WHEN I call the event I can not revoke an authorization',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        when(repository.revokeAuthorization(any, any)).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.serverError());
        });
        bloc.add(const AuthorizationScreenEvent.revokeAuthorization(AuthorizationStatus.revoked));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsReceived: [],
          listOfAuthorizationsSend: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.error(RepositoryError.serverError()),
          listOfAuthorizations: [],
          listOfAuthorizationsReceived: [],
          listOfAuthorizationsSend: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
      ],
    );

    blocTest(
      'GIVEN  bloc, WHEN I call the event I revoke an authorization sended',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        bloc.emit(bloc.state.copyWith(
          authorization: givenAuthorization()[0],
        ));

        when(repository.getAuthorizationsList()).thenAnswer((_) async {
          return Result.success(givenAuthorization());
        });
        when(repository.revokeAuthorization(any, any)).thenAnswer((_) async {
          return const Result.success(true);
        });

        bloc.add(const AuthorizationScreenEvent.loadAuthorizations());
        bloc.add(const AuthorizationScreenEvent.revokeAuthorization(AuthorizationStatus.revoked));
      },
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.initial(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          authorization: givenAuthorization()[0],
          listOfAuthorizationsReceived: [],
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: givenAuthorization()[0],
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: givenAuthorization(),
          listOfAuthorizationsSend: givenAuthorization(),
          listOfAuthorizationsReceived: [],
          newAuthorization: newUserEntity(),
          authorization: givenAuthorization()[0],
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: givenAuthorization(),
          listOfAuthorizationsSend: givenAuthorization(),
          listOfAuthorizationsReceived: [],
          newAuthorization: newUserEntity(),
          authorization: givenAuthorization()[0],
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: givenAuthorization(),
          listOfAuthorizationsSend: givenAuthorization(),
          listOfAuthorizationsReceived: [],
          authorization: givenAuthorization()[0],
          newAuthorization: newUserEntity(),
        ),
      ],
    );

    blocTest(
      'GIVEN  bloc, WHEN I call the event I accept an authorization received',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        bloc.emit(bloc.state.copyWith(
          authorization: givenAcceptedAuthReceived()[0],
        ));

        when(repository.getAuthorizationsList()).thenAnswer((_) async {
          return Result.success(givenAcceptedAuthReceived());
        });
        when(repository.acceptedAuthorization(any)).thenAnswer((_) async {
          return const Result.success(true);
        });

        bloc.add(const AuthorizationScreenEvent.loadAuthorizations());
        bloc.add(const AuthorizationScreenEvent.acceptAuthorization());
      },
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.initial(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          newAuthorization: newUserEntity(),
          authorization: givenAcceptedAuthReceived()[0],
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: givenAcceptedAuthReceived()[0],
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: givenAcceptedAuthReceived(),
          listOfAuthorizationsSend: givenAcceptedAuthReceived(),
          listOfAuthorizationsReceived: [],
          authorization: givenAcceptedAuthReceived()[0],
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: givenAcceptedAuthReceived(),
          listOfAuthorizationsSend: givenAcceptedAuthReceived(),
          listOfAuthorizationsReceived: [],
          authorization: givenAcceptedAuthReceived()[0],
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: givenAcceptedAuthReceived(),
          listOfAuthorizationsSend: givenAcceptedAuthReceived(),
          listOfAuthorizationsReceived: [],
          authorization: givenAcceptedAuthReceived()[0],
          newAuthorization: newUserEntity(),
        ),
      ],
    );

    blocTest(
      'GIVEN success state WHEN I call the event addAuthorization THEN get a ScreenStatus.success',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        bloc.add(
          AuthorizationScreenEvent.addAuthorization(newUserEntityTest()),
        );

        when(repository.addAuthorization(newUserEntityTest()))
            .thenAnswer((_) async {
          return const Result.success(true);
        });
      },
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsReceived: [],
          listOfAuthorizationsSend: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: null,
          newAuthorization: newUserEntityTest(),
        ),
      ],
    );

    blocTest(
      'GIVEN failure state WHEN I call the event addAuthorization THEN get a ScreenStatus.error',
      build: () => authorizationScreenBloc,
      act: (AuthorizationScreenBloc bloc) {
        bloc.add(
          AuthorizationScreenEvent.addAuthorization(newUserEntityTest()),
        );

        when(repository.addAuthorization(newUserEntityTest()))
            .thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.badRequest());
        });
      },
      expect: () => [
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.loading(),
          listOfAuthorizations: [],
          listOfAuthorizationsReceived: [],
          listOfAuthorizationsSend: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
        AuthorizationScreenState(
          screenStatus: const ScreenStatus.error(RepositoryError.badRequest()),
          listOfAuthorizations: [],
          listOfAuthorizationsSend: [],
          listOfAuthorizationsReceived: [],
          authorization: null,
          newAuthorization: newUserEntity(),
        ),
      ],
    );
  });
}
