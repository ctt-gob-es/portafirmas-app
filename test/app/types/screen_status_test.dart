import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/types/screen_status.dart';
import 'package:portafirmas_app/data/repositories/repository_error.dart';

void main() {
  group('ScreenStatus Tests', () {
    test('Initial should be identified as initial', () {
      const status = ScreenStatus.initial();

      expect(status.isLoading(), false);
      expect(status.isLoadingMore(), false);
      expect(status.isError(), false);
      expect(status.isSuccess(), false);
    });

    test('Loading should be identified as loading', () {
      const status = ScreenStatus.loading();

      expect(status.isLoading(), true);
      expect(status.isLoadingMore(), false);
      expect(status.isError(), false);
      expect(status.isSuccess(), false);
    });

    test('Success should be identified as success', () {
      const status = ScreenStatus.success();

      expect(status.isLoading(), false);
      expect(status.isLoadingMore(), false);
      expect(status.isError(), false);
      expect(status.isSuccess(), true);
    });

    test('LoadingMore should be identified as loadingMore', () {
      const status = ScreenStatus.loadingMore();

      expect(status.isLoading(), false);
      expect(status.isLoadingMore(), true);
      expect(status.isError(), false);
      expect(status.isSuccess(), false);
    });

    test('Error should be identified as error', () {
      const error = RepositoryError.sessionExpired();
      const status = ScreenStatus.error(error);

      expect(status.isError(), true);
      expect(status.isLoading(), false);
      expect(status.isSuccess(), false);
      expect(status.isSessionExpiredError(), true);
      expect(status.isTimeExpired(), false);
    });

    test('Error should identify sessionExpiredError', () {
      const error = RepositoryError.sessionExpired();
      const status = ScreenStatus.error(error);

      expect(status.isSessionExpiredError(), true);
    });

    test('Error should not identify timeExpired error', () {
      const error = RepositoryError.isTimeExpired();
      const status = ScreenStatus.error(error);

      expect(status.isTimeExpired(), true);
    });

    test('Error should not match unexpected error', () {
      const error = RepositoryError.unknownError();
      const status = ScreenStatus.error(error);

      expect(status.isSessionExpiredError(), false);
      expect(status.isTimeExpired(), false);
    });
  });
}
