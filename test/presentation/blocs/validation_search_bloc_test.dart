import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/constants/literals.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/settings/bloc/users_search/users_search_bloc.dart';

import '../../data/instruments/request_data_instruments.dart';
import 'validation_search_bloc_test.mocks.dart';

@GenerateMocks([ValidatorListRepositoryContract, RequestRepositoryContract])
void main() {
  late UsersSearchBloc validationSearchBloc;
  late MockValidatorListRepositoryContract validatorRepository;
  late MockRequestRepositoryContract requestRepositoryContract;

  setUp(() {
    validatorRepository = MockValidatorListRepositoryContract();
    requestRepositoryContract = MockRequestRepositoryContract();
    validationSearchBloc = UsersSearchBloc(
      repositoryContract: requestRepositoryContract,
      listRepositoryContract: validatorRepository,
    );
  });

  group('Validator search bloc test', () {
    blocTest(
      'GIVEN Validation search bloc, WHEN event is called, THEN validator users are loaded if text matches ',
      build: () => validationSearchBloc,
      act: (UsersSearchBloc bloc) {
        when(requestRepositoryContract.getUserBySearch(
          prueba,
          ValidatorAuthorization.validator,
        )).thenAnswer((_) async {
          return Result.success(givenValidatorUserBySearch());
        });

        bloc.add(const UsersSearchEvent.searchTextChanged(
          prueba,
          ValidatorAuthorization.validator,
        ));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const UsersSearchState(
          screenStatus: ScreenStatus.loading(),
          suggestedUsers: [],
          selectedUser: null,
          isButtonEnabled: false,
          numberOfResults: 0,
          isUserAdded: false,
        ),
        UsersSearchState(
          screenStatus: const ScreenStatus.success(),
          suggestedUsers: givenValidatorUserBySearch(),
          numberOfResults: givenValidatorUserBySearch().length,
          isButtonEnabled: false,
          isUserAdded: false,
          selectedUser: null,
        ),
      ],
    );

    blocTest(
      'GIVEN Validation search bloc, WHEN event is called, THEN shows error if there is no matching ',
      build: () => validationSearchBloc,
      act: (UsersSearchBloc bloc) {
        when(requestRepositoryContract.getUserBySearch(
          id,
          ValidatorAuthorization.validator,
        )).thenAnswer((_) async {
          return Result.success(givenValidatorUserBySearch());
        });

        bloc.add(const UsersSearchEvent.searchTextChanged(
          id,
          ValidatorAuthorization.validator,
        ));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const UsersSearchState(
          screenStatus: ScreenStatus.loading(),
          suggestedUsers: [],
          selectedUser: null,
          isButtonEnabled: false,
          numberOfResults: 0,
          isUserAdded: false,
        ),
        const UsersSearchState(
          screenStatus: ScreenStatus.success(),
          suggestedUsers: [],
          numberOfResults: 0,
          isButtonEnabled: false,
          isUserAdded: false,
          selectedUser: null,
        ),
      ],
    );

    blocTest(
      'GIVEN Validation search bloc, WHEN event is called, THEN user is selected ',
      build: () => validationSearchBloc,
      act: (UsersSearchBloc bloc) {
        bloc.add(const UsersSearchEvent.selectedUser(validator));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const UsersSearchState(
          screenStatus: ScreenStatus.success(),
          selectedUser: validator,
          isButtonEnabled: true,
          isUserAdded: false,
          numberOfResults: 0,
          suggestedUsers: [],
        ),
      ],
    );

    blocTest(
      'GIVEN Validation search bloc, WHEN event is called, THEN I can add a validator',
      build: () => validationSearchBloc,
      act: (UsersSearchBloc bloc) {
        when(validatorRepository.addValidatorUser(
          validator.dni,
          validator.id,
          validator.name,
        )).thenAnswer((_) async {
          return const Result.success(true);
        });

        bloc.add(const UsersSearchEvent.handleValidator(validator));
      },
      expect: () => [
        const UsersSearchState(
          isButtonEnabled: false,
          screenStatus: ScreenStatus.success(),
          isUserAdded: true,
          numberOfResults: 0,
          selectedUser: null,
          suggestedUsers: [],
        ),
      ],
    );

    blocTest(
      'GIVEN Validation search bloc, WHEN event is called, THEN I can not add a validator',
      build: () => validationSearchBloc,
      act: (UsersSearchBloc bloc) {
        when(validatorRepository.addValidatorUser(
          validator.dni,
          validator.id,
          validator.name,
        )).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.serverError());
        });

        bloc.add(const UsersSearchEvent.handleValidator(validator));
      },
      expect: () => [
        const UsersSearchState(
          isButtonEnabled: false,
          screenStatus: ScreenStatus.error(RepositoryError.serverError()),
          isUserAdded: false,
          numberOfResults: 0,
          selectedUser: null,
          suggestedUsers: [],
        ),
      ],
    );

    blocTest(
      'GIVEN Validation search bloc, WHEN event is called, THEN clear search and return to initial state ',
      build: () => validationSearchBloc,
      act: (UsersSearchBloc bloc) {
        when(requestRepositoryContract.getUserBySearch(
          givenValidatorUserBySearch()[0].id,
          ValidatorAuthorization.validator,
        )).thenAnswer((_) async {
          return Result.success(givenValidatorUserBySearch());
        });

        bloc.add(const UsersSearchEvent.clearResults());
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const UsersSearchState(
          screenStatus: ScreenStatus.initial(),
          suggestedUsers: [],
          selectedUser: null,
          isButtonEnabled: false,
          numberOfResults: 0,
          isUserAdded: false,
        ),
      ],
    );
  });
}
