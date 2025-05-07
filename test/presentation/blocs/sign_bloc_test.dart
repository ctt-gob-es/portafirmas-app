import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/types/result.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';
import 'package:portafirmas_app/domain/repository_contracts/request_repository_contract.dart';
import 'package:portafirmas_app/domain/repository_contracts/sign_repository_contract.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';

import '../instruments/requests_instruments.dart';
import 'sign_bloc_test.mocks.dart';

@GenerateMocks([RequestRepositoryContract, SignRepositoryContract])
void main() {
  late SignBloc signBloc;
  late MockRequestRepositoryContract requestRepositoryContract;
  late MockSignRepositoryContract signRepositoryContract;

  setUp(() {
    requestRepositoryContract = MockRequestRepositoryContract();
    signRepositoryContract = MockSignRepositoryContract();
    signBloc = SignBloc(
      repositoryContract: requestRepositoryContract,
      signRepositoryContract: signRepositoryContract,
    );
  });

  group('sign bloc test', () {
    group('revoke requests', () {
      blocTest(
        'GIVEN sign bloc, WHEN revokeRequests event is called, THEN screenStatus will succeed',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(requestRepositoryContract.revokeRequests(
            reason: '',
            requestIds: ['id'],
          )).thenAnswer((_) async {
            return Result.success(givenRevokedRequestEntityList());
          });

          bloc.add(const SignEvent.revokeRequests(requestIds: ['id']));
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          const SignState(
            action: ActionType.revoke,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          const SignState(
            action: ActionType.revoke,
            screenStatus: ScreenStatus.success(),
            isSingleRequest: true,
            rejectedReqsLength: 1,
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN revokeRequests event is called and there is an error, THEN screenStatus will be error()',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(requestRepositoryContract.revokeRequests(
            reason: '',
            requestIds: ['id'],
          )).thenAnswer((_) async {
            return const Result.failure(error: RepositoryError.serverError());
          });

          bloc.add(const SignEvent.revokeRequests(requestIds: ['id']));
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          const SignState(
            action: ActionType.revoke,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          const SignState(
            action: ActionType.revoke,
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
            isSingleRequest: true,
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN revokeRequests event is called and rejected status is KO, THEN screenStatus will be error()',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(requestRepositoryContract.revokeRequests(
            reason: '',
            requestIds: ['id'],
          )).thenAnswer((_) async {
            return Result.success(givenKORevokedRequestEntityList());
          });

          bloc.add(const SignEvent.revokeRequests(requestIds: ['id']));
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          const SignState(
            action: ActionType.revoke,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          const SignState(
            action: ActionType.revoke,
            screenStatus: ScreenStatus.error(),
            isSingleRequest: true,
          ),
        ],
      );
    });

    group('sign requests with certificate', () {
      blocTest(
        'GIVEN sign bloc, WHEN preSignRequests event is called and there is no error, THEN state will be success and signedReqs will be shown',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.getAuthMethod())
              .thenAnswer((_) async => const AuthMethod.certificate());
          when(signRepositoryContract.preSignWithCert(
            signReqs: givenSignRequestPetitionRemoteEntityList(),
          )).thenAnswer((_) async {
            return Result.success(givenPreSignReqEntityList());
          });
          when(signRepositoryContract.signWithCert(
            preSignedRequest: givenPreSignReqEntityList().first,
          )).thenAnswer((_) async {
            return Result.success(givenSignedRequest);
          });
          when(signRepositoryContract.postSignWithCert(
            signedReqs: givenSignRequestPostSignPetitionRemoteEntityList(),
          )).thenAnswer((_) async {
            return Result.success(givenPostSignReqEntityList());
          });

          bloc.add(SignEvent.preSignRequest(
            signRequests: givenDetailRequestEntityList(),
          ));
        },
        expect: () => [
          SignState.initial().copyWith(
            action: ActionType.signVb,
            screenStatus: const ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          SignState.initial().copyWith(
            action: ActionType.signVb,
            screenStatus: const ScreenStatus.success(),
            isSingleRequest: true,
            signedReqs: givenPostSignReqEntityList(),
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN preSignRequests event is called and preSign fails, THEN screenstatus will be error',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.getAuthMethod())
              .thenAnswer((_) async => const AuthMethod.certificate());
          when(signRepositoryContract.preSignWithCert(
            signReqs: givenSignRequestPetitionRemoteEntityList(),
          )).thenAnswer((_) async {
            return const Result.failure(error: RepositoryError.serverError());
          });

          bloc.add(SignEvent.preSignRequest(
            signRequests: givenDetailRequestEntityList(),
          ));
        },
        expect: () => [
          const SignState(
            action: ActionType.signVb,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          const SignState(
            action: ActionType.signVb,
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
            isSingleRequest: true,
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN preSignRequests event is called and sign fails, THEN screenstatus will be error',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.getAuthMethod())
              .thenAnswer((_) async => const AuthMethod.certificate());
          when(signRepositoryContract.preSignWithCert(
            signReqs: givenSignRequestPetitionRemoteEntityList(),
          )).thenAnswer((_) async {
            return Result.success(givenPreSignReqEntityList());
          });
          when(signRepositoryContract.signWithCert(
            preSignedRequest: givenPreSignReqEntityList().first,
          )).thenAnswer((_) async {
            return const Result.failure(error: RepositoryError.serverError());
          });
          when(signRepositoryContract.postSignWithCert(
            signedReqs: [],
          )).thenAnswer((_) async {
            return const Result.failure(error: RepositoryError.serverError());
          });

          bloc.add(SignEvent.preSignRequest(
            signRequests: givenDetailRequestEntityList(),
          ));
        },
        expect: () => [
          const SignState(
            action: ActionType.signVb,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          const SignState(
            action: ActionType.signVb,
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
            isSingleRequest: true,
          ),
        ],
      );
    });

    group('sign requests with clave', () {
      blocTest(
        'GIVEN sign bloc, WHEN preSignRequests with clave event is called and there is no error, THEN state will be success and signUrl will be shown',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.getAuthMethod())
              .thenAnswer((_) async => const AuthMethod.clave());
          when(signRepositoryContract.preSignWithClave(
            requestIds: ['requestId'],
          )).thenAnswer((_) async {
            return Result.success(givenPreSignClaveEntity);
          });
          when(signRepositoryContract.signWithCert(
            preSignedRequest: givenPreSignReqEntityList().first,
          )).thenAnswer((_) async {
            return Result.success(givenSignedRequest);
          });
          when(signRepositoryContract.postSignWithClave())
              .thenAnswer((_) async {
            return Result.success(givenPostSignClaveEntity);
          });

          bloc.add(SignEvent.preSignRequest(
            signRequests: givenDetailRequestEntityList(),
          ));
        },
        expect: () => [
          SignState.initial().copyWith(
            action: ActionType.signVb,
            screenStatus: const ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          SignState.initial().copyWith(
            action: ActionType.signVb,
            screenStatus: const ScreenStatus.success(),
            isSingleRequest: true,
            preSignedReqsWithClave: ['requestId'],
            signUrl: 'signUrl',
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN preSignRequests with clave event is called and preSign fails, THEN screenstatus will be error',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.getAuthMethod())
              .thenAnswer((_) async => const AuthMethod.clave());
          when(signRepositoryContract.preSignWithClave(
            requestIds: ['requestId'],
          )).thenAnswer((_) async {
            return const Result.failure(error: RepositoryError.serverError());
          });

          bloc.add(SignEvent.preSignRequest(
            signRequests: givenDetailRequestEntityList(),
          ));
        },
        expect: () => [
          const SignState(
            action: ActionType.signVb,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: true,
          ),
          const SignState(
            action: ActionType.signVb,
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
            isSingleRequest: true,
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN postSignRequest with clave event is called and post-sign fails, THEN screenstatus will be error',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.postSignWithClave())
              .thenAnswer((_) async {
            return const Result.failure(error: RepositoryError.serverError());
          });

          bloc.add(SignEvent.postSignRequest(
            signedReqs: [givenSignedRequest],
            signMethod: const AuthMethod.clave(),
          ));
        },
        expect: () => [
          const SignState(
            action: null,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: null,
          ),
          const SignState(
            action: null,
            screenStatus: ScreenStatus.error(RepositoryError.serverError()),
            isSingleRequest: null,
          ),
        ],
      );

      blocTest(
        'GIVEN sign bloc, WHEN postSignRequest with clave event is called and post-sign succeeds, THEN screenstatus will be success',
        build: () => signBloc,
        act: (SignBloc bloc) {
          when(signRepositoryContract.postSignWithClave())
              .thenAnswer((_) async {
            return Result.success(givenPostSignClaveEntity);
          });

          bloc.add(SignEvent.postSignRequest(
            signedReqs: [givenSignedRequest],
            signMethod: const AuthMethod.clave(),
          ));
        },
        expect: () => [
          const SignState(
            action: null,
            screenStatus: ScreenStatus.loading(),
            isSingleRequest: null,
          ),
          SignState(
            action: ActionType.signVb,
            screenStatus: const ScreenStatus.success(),
            isSingleRequest: true,
            signedReqs: givenPostSignReqEntityList(),
          ),
        ],
      );
    });

    blocTest(
      'GIVEN sign bloc, WHEN approveRequests event is called, THEN screenStatus will succeed',
      build: () => signBloc,
      act: (SignBloc bloc) {
        when(requestRepositoryContract.approveRequests(
          requestIds: ['id'],
        )).thenAnswer((_) async {
          return Result.success(givenApprovedRequestEntityList());
        });

        bloc.add(const SignEvent.approveReques(requestIds: ['id']));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const SignState(
          action: ActionType.signVb,
          screenStatus: ScreenStatus.loading(),
          isSingleRequest: true,
        ),
        SignState(
          action: ActionType.signVb,
          screenStatus: const ScreenStatus.success(),
          isSingleRequest: true,
          approvedReqs: givenApprovedRequestEntityList(),
        ),
      ],
    );

    blocTest(
      'GIVEN sign bloc, WHEN ApproveRequests event is called and there is an error, THEN screenStatus will be error()',
      build: () => signBloc,
      act: (SignBloc bloc) {
        when(requestRepositoryContract.approveRequests(
          requestIds: ['id'],
        )).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.serverError());
        });

        bloc.add(const SignEvent.approveReques(requestIds: ['id']));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const SignState(
          action: ActionType.signVb,
          screenStatus: ScreenStatus.loading(),
          isSingleRequest: true,
        ),
        const SignState(
          action: ActionType.signVb,
          screenStatus: ScreenStatus.error(),
          isSingleRequest: true,
        ),
      ],
    );
  });
  group('Validate Request', () {
    blocTest(
      'GIVEN sign bloc, WHEN validateRequests event is called, THEN screenStatus will succeed',
      build: () => signBloc,
      act: (SignBloc bloc) {
        when(requestRepositoryContract.validatePetition(id: ['id']))
            .thenAnswer((_) async {
          return Result.success(givenValidateRequestEntityList());
        });

        bloc.add(const SignEvent.validateRequests(requestIds: ['id']));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const SignState(
          action: ActionType.validate,
          screenStatus: ScreenStatus.loading(),
          isSingleRequest: true,
        ),
        const SignState(
          action: ActionType.validate,
          screenStatus: ScreenStatus.success(),
          isSingleRequest: true,
          validatedReqsLength: 1,
        ),
      ],
    );

    blocTest(
      'GIVEN sign bloc, WHEN validateRequests event is called and there is an error, THEN screenStatus will be error()',
      build: () => signBloc,
      act: (SignBloc bloc) {
        when(requestRepositoryContract.validatePetition(
          id: ['id'],
        )).thenAnswer((_) async {
          return const Result.failure(error: RepositoryError.serverError());
        });

        bloc.add(const SignEvent.validateRequests(requestIds: ['id']));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const SignState(
          action: ActionType.validate,
          screenStatus: ScreenStatus.loading(),
          isSingleRequest: true,
        ),
        const SignState(
          action: ActionType.validate,
          screenStatus: ScreenStatus.error(RepositoryError.serverError()),
          isSingleRequest: true,
        ),
      ],
    );
  });
}
