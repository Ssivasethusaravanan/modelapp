import 'package:flutter_test/flutter_test.dart';
import 'package:team_management_app/injection.dart';

void main() {
  group('Injection', () {
    test('configureDependencies should execute without error', () {
      // Since getIt is a singleton, this might be tricky if already initialized.
      // But we just want to cover the line.
      expect(() => configureDependencies(), returnsNormally);
    });
  });
}
