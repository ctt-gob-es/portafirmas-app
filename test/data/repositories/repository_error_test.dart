import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/errors/network_error.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

void main() {
  group(
    'Repository Error',
    () {
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.sessionExpired()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.sessionExpired(),
          ),
          const RepositoryError.sessionExpired(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.badRequestListErrors()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.badRequestListErrors(['']),
          ),
          const RepositoryError.badRequestListErrors(['']),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.infoNotMatching()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.infoNotMatching(),
          ),
          const RepositoryError.infoNotMatching(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.badRequest()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.badRequest(),
          ),
          const RepositoryError.badRequest(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.noAccess()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.forbidden(),
          ),
          const RepositoryError.noAccess(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.notFoundResource()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.notFound('_'),
          ),
          const RepositoryError.notFoundResource(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.serverError()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.internalServerError(),
          ),
          const RepositoryError.serverError(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.noInternetConnection()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.noInternetConnection(),
          ),
          const RepositoryError.noInternetConnection(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.authExpired()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.unauthorizedRequest(),
          ),
          const RepositoryError.authExpired(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.invalidCertificate()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.certNotValid(),
          ),
          const RepositoryError.invalidCertificate(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.isTimeExpired()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.sendTimeout(),
          ),
          const RepositoryError.isTimeExpired(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.serverError()',
        () => expect(
          RepositoryError.fromDataSourceError(
            const NetworkError.unableToProcess(),
          ),
          const RepositoryError.serverError(),
        ),
      );
      test(
        'GIVEN RepositoryError.fromDataSourceError WHEN call to Repository Error then show the RepositoryError.unknownError()',
        () => expect(
          RepositoryError.fromDataSourceError(''),
          const RepositoryError.unknownError(),
        ),
      );
    },
  );
}
