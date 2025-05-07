import 'package:app_factory_ui/app_factory_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/app/extensions/context_extensions.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/domain/models/approved_request_entity.dart';
import 'package:portafirmas_app/domain/models/post_sign_req_entity.dart';
import 'package:portafirmas_app/presentation/features/detail/bloc/detail_request_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/multiselection_bloc/multiselection_bloc.dart';
import 'package:portafirmas_app/presentation/features/home/requests_bloc/requests_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/bloc/sign_bloc.dart';
import 'package:portafirmas_app/presentation/features/sign/model/sign_methods.dart';

import '../../../instruments/pump_app.dart';
import '../../../instruments/requests_instruments.dart';
import 'sign_methods_test.mocks.dart';

@GenerateMocks([
  DetailRequestBloc,
  RequestsBloc,
  MultiSelectionRequestBloc,
  SignBloc,
])
void main() {
  late BuildContext myContext;
  late MockRequestsBloc requestsBloc;
  late MockDetailRequestBloc detailRequestBloc;
  late MockMultiSelectionRequestBloc multiSelectionRequestBloc;
  late MockSignBloc signBloc;

  setUp(() {
    requestsBloc = MockRequestsBloc();
    detailRequestBloc = MockDetailRequestBloc();
    multiSelectionRequestBloc = MockMultiSelectionRequestBloc();
    signBloc = MockSignBloc();
  });

  Widget content(
    ActionType type,
    ScreenStatus status,
    bool isSingleRequest,
    bool isDetailScreen,
    int rejectedReqsLength,
    int? validatedReqsLength,
    String? signUrl,
    List<ApprovedRequestEntity>? approvedReqs,
    List<PostSignReqEntity>? signedReqs,
  ) =>
      MultiBlocProvider(
        providers: [
          BlocProvider<DetailRequestBloc>.value(value: detailRequestBloc),
          BlocProvider<RequestsBloc>.value(value: requestsBloc),
          BlocProvider<MultiSelectionRequestBloc>.value(
            value: multiSelectionRequestBloc,
          ),
          BlocProvider<SignBloc>.value(
            value: signBloc,
          ),
        ],
        child: Builder(builder: (context) {
          myContext = context;

          return AFButton.primary(
            onPressed: () => SignMethods.signListener(
              myContext,
              SignState(
                action: type,
                screenStatus: status,
                isSingleRequest: isSingleRequest,
                rejectedReqsLength: rejectedReqsLength,
                signUrl: signUrl,
                signedReqs: signedReqs,
                approvedReqs: approvedReqs,
                validatedReqsLength: validatedReqsLength,
              ),
              isDetailScreen,
            ),
            text: 'test',
          );
        }),
      );

  group('SignMethods Screen Status error', () {
    testWidgets(
      'Given a modal error WHEN isDetailScreen TRUE and the actions revoke, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.revoke,
            const ScreenStatus.error(),
            true,
            true,
            0,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.revoke_request_failed),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Given a modal error WHEN isDetailScreen FALSE and the actions revoke, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.revoke,
            const ScreenStatus.error(),
            false,
            true,
            0,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.revoke_requests_failed),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Given a modal error WHEN isDetailScreen TRUE and the actions signVb, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.signVb,
            const ScreenStatus.error(),
            true,
            true,
            0,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.error_signing_document_title),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Given a modal error WHEN isDetailScreen FALSE and the actions signVb, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.signVb,
            const ScreenStatus.error(),
            false,
            true,
            0,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.error_signing_document_title),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Given a modal error WHEN isDetailScreen FALSE and the actions signVb, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.validate,
            const ScreenStatus.error(),
            true,
            true,
            0,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.validate_request_failed),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Given a modal error WHEN isDetailScreen FALSE and the actions signVb, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.validate,
            const ScreenStatus.error(),
            false,
            true,
            0,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.validate_requests_failed),
          findsOneWidget,
        );
      },
    );
  });
  group('SignMethods Screen Status success', () {
    testWidgets(
      'Given a modal WHEN isDetailScreen TRUE and the actions type is  revoke, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.revoke,
            const ScreenStatus.success(),
            true,
            true,
            1,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.reject_module_simple_subtitle),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Given a modal WHEN isDetailScreen FALSE and the actions type is  revoke, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelectionRequestBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        await tester.pumpApp(
          content(
            ActionType.revoke,
            const ScreenStatus.success(),
            true,
            false,
            3,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.reject_module_plural_subtitle(3)),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Given a modal WHEN isDetailScreen TRUE, the actions type is signVb, and SignUrl is null, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelectionRequestBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());

        await tester.pumpApp(
          content(
            ActionType.signVb,
            const ScreenStatus.success(),
            true,
            true,
            1,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.sign_validate_request_failed),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Given a modal WHEN isDetailScreen TRUE, the actions type is signVb, and SignUrl is null, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelectionRequestBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());

        await tester.pumpApp(
          content(
            ActionType.signVb,
            const ScreenStatus.success(),
            true,
            false,
            1,
            null,
            null,
            null,
            null,
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();

        expect(
          find.text(myContext.localizations.sign_validate_requests_failed),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Given a modal WHEN isDetailScreen TRUE, the actions type is signVb, and SignUrl is null, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelectionRequestBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState(
              action: ActionType.signVb,
              screenStatus: const ScreenStatus.success(),
              isSingleRequest: true,
              signedReqs: givenPostSignReqEntityList(),
            ));

        await tester.pumpApp(
          content(
            ActionType.signVb,
            const ScreenStatus.success(),
            true,
            true,
            1,
            1,
            'SignUrl',
            givenApprovedRequestEntityList(),
            givenPostSignReqEntityList(),
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
        expect(
          find.text(
            myContext.localizations.detail_sign_module_final_text_simple,
          ),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Given a modal WHEN isDetailScreen TRUE, the actions type is signVb, and SignUrl is null, then show the correct text',
      (tester) async {
        when(detailRequestBloc.stream).thenAnswer((_) => const Stream.empty());
        when(requestsBloc.stream).thenAnswer((_) => const Stream.empty());
        when(multiSelectionRequestBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(signBloc.stream).thenAnswer((_) => const Stream.empty());
        when(signBloc.state).thenAnswer((_) => SignState.initial());

        await tester.pumpApp(
          content(
            ActionType.signVb,
            const ScreenStatus.success(),
            true,
            true,
            1,
            1,
            'SignUrl',
            givenApprovedRequestEntityList(),
            givenPostSignReqEntityList(),
          ),
        );

        await tester.tap(find.text('test'));
        await tester.pumpAndSettle();
      },
    );
  });
}
