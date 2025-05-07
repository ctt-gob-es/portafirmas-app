import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/extensions/reject_status_extensions.dart';
import 'package:portafirmas_app/app/routes/app_paths.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/reject_status.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/detail/detail_request_screen.dart';
import 'package:portafirmas_app/presentation/features/filters/filters_screen.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/order_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_type_filter.dart';
import 'package:portafirmas_app/presentation/features/filters/models/time_interval_filter.dart';
import 'package:portafirmas_app/presentation/features/home/model/request_filters.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/request_status.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_screen.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_card.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/request_list.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/header_pending_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/header_rejected_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/header_signed_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/pending_requests_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/rejected_requests_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/signer/signed_requests_section.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/validator/header_validated_requests.dart';
import 'package:portafirmas_app/presentation/features/home/widgets/validator/validated_requests_section.dart';
import 'package:portafirmas_app/presentation/features/push/bloc/push_bloc.dart';
import 'package:portafirmas_app/presentation/features/settings/authorization_screen/bloc/authorization_screen_bloc.dart';
import 'package:portafirmas_app/presentation/widget/loading_component.dart';

import '../../../data/instruments/request_data_instruments.dart';
import '../../instruments/pump_app.dart';
import '../../instruments/requests_instruments.dart';
import 'requests_screen_test.mocks.dart';

@GenerateMocks([
  RequestsBloc,
  DetailRequestBloc,
  GoRouter,
  PushBloc,
  AuthorizationScreenBloc,
  MultiSelectionRequestBloc,
])
void main() {
  late MockRequestsBloc bloc;
  late MockDetailRequestBloc detailRequestBloc;
  late MockAuthorizationScreenBloc authorizationBloc;
  late MockGoRouter mockGoRouter;
  late MockPushBloc mockPushBloc;
  late MockMultiSelectionRequestBloc multiSelection;

  setUp(() {
    bloc = MockRequestsBloc();
    detailRequestBloc = MockDetailRequestBloc();
    authorizationBloc = MockAuthorizationScreenBloc();
    mockGoRouter = MockGoRouter();
    mockPushBloc = MockPushBloc();
    multiSelection = MockMultiSelectionRequestBloc();

    when(mockPushBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockPushBloc.state)
        .thenAnswer((realInvocation) => const PushState.idle());
  });

  group('Requests screen test', () {
    testWidgets(
      'GIVEN Requests screen WHEN profile is signer THEN load three tabs',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(bloc.state).thenAnswer(
          (_) => RequestsState(
            hasValidators: false,
            isSigner: true,
            filters: RequestFilters.initial(),
            pendingRequestsStatus: givenInitialStatusWithRequests,
            signedRequestsStatus: givenInitialStatusWithRequests,
            rejectedRequestsStatus: givenInitialStatusWithRequests,
            validatedRequestsStatus: givenInitialStatusWithRequests,
            filtersActive: false,
          ),
        );
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelection.state).thenAnswer(
          (_) => MultiSelectionRequestState.initial().copyWith(
            isButtonEnabled: false,
            isSelected: false,
            selectedRequests: {},
            showCheckbox: false,
          ),
        );
        when(detailRequestBloc.state)
            .thenAnswer((realInvocation) => DetailRequestState.initial());
        when(mockGoRouter.push(
          RoutePath.detailRequest,
          extra: RequestStatus.pending,
        )).thenAnswer(
          (realInvocation) async => const DetailRequestScreen(
            requestStatus: RequestStatus.pending,
          ),
        );
        when(authorizationBloc.state).thenAnswer(
          (_) => AuthorizationScreenState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            listOfAuthorizations: givenAuthDataList(),
            listOfAuthorizationsSend: givenAuthDataSendList(),
            listOfAuthorizationsReceived: givenAuthDataReceivedList(),
          ),
        );

        await widgetTester.pumpApp(
          const RequestsScreen(
            isSigner: true,
          ),
          providers: [
            BlocProvider<RequestsBloc>.value(value: bloc),
            BlocProvider<DetailRequestBloc>.value(value: detailRequestBloc),
            BlocProvider<PushBloc>.value(value: mockPushBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: multiSelection,
            ),
          ],
          router: mockGoRouter,
        );

        expect(find.byType(PendingRequestsSection), findsOneWidget);
        await widgetTester.tap(find.byType(RequestCard).first);

        verify(mockGoRouter.push(
          RoutePath.detailRequest,
          extra: RequestStatus.pending,
        )).called(1);
      },
    );

    testWidgets(
      'GIVEN Requests screen WHEN press filter icon THEN open filter screen',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(bloc.state).thenAnswer(
          (_) => RequestsState.initial().copyWith(isSigner: true),
        );
        when(mockGoRouter.go(
          RoutePath.filtersScreen,
          extra: givenFilterInitData,
        )).thenAnswer(
          (realInvocation) => FiltersScreen(
            initData: givenFilterInitData,
          ),
        );
        when(authorizationBloc.state).thenAnswer(
          (_) => AuthorizationScreenState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            listOfAuthorizations: givenAuthDataList(),
            listOfAuthorizationsSend: givenAuthDataSendList(),
            listOfAuthorizationsReceived: givenAuthDataReceivedList(),
          ),
        );
        when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelection.state).thenAnswer(
          (_) => MultiSelectionRequestState.initial().copyWith(
            isButtonEnabled: false,
            isSelected: false,
            selectedRequests: {},
            showCheckbox: false,
          ),
        );

        late BuildContext myContext;
        await widgetTester.pumpApp(
          const RequestsScreen(
            isSigner: true,
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<RequestsBloc>.value(value: bloc),
            BlocProvider<PushBloc>.value(value: mockPushBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: multiSelection,
            ),
          ],
          router: mockGoRouter,
        );

        // await widgetTester.pumpAndSettle();

        await widgetTester
            .tap(find.bySemanticsLabel(myContext.localizations.filters_title));
        // await widgetTester.pumpAndSettle();

        verify(mockGoRouter.go(
          RoutePath.filtersScreen,
          extra: givenFilterInitData,
        )).called(1);
      },
    );

    testWidgets(
      'GIVEN Requests screen WHEN profile is validator THEN load two tabs',
      (widgetTester) async {
        when(bloc.stream).thenAnswer((_) => const Stream.empty());
        when(authorizationBloc.stream).thenAnswer((_) => const Stream.empty());
        when(bloc.state).thenAnswer(
          (_) => RequestsState(
            hasValidators: false,
            isSigner: false,
            filters: RequestFilters.initial(),
            pendingRequestsStatus: givenInitialStatusWithRequests,
            signedRequestsStatus: givenInitialStatusWithRequests,
            rejectedRequestsStatus: givenInitialStatusWithRequests,
            validatedRequestsStatus: givenInitialStatusWithRequests,
            filtersActive: false,
          ),
        );
        when(authorizationBloc.state).thenAnswer(
          (_) => AuthorizationScreenState.initial().copyWith(
            screenStatus: const ScreenStatus.success(),
            listOfAuthorizations: givenAuthDataList(),
            listOfAuthorizationsSend: givenAuthDataSendList(),
            listOfAuthorizationsReceived: givenAuthDataReceivedList(),
          ),
        );
        when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelection.state).thenAnswer(
          (_) => MultiSelectionRequestState.initial().copyWith(
            isButtonEnabled: false,
            isSelected: false,
            selectedRequests: {},
            showCheckbox: false,
          ),
        );

        late BuildContext myContext;
        await widgetTester.pumpApp(
          const RequestsScreen(
            isSigner: false,
          ),
          onGetContext: (context) => myContext = context,
          providers: [
            BlocProvider<RequestsBloc>.value(value: bloc),
            BlocProvider<PushBloc>.value(value: mockPushBloc),
            BlocProvider<AuthorizationScreenBloc>.value(
              value: authorizationBloc,
            ),
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: multiSelection,
            ),
          ],
        );

        expect(
          find.text(myContext.localizations.validated_tab_text),
          findsOneWidget,
        );
        expect(
          find.text(myContext.localizations.pending_tab_text),
          findsOneWidget,
        );
      },
    );
  });

  group('Sections testing', () {
    group('Pending section tests', () {
      testWidgets(
        'GIVEN Pending requests section WHEN request list not empty THEN show requests',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState(
              hasValidators: false,
              filters: RequestFilters.initial(),
              isSigner: false,
              validatedRequestsStatus: givenInitialStatusWithRequests,
              pendingRequestsStatus: givenInitialStatusWithRequests,
              signedRequestsStatus: givenInitialStatusWithRequests,
              rejectedRequestsStatus: givenInitialStatusWithRequests,
              filtersActive: false,
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );

          await widgetTester.pumpApp(
            const PendingRequestsSection(
              isSigner: true,
            ),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(RequestList), findsOneWidget);
          expect(find.byType(LoadingComponent), findsNothing);
          expect(find.byType(FloatingActionButton), findsOneWidget);
        },
      );

      testWidgets(
        'GIVEN Pending requests section WHEN request list empty with validators THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: true,
              filters: RequestFilters.initialWithValidators(),
              pendingRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const PendingRequestsSection(
              isSigner: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(
            find.text(myContext
                .localizations.empty_pending_request_with_validator_title),
            findsOneWidget,
          );

          expect(
            find.text(
              myContext.localizations.empty_pending_request_normal_subtitle,
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'GIVEN Pending requests section WHEN request list empty with no validators THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: false,
              filters: RequestFilters.initial(),
              pendingRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const PendingRequestsSection(
              isSigner: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(
            find.text(
              myContext.localizations.empty_pending_request_normal_title,
            ),
            findsOneWidget,
          );

          expect(
            find.text(
              myContext.localizations.empty_pending_request_normal_subtitle,
            ),
            findsOneWidget,
          );
        },
      );
    });

    group('Signed section tests', () {
      testWidgets(
        'GIVEN Signed requests section WHEN request list not empty THEN show requests',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState(
              hasValidators: false,
              filters: RequestFilters.initial(),
              isSigner: true,
              validatedRequestsStatus: givenInitialStatusWithRequests,
              pendingRequestsStatus: givenInitialStatusWithRequests,
              signedRequestsStatus: givenInitialStatusWithRequests,
              rejectedRequestsStatus: givenInitialStatusWithRequests,
              filtersActive: false,
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );

          await widgetTester.pumpApp(
            const SignedRequestsSection(),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(RequestList), findsOneWidget);
          expect(find.byType(LoadingComponent), findsNothing);
        },
      );

      testWidgets(
        'GIVEN Signed requests section WHEN request list empty with filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: true,
              filters: givenFiltersNotInitial,
              signedRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const SignedRequestsSection(),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations
                .empty_signed_rejected_request_with_filters_title),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'GIVEN Signed requests section WHEN request list empty with no filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: false,
              signedRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const SignedRequestsSection(),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations.empty_signed_request_title),
            findsOneWidget,
          );
        },
      );
    });

    group('Validated section test', () {
      testWidgets(
        'GIVEN Validated requests section WHEN request list not empty THEN show requests',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState(
              hasValidators: true,
              filters: RequestFilters.initial(),
              isSigner: false,
              validatedRequestsStatus: givenInitialStatusWithRequests,
              pendingRequestsStatus: givenInitialStatusWithRequests,
              signedRequestsStatus: givenInitialStatusWithRequests,
              rejectedRequestsStatus: givenInitialStatusWithRequests,
              filtersActive: false,
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );

          await widgetTester.pumpApp(
            const ValidatedRequestsSection(),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(RequestList), findsOneWidget);
          expect(find.byType(LoadingComponent), findsNothing);
        },
      );

      testWidgets(
        'GIVEN Validated requests section WHEN request list empty with no filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: true,
              validatedRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const ValidatedRequestsSection(),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations.empty_validated_request_title),
            findsOneWidget,
          );
        },
      );
    });

    group('Rejected section tests', () {
      testWidgets(
        'GIVEN Rejected requests section WHEN request list not empty THEN show requests',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState(
              hasValidators: false,
              filters: RequestFilters.initial(),
              isSigner: true,
              validatedRequestsStatus: givenInitialStatusWithRequests,
              pendingRequestsStatus: givenInitialStatusWithRequests,
              signedRequestsStatus: givenInitialStatusWithRequests,
              rejectedRequestsStatus: givenInitialStatusWithRequests,
              filtersActive: false,
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );

          await widgetTester.pumpApp(
            const RejectedRequestsSection(isSigner: true,),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(RequestList), findsOneWidget);
          expect(find.byType(LoadingComponent), findsNothing);
        },
      );

      testWidgets(
        'GIVEN Rejected requests section WHEN request list empty with filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: true,
              filters: givenFiltersNotInitial,
              rejectedRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const RejectedRequestsSection(isSigner: true,),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations
                .empty_signed_rejected_request_with_filters_title),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'GIVEN Rejected requests section WHEN request list empty with no filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: false,
              rejectedRequestsStatus: const RequestsStatus(
                requestsCount: 0,
                requests: [],
                screenStatus: ScreenStatus.success(),
              ),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const RejectedRequestsSection(isSigner: true,),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations.empty_rejected_request_title),
            findsOneWidget,
          );
        },
      );
    });
  });

  group('Headers tests', () {
    group('Pending requests header test', () {
      testWidgets(
        'GIVEN Pending requests header WHEN has validators THEN show the tip',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              hasValidators: true,
              isSigner: true,
              filters: RequestFilters.initialWithValidators(),
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );
          await widgetTester.pumpApp(
            HeaderPendingRequests(
              requestExpiresToday: const [],
              requestCount: 10,
              onTapRequest: (_) => DoNothingAction(),
              hasFilters: false,
              isValidatorProfile: false,
            ),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(AFTip), findsOneWidget);
        },
      );
      testWidgets(
        'GIVEN Pending requests header WHEN has not validators THEN not show the tip',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial(),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());

          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );
          await widgetTester.pumpApp(
            HeaderPendingRequests(
              requestExpiresToday: const [],
              requestCount: 10,
              onTapRequest: (_) => DoNothingAction(),
              hasFilters: false,
              isValidatorProfile: false,
            ),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(AFTip), findsNothing);
        },
      );
      testWidgets(
        'GIVEN Pending requests header WHEN has requestsExpiresToday THEN show list',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial(),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());

          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );
          await widgetTester.pumpApp(
            Material(
              child: HeaderPendingRequests(
                requestExpiresToday: [
                  givenRequestEntityList().elementAt(0),
                  givenRequestEntityList().elementAt(1),
                ],
                requestCount: 10,
                onTapRequest: (_) => DoNothingAction(),
                hasFilters: false,
                isValidatorProfile: false,
              ),
            ),
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(find.byType(AFAccordionItem), findsOneWidget);
          expect(find.byType(RequestCard), findsNWidgets(2));
        },
      );

      testWidgets(
        'GIVEN Pending requests header WHEN has filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                pendingFilter:
                    RequestFilter.initial().copyWith(order: OrderFilter.oldest),
              ),
            ),
          );
          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());

          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            HeaderPendingRequests(
              requestExpiresToday: const [],
              requestCount: 10,
              onTapRequest: (_) => DoNothingAction(),
              hasFilters: true,
              isValidatorProfile: false,
            ),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'GIVEN Pending requests header WHEN has not filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial(),
          );

          when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
          when(multiSelection.state).thenAnswer(
            (_) => MultiSelectionRequestState.initial().copyWith(
              isButtonEnabled: false,
              isSelected: false,
              selectedRequests: {},
              showCheckbox: false,
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            HeaderPendingRequests(
              requestExpiresToday: const [],
              requestCount: 10,
              onTapRequest: (_) => DoNothingAction(),
              hasFilters: false,
              isValidatorProfile: false,
            ),
            onGetContext: (context) => myContext = context,
            providers: [
              BlocProvider<RequestsBloc>.value(value: bloc),
              BlocProvider<MultiSelectionRequestBloc>.value(
                value: multiSelection,
              ),
            ],
          );

          expect(
            find.text(myContext.localizations.request_list_title_all(10)),
            findsOneWidget,
          );
        },
      );
    });

    group('Signed requests header test', () {
      testWidgets(
        'GIVEN Signed requests header WHEN has time interval filter THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                signedFilter: RequestFilter.initial()
                    .copyWith(timeInterval: TimeIntervalFilter.lastMonth),
              ),
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderSignedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final lastMonthFilterChip =
              find.text('"${myContext.localizations.filters_last_month}"');

          expect(
            lastMonthFilterChip,
            findsOneWidget,
          );
          await widgetTester.tap(lastMonthFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'GIVEN Signed requests header WHEN has an app filter THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                signedFilter:
                    RequestFilter.initial().copyWith(app: givenRequestAppData),
              ),
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderSignedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final appFilterChip = find.text('"${givenRequestAppData.id}"');

          expect(
            appFilterChip,
            findsOneWidget,
          );
          await widgetTester.tap(appFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'GIVEN Signed requests header WHEN has an input filter THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                signedFilter: RequestFilter.initial()
                    .copyWith(inputFilter: givenAnInputFiter),
              ),
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderSignedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final inputFilterChip = find.text('"$givenAnInputFiter"');

          expect(
            inputFilterChip,
            findsOneWidget,
          );
          await widgetTester.tap(inputFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'GIVEN Signed requests header WHEN has not filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial(),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderSignedRequests(
              requestCount: 10,
              hasFilters: false,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations.signed_request_list_title(10)),
            findsOneWidget,
          );
        },
      );
    });
    group('Validated requests header test', () {
      testWidgets(
        'GIVEN Validated requests header WHEN has time interval filter THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                validatedFilter: RequestFilter.initial()
                    .copyWith(timeInterval: TimeIntervalFilter.lastMonth),
              ),
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderValidatedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final lastMonthFilterChip =
              find.text('"${myContext.localizations.filters_last_month}"');

          expect(
            lastMonthFilterChip,
            findsOneWidget,
          );
          await widgetTester.tap(lastMonthFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'GIVEN Validated requests header WHEN has an app filter THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                validatedFilter:
                    RequestFilter.initial().copyWith(app: givenRequestAppData),
              ),
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderValidatedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final appFilterChip = find.text('"${givenRequestAppData.id}"');

          expect(
            appFilterChip,
            findsOneWidget,
          );
          await widgetTester.tap(appFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'GIVEN Validated requests header WHEN has an input filter THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                validatedFilter: RequestFilter.initial()
                    .copyWith(inputFilter: givenAnInputFiter),
              ),
            ),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderValidatedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final inputFilterChip = find.text('"$givenAnInputFiter"');

          expect(
            inputFilterChip,
            findsOneWidget,
          );
          await widgetTester.tap(inputFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'GIVEN Validated requests header WHEN has not filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial(),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderValidatedRequests(
              requestCount: 10,
              hasFilters: false,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations.validated_request_list_title(10)),
            findsOneWidget,
          );
        },
      );
    });

    group('Rejected requests header test', () {
      testWidgets(
        'GIVEN Rejected requests header WHEN has filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial().copyWith(
              filters: RequestFilters.initial().copyWith(
                rejectedFilter: RequestFilter.initial()
                    .copyWith(requestType: RequestTypeFilter.sign),
              ),
            ),
          );

          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderRejectedRequests(
              requestCount: 10,
              hasFilters: true,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          final signFilterChip =
              find.text(myContext.localizations.generic_sign);
          expect(signFilterChip, findsOneWidget);

          await widgetTester.tap(signFilterChip);
          await widgetTester.pumpAndSettle();

          expect(
            find.text(myContext.localizations.request_list_title_found(10)),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'GIVEN Rejected requests header WHEN has not filters THEN show correct text',
        (widgetTester) async {
          when(bloc.stream).thenAnswer((_) => const Stream.empty());
          when(bloc.state).thenAnswer(
            (_) => RequestsState.initial(),
          );
          late BuildContext myContext;
          await widgetTester.pumpApp(
            const HeaderRejectedRequests(
              requestCount: 10,
              hasFilters: false,
            ),
            onGetContext: (context) => myContext = context,
            providers: [BlocProvider<RequestsBloc>.value(value: bloc)],
          );

          expect(
            find.text(myContext.localizations.rejected_request_list_title(10)),
            findsOneWidget,
          );
        },
      );
    });
  });

  group('Requests list test', () {
    testWidgets(
      'GIVEN Requests list WHEN has items THEN show the list',
      (widgetTester) async {
        when(multiSelection.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelection.state).thenAnswer(
          (_) => MultiSelectionRequestState.initial().copyWith(
            isButtonEnabled: false,
            isSelected: false,
            selectedRequests: {},
            showCheckbox: false,
          ),
        );

        await widgetTester.pumpApp(
          RequestList(
            header: const SizedBox(),
            isLoadingMoreItems: false,
            showError: false,
            onRetryAfterErrorTap: () => DoNothingAction(),
            onNeedMoreItems: () => DoNothingAction(),
            onRequestTap: (_) => DoNothingAction(),
            requestList: givenRequestEntityList(),
            requestStatus: RequestStatus.pending,
            onRefresh: () => DoNothingAction(),
          ),
          providers: [
            BlocProvider<MultiSelectionRequestBloc>.value(
              value: multiSelection,
            ),
          ],
        );

        expect(
          find.byType(RequestCard, skipOffstage: false),
          findsNWidgets(givenRequestEntityList().length),
        );

        expect(
          find.byType(LoadingComponent, skipOffstage: false),
          findsNothing,
        );
      },
    );

    testWidgets(
      'GIVEN Requests list WHEN has not items and loading THEN show loading',
      (widgetTester) async {
        await widgetTester.pumpApp(
          RequestList(
            header: const SizedBox(),
            isLoadingMoreItems: true,
            showError: false,
            onRetryAfterErrorTap: () => DoNothingAction(),
            onNeedMoreItems: () => DoNothingAction(),
            onRequestTap: (_) => DoNothingAction(),
            requestList: const [],
            requestStatus: RequestStatus.pending,
            onRefresh: () => DoNothingAction(),
          ),
        );

        expect(
          find.byType(LoadingComponent),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GIVEN Requests list WHEN has error THEN show error',
      (widgetTester) async {
        late BuildContext myContext;
        await widgetTester.pumpApp(
          RequestList(
            header: const SizedBox(),
            isLoadingMoreItems: true,
            showError: true,
            onRetryAfterErrorTap: () => DoNothingAction(),
            onNeedMoreItems: () => DoNothingAction(),
            onRequestTap: (_) => DoNothingAction(),
            requestList: const [],
            requestStatus: RequestStatus.pending,
            onRefresh: () => DoNothingAction(),
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(
          find.text(
            myContext.localizations.general_problem_title,
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            myContext.localizations.error_getting_request_explain,
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            myContext.localizations.general_retry,
          ),
          findsOneWidget,
        );

        expect(
          find.byType(LoadingComponent),
          findsNothing,
        );
      },
    );
  });

  group('Requests card test', () {
    testWidgets(
      'GIVEN Requests card WHEN type is pending THEN show correct data',
      (widgetTester) async {
        late BuildContext myContext;
        final request = givenRequestEntity();
        await widgetTester.pumpApp(
          RequestCard(
            requestData: request,
            onTap: () => DoNothingAction(),
            requestStatus: RequestStatus.pending,
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(
          find.text(request.subject),
          findsOneWidget,
        );

        expect(
          find.text(myContext.localizations.detail_subtitle + request.from),
          findsOneWidget,
        );

        expect(
          find.byType(AFDataCardData),
          findsOneWidget,
        );

        // Check if show expiration date
        expect(
          find.descendant(
            of: find.byType(AFDataCardHeader),
            matching: find.byType(Text),
          ),
          findsNWidgets(2),
        );

        expect(
          find.text(
            myContext.localizations
                .signed_request_date(request.lastModificationDate),
          ),
          findsNothing,
        );

        expect(
          find.text(
            myContext.localizations
                .rejected_request_date(request.lastModificationDate),
          ),
          findsNothing,
        );
      },
    );
    testWidgets(
      'GIVEN Requests card with no expiration date WHEN type is pending THEN show correct data',
      (widgetTester) async {
        late BuildContext myContext;
        final request = givenRequestEntityNotExpire();
        await widgetTester.pumpApp(
          RequestCard(
            requestData: request,
            onTap: () => DoNothingAction(),
            requestStatus: RequestStatus.pending,
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(
          find.text(request.subject),
          findsOneWidget,
        );

        expect(
          find.text(myContext.localizations.detail_subtitle + request.from),
          findsOneWidget,
        );

        expect(
          find.byType(AFDataCardData),
          findsOneWidget,
        );

        // Check if show expiration date
        expect(
          find.descendant(
            of: find.byType(AFDataCardHeader),
            matching: find.byType(Text),
          ),
          findsNWidgets(1),
        );

        expect(
          find.text(
            myContext.localizations
                .signed_request_date(request.lastModificationDate),
          ),
          findsNothing,
        );

        expect(
          find.text(
            myContext.localizations
                .rejected_request_date(request.lastModificationDate),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'GIVEN Requests card WHEN type is signed THEN show correct data',
      (widgetTester) async {
        late BuildContext myContext;
        final request = givenRequestEntity();
        await widgetTester.pumpApp(
          RequestCard(
            requestData: request,
            onTap: () => DoNothingAction(),
            requestStatus: RequestStatus.signed,
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(
          find.text(request.subject),
          findsOneWidget,
        );

        expect(
          find.text(myContext.localizations.detail_subtitle + request.from),
          findsOneWidget,
        );

        // Check if show expiration date
        expect(
          find.descendant(
            of: find.byType(AFDataCardHeader),
            matching: find.byType(Text),
          ),
          findsWidgets,
        );

        expect(
          find.byType(AFDataCardData),
          findsNothing,
        );

        expect(
          find.text(
            myContext.localizations
                .signed_request_date(request.lastModificationDate),
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            myContext.localizations
                .rejected_request_date(request.lastModificationDate),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'GIVEN Requests card WHEN type is validated THEN show correct data',
      (widgetTester) async {
        late BuildContext myContext;
        final request = givenRequestEntity();
        await widgetTester.pumpApp(
          RequestCard(
            requestData: request,
            onTap: () => DoNothingAction(),
            requestStatus: RequestStatus.pending,
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(
          find.text(request.subject),
          findsOneWidget,
        );

        expect(
          find.text(myContext.localizations.detail_subtitle + request.from),
          findsOneWidget,
        );

        // Check if show expiration date
        expect(
          find.descendant(
            of: find.byType(AFDataCardHeader),
            matching: find.byType(Text),
          ),
          findsNWidgets(2),
        );

        expect(
          find.text(
            myContext.localizations
                .rejected_request_date(request.lastModificationDate),
          ),
          findsNothing,
        );
      },
    );
    testWidgets(
      'GIVEN Requests card WHEN type is rejected THEN show correct data',
      (widgetTester) async {
        late BuildContext myContext;
        final request =
            givenRequestEntity().copyWith(rejectStatus: RejectStatus.rejected);

        await widgetTester.pumpApp(
          RequestCard(
            requestData: request,
            onTap: () => DoNothingAction(),
            requestStatus: RequestStatus.rejected,
          ),
          onGetContext: (context) => myContext = context,
        );

        expect(
          find.text(request.subject),
          findsOneWidget,
        );

        expect(
          find.text(myContext.localizations.detail_subtitle + request.from),
          findsOneWidget,
        );

        expect(
          find.text(
            request.rejectStatus?.toLocalizedString(myContext) ?? '',
          ),
          findsOneWidget,
        );

        expect(
          find.byType(AFDataCardData),
          findsOneWidget,
        );

        expect(
          find.text(
            myContext.localizations
                .rejected_request_date(request.lastModificationDate),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
