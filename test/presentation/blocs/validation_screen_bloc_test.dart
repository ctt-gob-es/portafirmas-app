import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/repository_contracts/validation_list_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/settings/validation_screen/bloc/validation_screen_bloc.dart';

import '../../data/instruments/request_data_instruments.dart';
import 'validation_screen_bloc_test.mocks.dart';

@GenerateMocks([ValidatorListRepositoryContract])
void main() {
  late ValidationScreenBloc validationScreenBloc;
  late MockValidatorListRepositoryContract repository;

  setUp(() {
    repository = MockValidatorListRepositoryContract();
    validationScreenBloc = ValidationScreenBloc(repositoryContract: repository);
  });

  group('Validations bloc test', () {
    blocTest(
      'GIVEN Validation screen bloc, WHEN loadUsers is called, THEN validator users are loaded',
      build: () => validationScreenBloc,
      act: (ValidationScreenBloc bloc) {
        when(repository.getValidatorUserList()).thenAnswer((_) async {
          return Result.success(givenValidatorEntityList());
        });
        bloc.add(const ValidationScreenEvent.loadUsers());
      },
      wait: const Duration(milliseconds: 400),
      expect: () => [
        const ValidationScreenState(
          screenStatus: ScreenStatus.loading(),
          listOfValidatorUsers: [],
        ),
        ValidationScreenState(
          screenStatus: const ScreenStatus.success(),
          listOfValidatorUsers: givenValidatorEntityList(),
        ),
      ],
    );
    blocTest(
      'GIVEN Validation screen bloc, WHEN removeUser is called, THEN validator user is removed',
      build: () => validationScreenBloc,
      act: (ValidationScreenBloc bloc) {
        when(repository.getValidatorUserList()).thenAnswer((_) async {
          return Result.success(givenValidatorUser());
        });

        when(repository.removeValidatorUser(any)).thenAnswer((_) async {
          return const Result.success(true);
        });

        bloc.add(const ValidationScreenEvent.loadUsers());
        bloc.add(const ValidationScreenEvent.removeUser('1208'));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const ValidationScreenState(
          screenStatus: ScreenStatus.loading(),
          listOfValidatorUsers: [],
        ),
        const ValidationScreenState(
          screenStatus: ScreenStatus.success(),
          listOfValidatorUsers: [],
        ),
      ],
    );
    blocTest(
      'GIVEN Validation screen bloc, WHEN event is called, THEN state is initial',
      build: () => validationScreenBloc,
      act: (ValidationScreenBloc bloc) {
        bloc.add(const ValidationScreenEvent.refreshScreen());
      },
      expect: () => [
        const ValidationScreenState(
          screenStatus: ScreenStatus.initial(),
          listOfValidatorUsers: [],
        ),
      ],
    );
  });
}
