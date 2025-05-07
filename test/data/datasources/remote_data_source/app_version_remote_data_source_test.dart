import 'package:af_setup/af_setup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/config/environment_config.dart';
import 'package:portafirmas_app/app/constants/app_urls.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/app_version_remote_data_source.dart';


void main() {
  late AppVersionRemoteDataSource appVersionRemoteDataSource;

  setUp(() => appVersionRemoteDataSource = AppVersionRemoteDataSource());

  test(
    'GIVEN environment is mock WHEN getAppLatestVersion is called THEN returns mock AppVersionRemoteEntity',
    () async {
      EnvironmentConfig.environment == 'mock';

      final result = await appVersionRemoteDataSource.getAppLatestVersion();

      expect(result.minAppVersion, '0.8.0');
      expect(result.warningAppVersion, '0.9.0');
    },
  );

  test(
    'GIVEN environment is not mock WHEN getAppLatestVersion is called THEN returns correct AppVersionRemoteEntity',
    () async {
      EnvironmentConfig.environment == 'Prod';

      final response = await checkServerVersion(AppUrls.getUpdateAppUrl());

      final result = await appVersionRemoteDataSource.getAppLatestVersion();

      expect(result.minAppVersion, response['minAppVersion']);
      expect(result.warningAppVersion, response['warningAppVersion']);
    },
  );
}
