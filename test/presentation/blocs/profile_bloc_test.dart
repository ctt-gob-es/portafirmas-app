import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/models/user_configuration.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/home/profile_bloc/profile_bloc.dart';

import '../instruments/requests_instruments.dart';
import 'profile_bloc_test.mocks.dart';

@GenerateMocks([RequestRepositoryContract])
void main() {
  late ProfileBloc profileBloc;
  late MockRequestRepositoryContract repository;

  setUp(() {
    repository = MockRequestRepositoryContract();
    profileBloc = ProfileBloc(repositoryContract: repository);
  });

  group('profile bloc test', () {
    blocTest(
      'GIVEN profile bloc, WHEN getProfileList event is called, THEN user profile roles will be loaded',
      build: () => profileBloc,
      act: (ProfileBloc bl) {
        when(repository.getUserRoles()).thenAnswer((_) async {
          return Result.success(UserConfiguration(
            proxyVersionUnder25: false,
            userRoles: givenUserRolesList(),
          ));
        });
        bl.add(const ProfileEvent.getProfileList());
      },
      expect: () => [
        ProfileState.initial()
            .copyWith(screenStatus: const ScreenStatus.loading()),
        ProfileState(
          profiles: givenUserRolesList(),
          selectedProfile: null,
          screenStatus: const ScreenStatus.success(),
          proxyVersionUnder25: false,
        ),
      ],
    );
    blocTest(
      'GIVEN profile bloc, WHEN profile selected event is called, THEN  profile will be selected in state',
      build: () => profileBloc,
      act: (ProfileBloc bl) {
        bl.emit(ProfileState(
          profiles: givenUserRolesList(),
          selectedProfile: null,
          screenStatus: const ScreenStatus.success(),
        ));
        bl.add(ProfileEvent.profileSelected(givenUserRolesList().first.dni));
      },
      expect: () => [
        ProfileState(
          profiles: givenUserRolesList(),
          selectedProfile: null,
          screenStatus: const ScreenStatus.success(),
        ),
        ProfileState(
          profiles: givenUserRolesList(),
          selectedProfile: givenUserRolesList().first,
          screenStatus: const ScreenStatus.success(),
        ),
      ],
    );
  });
}
