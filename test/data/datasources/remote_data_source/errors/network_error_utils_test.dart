import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/constants/mock_paths.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DioError getDioError(
    DioErrorType dioError,
    dynamic error,
    Response? response,
  ) =>
      DioError(
        type: dioError,
        requestOptions: RequestOptions(path: ''),
        error: error,
        response: response,
      );
  group('getErrorFromDioError', () {
    test(
      'GIVEN a DioErrorType.cancel WHEN call to getErrorFromDioError THEN return NetworkError.requestCancelled() ',
      () => expect(
        getErrorFromDioError(getDioError(DioErrorType.cancel, '', null)),
        const NetworkError.requestCancelled(),
      ),
    );
    test(
      'GIVEN a DioErrorType.connectTimeout WHEN call to getErrorFromDioError THEN return NetworkError.requestTimeout() ',
      () => expect(
        getErrorFromDioError(
          getDioError(
            DioErrorType.connectTimeout,
            '',
            null,
          ),
        ),
        const NetworkError.requestTimeout(),
      ),
    );
    test(
      'GIVEN a DioErrorType.other WHEN call to getErrorFromDioError THEN return NetworkError.mockNotFoundError() ',
      () => expect(
        getErrorFromDioError(getDioError(
          DioErrorType.other,
          MocksPaths.error,
          null,
        )),
        const NetworkError.mockNotFoundError(),
      ),
    );
    test(
      'GIVEN a DioErrorType.other WHEN call to getErrorFromDioError THEN return NetworkError.unableToProcess() ',
      () => expect(
        getErrorFromDioError(getDioError(
          DioErrorType.other,
          'is not a subtype of',
          null,
        )),
        const NetworkError.unableToProcess(),
      ),
    );
    test(
      'GIVEN a DioErrorType.other WHEN call to getErrorFromDioError THEN return NetworkError.unableToProcess() ',
      () => expect(
        getErrorFromDioError(getDioError(
          DioErrorType.other,
          'any',
          null,
        )),
        const NetworkError.noInternetConnection(),
      ),
    );
    test(
      'GIVEN a DioErrorType.receiveTimeout WHEN call to getErrorFromDioError THEN return NetworkError.sendTimeout() ',
      () => expect(
        getErrorFromDioError(getDioError(
          DioErrorType.receiveTimeout,
          'any',
          null,
        )),
        const NetworkError.sendTimeout(),
      ),
    );

    test(
      'GIVEN a DioErrorType.response WHEN call to getErrorFromDioError THEN return NetworkError.infoNotMatching() ',
      () => expect(
        getErrorFromDioError(
          getDioError(
            DioErrorType.response,
            'any',
            Response(
              requestOptions: RequestOptions(path: 'path'),
              data: {
                'error': {
                  'error_type': 'INFO_NOT_MATCHING',
                },
              },
            ),
          ),
        ),
        const NetworkError.infoNotMatching(),
      ),
    );
    test(
      'GIVEN a DioErrorType.response WHEN call to getErrorFromDioError THEN return NetworkError.badRequestListErrors() ',
      () => expect(
        getErrorFromDioError(
          getDioError(
            DioErrorType.response,
            'any',
            Response(
              requestOptions: RequestOptions(path: 'path'),
              data: {
                'error': {
                  'error_description': ['1', '2'],
                },
              },
            ),
          ),
        ),
        const NetworkError.badRequestListErrors([
          '1',
          '2',
        ]),
      ),
    );
    test(
      'GIVEN a DioErrorType.response WHEN call to getErrorFromDioError THEN return NetworkError.sendTimeout() ',
      () => expect(
        getErrorFromDioError(
          getDioError(
            DioErrorType.sendTimeout,
            'any',
            Response(
              requestOptions: RequestOptions(path: 'path'),
            ),
          ),
        ),
        const NetworkError.sendTimeout(),
      ),
    );
  });

  group(
    '_checkStatusCode',
    () {
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 400 THEN send NetworkError.badRequest()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 400,
              ),
            ),
          ),
          const NetworkError.badRequest(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 401 THEN send NetworkError.unauthorizedRequest()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 401,
              ),
            ),
          ),
          const NetworkError.unauthorizedRequest(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 403 THEN send NetworkError.forbidden()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 403,
              ),
            ),
          ),
          const NetworkError.forbidden(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 403 THEN send NetworkError.forbidden()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 404,
              ),
            ),
          ),
          const NetworkError.notFound('Not found'),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 409 THEN send NetworkError.forbidden()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 409,
              ),
            ),
          ),
          const NetworkError.conflict(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 408 THEN send NetworkError.forbidden()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 408,
              ),
            ),
          ),
          const NetworkError.requestTimeout(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 500 THEN send NetworkError.forbidden()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 500,
              ),
            ),
          ),
          const NetworkError.internalServerError(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is 503 THEN send NetworkError.forbidden()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 503,
              ),
            ),
          ),
          const NetworkError.serviceUnavailable(),
        ),
      );
      test(
        'GIVEN a _checkStatusCode WHEN the status code is default THEN send NetworkError.defaultError()',
        () => expect(
          getErrorFromDioError(
            getDioError(
              DioErrorType.response,
              'any',
              Response(
                requestOptions: RequestOptions(path: 'path'),
                statusCode: 6,
              ),
            ),
          ),
          const NetworkError.defaultError(
            'Received invalid status code: 6',
          ),
        ),
      );
    },
  );
}
