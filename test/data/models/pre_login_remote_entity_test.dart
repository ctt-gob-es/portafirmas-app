import 'package:dio/dio.dart';
import 'package:portafirmas_app/data/models/login_clave_remote_entity.dart';
import 'package:portafirmas_app/data/models/pre_login_remote_entity.dart';
import 'package:flutter_test/flutter_test.dart';
 
void main() {
  group('LoginClaveRemoteEntity', () {
    test('should create an instance from JSON with cookie correctly', () {
      final Map<String, dynamic> json = {
        '__cdata': 'https://example.com',
      };

      final headers = Headers();
      headers.set('set-cookie', 'JSESSIONID=1234567890');

      final entity = LoginClaveRemoteEntity.fromJsonWithCookie(json, headers);

      expect(entity.url, 'https://example.com');
      expect(entity.cookies['Cookie'], 'JSESSIONID=1234567890');
    });

    test('should handle case where no JSESSIONID cookie is present', () {
      final Map<String, dynamic> json = {
        '__cdata': 'https://example.com',
      };

      final headers = Headers();
      headers.set('set-cookie', 'SESSIONID=9876543210');

      final entity = LoginClaveRemoteEntity.fromJsonWithCookie(json, headers);

      expect(entity.url, 'https://example.com');
      expect(entity.cookies['Cookie'], 'SESSIONID=9876543210');
    });

    test('should create an instance from JSON without cookies correctly', () {
      final Map<String, dynamic> json = {
        '__cdata': 'https://example.com',
      };

      final headers = Headers();

      final entity = LoginClaveRemoteEntity.fromJsonWithCookie(json, headers);

      expect(entity.url, 'https://example.com');
      expect(entity.cookies['Cookie'], isNotEmpty);
    });

    test(
      'should create PreLoginRemoteEntity from JSON with valid cookie headers',
      () {
        final json = {
          '\$t': 'login_request_data',
        };

        final headers = Headers.fromMap({
          'set-cookie': [
            'JSESSIONID=abc123; Path=/; HttpOnly',
            'OTHER_COOKIE=value; Path=/; Secure',
          ],
        });

        final result = PreLoginRemoteEntity.fromJsonWithCookie(json, headers);

        expect(result.loginRequest, 'login_request_data');
        expect(result.cookie, 'JSESSIONID=abc123; Path=/; HttpOnly');
      },
    );

    test(
      'should create PreLoginRemoteEntity with fallback when cookie headers are not a list',
      () {
        final json = {
          '\$t': 'login_request_data',
        };

        final headers = Headers.fromMap({
          'set-cookie': ['JSESSIONID=abc123; Path=/; HttpOnly'],
        });

        final result = PreLoginRemoteEntity.fromJsonWithCookie(json, headers);

        expect(result.loginRequest, 'login_request_data');
        expect(result.cookie, 'JSESSIONID=abc123; Path=/; HttpOnly');
      },
    );

    test(
      'should throw an error if cookie matching sessionCookieName is not found',
      () {
        final json = {
          '\$t': 'login_request_data',
        };

        final headers = Headers.fromMap({
          'set-cookie': [
            'OTHER_COOKIE=value; Path=/; Secure',
          ],
        });

        expect(
          () => PreLoginRemoteEntity.fromJsonWithCookie(json, headers),
          throwsA(isA<StateError>()),
        );
      },
    );

    test('should throw an error if no cookie header is present', () {
      final json = {
        '\$t': 'login_request_data',
      };

      final headers = Headers.fromMap({});

      expect(
        () => PreLoginRemoteEntity.fromJsonWithCookie(json, headers),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
