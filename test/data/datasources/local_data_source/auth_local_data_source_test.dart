import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portafirmas_app/data/datasources/local_data_source/auth_local_data_source.dart';

import 'auth_local_data_source_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late AuthLocalDataSource authLocalDataSource;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    authLocalDataSource = AuthLocalDataSource(mockStorage);
  });

  group('AuthLocalDataSource', () {
    test('should retrieve session ID', () async {
      when(mockStorage.read(key: 'sessionId'))
          .thenAnswer((_) async => 'test-session-id');
      final sessionId = await authLocalDataSource.retrieveSessionId();
      expect(sessionId, 'test-session-id');
      verify(mockStorage.read(key: 'sessionId')).called(1);
    });

    test('should save session ID', () async {
      const sessionId = 'test-session-id';
      await authLocalDataSource.saveSessionId(sessionId);
      verify(mockStorage.write(key: 'sessionId', value: sessionId)).called(1);
    });

    test('should remove session ID', () async {
      await authLocalDataSource.removeSessionId();
      verify(mockStorage.write(key: 'sessionId', value: null)).called(1);
    });

    test('should retrieve public key', () async {
      when(mockStorage.read(key: 'publicKey'))
          .thenAnswer((_) async => 'test-public-key');
      final publicKey = await authLocalDataSource.retrievePublicKey();
      expect(publicKey, 'test-public-key');
      verify(mockStorage.read(key: 'publicKey')).called(1);
    });

    test('should save public key', () async {
      const publicKey = 'test-public-key';
      await authLocalDataSource.savePublicKey(publicKey);
      verify(mockStorage.write(key: 'publicKey', value: publicKey)).called(1);
    });

    test('should remove public key', () async {
      await authLocalDataSource.savePublicKey('');
      verify(mockStorage.write(key: 'publicKey', value: '')).called(1);
    });

    test('should retrieve last auth method', () async {
      when(mockStorage.read(key: 'auth_method'))
          .thenAnswer((_) async => 'password');
      final authMethod = await authLocalDataSource.getLastAuthMethod();
      expect(authMethod, 'password');
      verify(mockStorage.read(key: 'auth_method')).called(1);
    });

    test('should set last auth method', () async {
      const authMethod = 'password';
      await authLocalDataSource.setLastAuthMethod(authMethod);
      verify(mockStorage.write(key: 'auth_method', value: authMethod))
          .called(1);
    });

    test('should delete last auth method', () async {
      await authLocalDataSource.deleteLastAuthMethod();
      verify(mockStorage.write(key: 'auth_method', value: null)).called(1);
    });

    test('should retrieve user NIF', () async {
      when(mockStorage.read(key: 'nifKey'))
          .thenAnswer((_) async => '12345678A');
      final nif = await authLocalDataSource.getUserNif();
      expect(nif, '12345678A');
      verify(mockStorage.read(key: 'nifKey')).called(1);
    });

    test('should save user NIF', () async {
      const nif = '12345678A';
      await authLocalDataSource.saveUserNif(nif);
      verify(mockStorage.write(key: 'nifKey', value: nif)).called(1);
    });

    test('should delete user NIF', () async {
      await authLocalDataSource.deleteUserNif();
      verify(mockStorage.delete(key: 'nifKey')).called(1);
    });

    test('should check if user is first time', () async {
      when(mockStorage.read(key: 'firstTimeKey')).thenAnswer((_) async => null);
      final isFirstTime = await authLocalDataSource.isUserFirstTime();
      expect(isFirstTime, true);
      verify(mockStorage.read(key: 'firstTimeKey')).called(1);
    });

    test('should set first time to false', () async {
      await authLocalDataSource.setFirstTime();
      verify(mockStorage.write(key: 'firstTimeKey', value: 'false')).called(1);
    });
  });
}
