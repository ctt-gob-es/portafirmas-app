import 'package:flutter_test/flutter_test.dart';
import 'package:portafirmas_app/domain/models/auth_method.dart';

void main() {
  group('AuthMethodExtension', () {
    test('should return correct label for certificate', () {
      const authMethod = AuthMethod.certificate();
      expect(authMethod.toStringLabel(), 'certificate');
    });

    test('should return correct label for clave', () {
      const authMethod = AuthMethod.clave();
      expect(authMethod.toStringLabel(), 'clave');
    });
  });
}
