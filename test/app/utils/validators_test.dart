import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/app/utils/validators.dart';

void main() {
  group('URL Validation Tests', () {
    test('checkURlServer should return true for valid server URLs', () {
      expect(checkURlServer('https://www.example.com'), true);
      expect(checkURlServer('https://example.com'), true);
      expect(checkURlServer('https://www.example.com/path'), true);
      expect(checkURlServer('https://example.com:8080'), true);
      expect(checkURlServer('https://example.com/path?query=param'), true);
      expect(checkURlServer('https://www.example.com/path#fragment'), true);
    });

    test('checkURlServer should return false for invalid server URLs', () {
      expect(checkURlServer('http://example.com'), false);
      expect(checkURlServer('example.com'), false);
      expect(checkURlServer('https://'), false);
      expect(checkURlServer('ftp://example.com'), false);
      expect(checkURlServer('https://[::1]'), false);
      expect(checkURlServer(''), false);
      expect(checkURlServer(null), false);
    });
  });
}
