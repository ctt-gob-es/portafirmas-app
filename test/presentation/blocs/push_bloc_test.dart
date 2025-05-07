import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/domain/repository_contracts/push_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';

import 'push_bloc_test.mocks.dart';

@GenerateMocks(
  [PushRepositoryContract, FlutterSecureStorage],
  customMocks: [
    MockSpec<PushBloc>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
  ],
)
void main() {
  late PushBloc bloc;
  late MockPushRepositoryContract pushRepositoryContract;
  late MockFlutterSecureStorage secureStorage;

  setUp(() {
    pushRepositoryContract = MockPushRepositoryContract();
    secureStorage = MockFlutterSecureStorage();
    bloc = PushBloc(
      pushRepository: pushRepositoryContract,
      secureStorage: secureStorage,
    );
  });

  blocTest(
    'Initial PushState ',
    build: () => bloc,
    verify: (bloc) {
      expect(
        bloc.state,
        const PushState.idle(),
      );
    },
  );

  blocTest(
    'GIVEN PushBloc with notificationReceived state WHEN PushEvent.notificationReceived THEN state changes to hasNewNotification ',
    build: () => bloc,
    act: (bloc) {
      bloc.add(const PushEvent.notificationReceived(body: '', title: ''));
    },
    expect: () => [
      const PushState.hasNewNotification(title: '', body: ''),
    ],
  );

  blocTest(
    'GIVEN PushBloc WHEN PushEvent.muteNotifications THEN state changes to mutedNotifications',
    build: () => bloc,
    setUp: () {
      when(
        pushRepositoryContract.updatePush(status: false),
      ).thenAnswer(
        (_) async => const Result.success(true),
      );
    },
    act: (bloc) => bloc.add(const PushEvent.muteNotifications()),
    expect: () => [
      const PushState.mutedNotifications(),
    ],
  );
}
