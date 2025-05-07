import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:portafirmas_app/domain/repository_contracts/portafirmas_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/onboarding/bloc/bloc/onboarding_bloc.dart';
import 'onboarding_bloc_test.mocks.dart';

@GenerateMocks([PortafirmasRepositoryContract])
void main() {
  late OnBoardingBloc onboardingBloc;
  late MockPortafirmasRepositoryContract repositoryContract;

  setUp(() {
    repositoryContract = MockPortafirmasRepositoryContract();
    onboardingBloc = OnBoardingBloc(repositoryContract: repositoryContract);
  });

  group('on boarding bloc test', () {
    blocTest(
      'GIVEN on boarding bloc, WHEN updatePage event is called with newPage = 1, THEN currentPosition will be 1',
      build: () => onboardingBloc,
      act: (OnBoardingBloc bloc) {
        bloc.add(const OnBoardingEvent.updatePage(newPage: 1));
      },
      expect: () => [
        const OnBoardingState(currentPosition: 1),
      ],
    );
  });
}
